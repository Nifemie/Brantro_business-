import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import 'package:brantro_business/core/service/session_service.dart';
import '../data/repositories/screen_repository.dart';
import '../data/models/screen_model.dart';

class ScreenNotifier extends StateNotifier<DataState<ScreenModel>> {
  final ScreenRepository _repository;
  Map<String, String?> selectedFilters = {};
  String searchQuery = '';
  List<ScreenModel> _allRawScreens = [];

  ScreenNotifier(this._repository) : super(DataState.initial()) {
    fetchScreens();
  }

  // Expose repository for file uploads
  ScreenRepository get repository => _repository;

  Future<void> updateFilters(Map<String, String?> filters) async {
    selectedFilters = Map.from(filters);
    await fetchScreens(refresh: true);
  }

  Future<void> removeFilter(String key) async {
    selectedFilters.remove(key);
    await fetchScreens(refresh: true);
  }

  Future<void> clearFilters() async {
    selectedFilters.clear();
    await fetchScreens(refresh: true);
  }

  Future<void> updateSearch(String query) async {
    searchQuery = query;
    _applyFiltersAndEmit();
  }

  void _applyFiltersAndEmit() {
    List<ScreenModel> filtered = List.of(_allRawScreens);

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((s) {
        return s.name.toLowerCase().contains(query) ||
            s.location.toLowerCase().contains(query) ||
            s.address.toLowerCase().contains(query);
      }).toList();
    }

    if (selectedFilters.isNotEmpty) {
      selectedFilters.forEach((key, val) {
        if (val == null || val.isEmpty || val == 'All') return;
        final value = val.toLowerCase();
        if (key.toLowerCase() == 'location') {
          filtered = filtered
              .where((s) => s.location.toLowerCase().contains(value))
              .toList();
        } else if (key.toLowerCase() == 'screen type') {
          filtered = filtered
              .where((s) => s.type.toLowerCase().contains(value))
              .toList();
        } else if (key.toLowerCase() == 'status') {
          filtered = filtered
              .where((s) => s.status.toLowerCase() == value)
              .toList();
        } else if (key.toLowerCase() == 'price range') {
          final parts = val.split('-');
          if (parts.length == 2) {
            final min = double.tryParse(parts[0].trim()) ?? 0;
            final max = double.tryParse(parts[1].trim()) ?? double.infinity;
            filtered = filtered
                .where((s) => s.price >= min && s.price <= max)
                .toList();
          }
        }
      });
    }

    state = state.copyWith(
      data: filtered,
      isInitialLoading: false,
      isPaginating: false,
      isDataAvailable: filtered.isNotEmpty,
    );
  }

  Future<void> uploadScreen(Map<String, dynamic> data) async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      await _repository.createLocation(data);
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Screen uploaded successfully',
      );
      // Reload screens after upload
      await refreshScreens();
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> updateScreen(String id, Map<String, dynamic> data) async {
    state = state.copyWith(isInitialLoading: true, message: null);

    try {
      await _repository.updateLocation(id, data);
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Screen updated successfully',
      );
      // Reload screens after update
      await refreshScreens();
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> deleteScreen(String id) async {
    try {
      await _repository.deleteLocation(id);

      _allRawScreens.removeWhere((s) => s.id.toString() == id.toString());
      _applyFiltersAndEmit();
      await refreshScreens();
    } catch (e) {
      state = state.copyWith(
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> refreshScreens() async {
    await fetchScreens(page: 0, size: 20, refresh: true);
  }

  Future<void> fetchScreens({
    int page = 0,
    int size = 20,
    bool refresh = false,
  }) async {
    if (refresh) {
      if ((state.data ?? []).isEmpty) {
        state = state.resetMessage().copyWith(isInitialLoading: true);
      } else {
        state = state.resetMessage();
      }
    } else if (state.isPaginating) {
      return;
    } else {
      state = state.copyWith(isPaginating: true);
    }

    try {
      final user = await SessionService.getUser();
      final userId = user != null ? (user['id'] ?? user['userId']) : null;

      final response = await _repository.getLocations(
        page: page,
        size: size,
        type: 'SCREEN',
        createdById: userId,
        search: searchQuery,
        filters: selectedFilters,
      );

      final List<dynamic> pageList = response['page'] ?? [];
      final List<ScreenModel> screens =
          pageList.map((item) => ScreenModel.fromJson(item)).toList();

      if (refresh) {
        _allRawScreens = screens;
      } else {
        _allRawScreens.addAll(screens);
      }

      _applyFiltersAndEmit();
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        isPaginating: false,
        message: e.toString(),
      );
    }
  }
}
