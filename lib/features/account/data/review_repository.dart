import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/endpoints.dart';
import '../../../core/network/api_client.dart';
import 'models/review_model.dart';
import 'models/review_stats_model.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ReviewRepository(apiClient);
});

class ReviewRepository {
  final ApiClient apiClient;

  ReviewRepository(this.apiClient);

  Future<List<ReviewModel>> fetchTargetReviews({
    required String targetType,
    required dynamic targetId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.reviewsByTarget,
        query: {
          'type': targetType,
          'id': targetId,
          'page': page,
          'size': size,
        },
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload != null && payload['page'] is List) {
          final List<dynamic> items = payload['page'];
          return items.map((j) => ReviewModel.fromJson(j as Map<String, dynamic>)).toList();
        } else if (payload is List) {
          return payload.map((j) => ReviewModel.fromJson(j as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      log('[ReviewRepository] Failed to fetch target reviews: ${e.message}');
      return [];
    } catch (e) {
      log('[ReviewRepository] Error fetching target reviews: $e');
      return [];
    }
  }

  Future<List<ReviewModel>> fetchUserReviews({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.reviewsByUser,
        query: {
          'page': page,
          'size': size,
        },
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload != null && payload['page'] is List) {
          final List<dynamic> items = payload['page'];
          return items.map((j) => ReviewModel.fromJson(j as Map<String, dynamic>)).toList();
        } else if (payload is List) {
          return payload.map((j) => ReviewModel.fromJson(j as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      log('[ReviewRepository] Failed to fetch user reviews: ${e.message}');
      return [];
    } catch (e) {
      log('[ReviewRepository] Error fetching user reviews: $e');
      return [];
    }
  }

  Future<ReviewStatsModel> fetchUserReviewStats() async {
    try {
      final response = await apiClient.get(ApiEndpoints.reviewStatsUser);
      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload is Map<String, dynamic>) {
          return ReviewStatsModel.fromJson(payload);
        }
      }
      return const ReviewStatsModel();
    } on DioException catch (e) {
      log('[ReviewRepository] Failed to fetch review stats: ${e.message}');
      return const ReviewStatsModel();
    } catch (e) {
      log('[ReviewRepository] Error fetching review stats: $e');
      return const ReviewStatsModel();
    }
  }

  Future<bool> createReview({
    required String targetType,
    required dynamic targetId,
    required double rating,
    required String reviewText,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final payload = {
        'targetType': targetType.toUpperCase(),
        'targetId': targetId is int ? targetId : int.tryParse(targetId.toString()) ?? 0,
        'rating': rating,
        'reviewText': reviewText,
        'comment': {'text': reviewText},
        'metadata': metadata ?? {},
      };

      final response = await apiClient.post(
        ApiEndpoints.createReview,
        data: payload,
      );

      return response.data != null && response.data['success'] == true;
    } on DioException catch (e) {
      log('[ReviewRepository] Failed to submit review: ${e.message}');
      throw Exception(e.response?.data?['message'] ?? 'Failed to submit review');
    } catch (e) {
      log('[ReviewRepository] Error submitting review: $e');
      throw Exception('An unexpected error occurred while submitting review.');
    }
  }

  Future<bool> deleteReview(dynamic id) async {
    try {
      final response = await apiClient.delete(ApiEndpoints.deleteReview(id));
      return response.data != null && response.data['success'] == true;
    } catch (e) {
      log('[ReviewRepository] Failed to delete review $id: $e');
      return false;
    }
  }
}
