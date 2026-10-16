import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/ad_placement_model.dart';

final adPlacementRepositoryProvider = Provider<AdPlacementRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AdPlacementRepository(apiClient);
});

class AdPlacementRepository {
  final ApiClient apiClient;

  AdPlacementRepository(this.apiClient);

  Future<List<AdPlacementModel>> fetchAdPlacements({
    int page = 0,
    int size = 20,
    required String campaignOrderId,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'size': size,
        'campaignOrderId': campaignOrderId,
      };

      final response = await apiClient.get(
        ApiEndpoints.adPlacementList,
        query: queryParams,
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload != null && payload['page'] != null) {
          final List<dynamic> data = payload['page'];
          return data.map((json) => AdPlacementModel.fromJson(json)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      log('DioException in fetchAdPlacements: ${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to load ad placements');
    } catch (e) {
      log('Exception in fetchAdPlacements: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  Future<List<AdPlacementModel>> searchAdPlacements({
    required String query,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'page': page,
        'size': size,
      };

      final response = await apiClient.get(
        ApiEndpoints.searchAdPlacements,
        query: queryParams,
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload != null && payload['page'] != null) {
          final List<dynamic> data = payload['page'];
          return data.map((json) => AdPlacementModel.fromJson(json)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      log('DioException in searchAdPlacements: ${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to search ad placements');
    } catch (e) {
      log('Exception in searchAdPlacements: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  Future<AdPlacementModel> acceptPlacement(int id) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.acceptAdPlacement(id),
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        return AdPlacementModel.fromJson(payload);
      }
      throw Exception(response.data?['message'] ?? 'Failed to accept placement');
    } on DioException catch (e) {
      log('DioException in acceptPlacement: ${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to accept placement');
    } catch (e) {
      log('Exception in acceptPlacement: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  Future<AdPlacementModel> rejectPlacement(int id, String reason) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.rejectAdPlacement(id),
        data: {'reason': reason},
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        return AdPlacementModel.fromJson(payload);
      }
      throw Exception(response.data?['message'] ?? 'Failed to reject placement');
    } on DioException catch (e) {
      log('DioException in rejectPlacement: ${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to reject placement');
    } catch (e) {
      log('Exception in rejectPlacement: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  Future<AdPlacementModel> inProgressPlacement(int id) async {
    try {
      final response = await apiClient.put(ApiEndpoints.inProgressAdPlacement(id));
      if (response.data != null && response.data['success'] == true) {
        return AdPlacementModel.fromJson(response.data['payload']);
      }
      throw Exception(response.data?['message'] ?? 'Failed to mark as in progress');
    } on DioException catch (e) {
      log('DioException in inProgressPlacement: ${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to mark as in progress');
    } catch (e) {
      log('Exception in inProgressPlacement: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  Future<AdPlacementModel> completePlacement(int id) async {
    try {
      final response = await apiClient.put(ApiEndpoints.completeAdPlacement(id));
      if (response.data != null && response.data['success'] == true) {
        return AdPlacementModel.fromJson(response.data['payload']);
      }
      throw Exception(response.data?['message'] ?? 'Failed to complete placement');
    } on DioException catch (e) {
      log('DioException in completePlacement: ${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to complete placement');
    } catch (e) {
      log('Exception in completePlacement: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  Future<AdPlacementModel> cancelPlacement(int id, String reason) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.cancelAdPlacement(id),
        data: {'reason': reason},
      );
      if (response.data != null && response.data['success'] == true) {
        return AdPlacementModel.fromJson(response.data['payload']);
      }
      throw Exception(response.data?['message'] ?? 'Failed to cancel placement');
    } on DioException catch (e) {
      log('DioException in cancelPlacement: ${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to cancel placement');
    } catch (e) {
      log('Exception in cancelPlacement: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  Future<void> uploadProof(int placementId, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.uploadAdProof,
        data: data,
      );

      if (response.data != null && response.data['success'] == true) {
        return;
      }
      throw Exception(response.data?['message'] ?? 'Failed to upload proof');
    } on DioException catch (e) {
      log('DioException in uploadProof: ${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to upload proof');
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  Future<List<Map<String, dynamic>>> getProofs(int placementId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getAdProofs(placementId),
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'] as List;
        return payload.cast<Map<String, dynamic>>();
      }
      throw Exception(response.data?['message'] ?? 'Failed to get proofs');
    } on DioException catch (e) {
      log('DioException in getProofs: ${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to get proofs');
    } catch (e) {
      log('Exception in getProofs: $e');
      throw Exception('An unexpected error occurred');
    }
  }
}
