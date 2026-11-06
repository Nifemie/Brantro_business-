import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/endpoints.dart';
import '../../../core/network/api_client.dart';

final likeRepositoryProvider = Provider<LikeRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return LikeRepository(apiClient);
});

class LikeRepository {
  final ApiClient apiClient;

  LikeRepository(this.apiClient);

  Future<int> fetchUserLikeStats() async {
    try {
      final response = await apiClient.get(ApiEndpoints.likeStatsUser);
      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload is Map<String, dynamic>) {
          return (payload['count'] as num?)?.toInt() ??
              (payload['totalLikes'] as num?)?.toInt() ??
              (payload['total'] as num?)?.toInt() ??
              0;
        } else if (payload is num) {
          return payload.toInt();
        }
      }
      return 0;
    } on DioException catch (e) {
      log('[LikeRepository] Failed to fetch like stats: ${e.message}');
      return 0;
    } catch (e) {
      log('[LikeRepository] Error fetching like stats: $e');
      return 0;
    }
  }

  Future<int> fetchTargetLikesCount(String targetType, dynamic targetId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.likesByTarget,
        query: {
          'type': targetType.toUpperCase(),
          'id': targetId,
        },
      );
      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload is Map<String, dynamic>) {
          return (payload['count'] as num?)?.toInt() ??
              (payload['total'] as num?)?.toInt() ??
              0;
        } else if (payload is List) {
          return payload.length;
        }
      }
      return 0;
    } catch (e) {
      log('[LikeRepository] Failed to fetch target likes: $e');
      return 0;
    }
  }

  Future<bool> addLike({
    required String targetType,
    required dynamic targetId,
  }) async {
    try {
      final payload = {
        'targetType': targetType.toUpperCase(),
        'targetId': targetId is int ? targetId : int.tryParse(targetId.toString()) ?? 0,
      };

      final response = await apiClient.post(
        ApiEndpoints.createLike,
        data: payload,
      );

      return response.data != null && response.data['success'] == true;
    } on DioException catch (e) {
      log('[LikeRepository] Failed to add like: ${e.message}');
      return false;
    } catch (e) {
      log('[LikeRepository] Error adding like: $e');
      return false;
    }
  }

  Future<bool> removeLike(dynamic id) async {
    try {
      final response = await apiClient.delete(ApiEndpoints.deleteLike(id));
      return response.data != null && response.data['success'] == true;
    } catch (e) {
      log('[LikeRepository] Failed to remove like: $e');
      return false;
    }
  }
}
