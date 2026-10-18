import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/service/local_storage_service.dart';
import '../data/models/announcement_model.dart';

const String _kAnnouncementsCacheKey = 'cached_announcements';

class AnnouncementState {
  final List<AnnouncementModel> announcements;
  final bool isLoading;
  final String? error;

  AnnouncementState({
    this.announcements = const [],
    this.isLoading = false,
    this.error,
  });

  AnnouncementState copyWith({
    List<AnnouncementModel>? announcements,
    bool? isLoading,
    String? error,
  }) {
    return AnnouncementState(
      announcements: announcements ?? this.announcements,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AnnouncementNotifier extends StateNotifier<AnnouncementState> {
  final ApiClient _apiClient;

  AnnouncementNotifier(this._apiClient) : super(AnnouncementState()) {
    _init();
  }

  Future<void> _init() async {
    await _loadCachedAnnouncements();
    await fetchAnnouncements();
  }

  Future<void> _loadCachedAnnouncements() async {
    try {
      final raw = await LocalStorageService.getString(_kAnnouncementsCacheKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          final list = decoded
              .whereType<Map>()
              .map((item) => AnnouncementModel.fromJson(
                    item.map((k, v) => MapEntry(k.toString(), v)),
                  ))
              .toList();
          if (list.isNotEmpty) {
            state = state.copyWith(announcements: list);
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _saveCachedAnnouncements(List<AnnouncementModel> list) async {
    try {
      final encoded = jsonEncode(list.map((a) => a.toJson()).toList());
      await LocalStorageService.setString(_kAnnouncementsCacheKey, encoded);
    } catch (_) {}
  }

  Future<void> fetchAnnouncements({String? query}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = query != null && query.isNotEmpty
          ? await _apiClient.get(
              ApiEndpoints.searchAnnouncements,
              query: {'q': query, 'page': 1, 'size': 50},
            )
          : await _apiClient.get(
              ApiEndpoints.announcementsList,
              query: {'page': 1, 'size': 50},
            );

      final data = response.data;
      List<AnnouncementModel> apiList = [];
      dynamic rawList;
      if (data is Map) {
        rawList = data['payload'] ?? data['data'] ?? data['announcements'] ?? data['results'];
      } else {
        rawList = data;
      }

      if (rawList is List) {
        apiList = rawList
            .whereType<Map>()
            .map((item) => AnnouncementModel.fromJson(
                  item.map((k, v) => MapEntry(k.toString(), v)),
                ))
            .toList();
      }

      if (query != null && query.isNotEmpty) {
        state = state.copyWith(announcements: apiList, isLoading: false);
      } else {
        // Merge API list with cached local state (preserve locally created items)
        final existingLocal = List<AnnouncementModel>.from(state.announcements);
        final Map<String, AnnouncementModel> mergedMap = {};

        for (final item in apiList) {
          if (item.id.isNotEmpty) {
            mergedMap[item.id] = item;
          }
        }

        for (final localItem in existingLocal) {
          if (!mergedMap.containsKey(localItem.id)) {
            mergedMap[localItem.id] = localItem;
          }
        }

        final mergedList = mergedMap.values.toList();
        mergedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        state = state.copyWith(announcements: mergedList, isLoading: false);
        await _saveCachedAnnouncements(mergedList);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Keep existing cached announcements on 404
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: e.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addAnnouncement({
    required String title,
    required String audience,
    String? category,
    String? actionText,
    String? actionUrl,
    required String description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final localId = 'ann_${DateTime.now().millisecondsSinceEpoch}';
    final fallbackModel = AnnouncementModel(
      id: localId,
      title: title,
      audience: audience,
      category: category,
      actionText: actionText,
      actionUrl: actionUrl,
      description: description,
      createdAt: DateTime.now(),
    );

    // Immediately persist locally
    final updatedList = [fallbackModel, ...state.announcements.where((a) => a.id != localId)];
    state = state.copyWith(announcements: updatedList, isLoading: false);
    await _saveCachedAnnouncements(updatedList);

    try {
      final payload = <String, dynamic>{
        'title': title,
        'audience': audience.toUpperCase(),
        'category': (category != null && category.isNotEmpty) ? category : 'General',
        'description': description,
        if (actionText != null && actionText.isNotEmpty) 'actionText': actionText,
        if (actionUrl != null && actionUrl.isNotEmpty) 'actionURL': actionUrl,
      };

      final response = await _apiClient.post(
        ApiEndpoints.createAnnouncement,
        data: payload,
      );

      final respData = response.data;
      Map<String, dynamic>? itemMap;

      if (respData is Map) {
        final rawItem = respData['payload'] ?? respData['data'] ?? respData;
        if (rawItem is Map) {
          itemMap = rawItem.map((k, v) => MapEntry(k.toString(), v));
        }
      }

      if (itemMap != null &&
          (itemMap.containsKey('id') || itemMap.containsKey('announcementId') || itemMap.containsKey('title'))) {
        final serverAnnouncement = AnnouncementModel.fromJson(itemMap);
        final reconciledList = state.announcements.map((a) {
          if (a.id == localId) {
            return serverAnnouncement;
          }
          return a;
        }).toList();
        state = state.copyWith(announcements: reconciledList);
        await _saveCachedAnnouncements(reconciledList);
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to create announcement';
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          final msg = data['message'];
          if (msg is List) {
            errorMessage = msg.join(', ');
          } else if (msg is String) {
            errorMessage = msg;
          } else {
            errorMessage = data['error']?.toString() ?? errorMessage;
          }
        } else if (data is String) {
          errorMessage = data;
        }
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = e.message!;
      }
      state = state.copyWith(error: errorMessage);
      throw Exception(errorMessage);
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(error: msg);
      throw Exception(msg);
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    final updated = state.announcements.where((ann) => ann.id != id).toList();
    state = state.copyWith(announcements: updated);
    await _saveCachedAnnouncements(updated);

    try {
      await _apiClient.delete(ApiEndpoints.deleteAnnouncement(id));
    } catch (_) {}
  }
}

final announcementProvider =
    StateNotifierProvider<AnnouncementNotifier, AnnouncementState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AnnouncementNotifier(apiClient);
});
