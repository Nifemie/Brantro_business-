import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';
import '../models/ad_slot_model.dart';

class AdSlotRepository {
  final ApiClient _apiClient;

  AdSlotRepository(this._apiClient);

  /// Create a new advertisement slot
  Future<AdSlotModel> createAdSlot(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.createAdSlot,
        data: data,
      );

      if (response.data['success'] == true) {
        final payload = response.data['payload'];
        return AdSlotModel.fromJson(payload);
      }

      throw Exception(response.data['message'] ?? 'Failed to create ad slot');
    } on DioException catch (e) {
      print('[AdSlotRepository] createAdSlot ERROR: status=${e.response?.statusCode}, body=${e.response?.data}');
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Failed to create ad slot';
        if (responseData is Map) {
          final msg = responseData['message'];
          if (msg is List) {
            errorMessage = msg.join(', ');
          } else if (msg is String) {
            errorMessage = msg;
          } else {
            errorMessage = responseData['error']?.toString() ?? errorMessage;
          }
        } else if (responseData != null) {
          errorMessage = responseData.toString();
        }
        throw Exception(errorMessage);
      }
      throw Exception('Network error. Please check your connection.');
    } catch (e) {
      throw Exception('Failed to create ad slot: ${e.toString()}');
    }
  }

  /// Fetch a list of advertisement slots
  Future<List<AdSlotModel>> getAdSlots({
    int page = 0,
    int size = 20,
    dynamic createdById,
    String? type,
    String? locationId,
  }) async {
    try {
      String url = '${ApiEndpoints.adSlotsList}?page=$page&size=$size';
      if (createdById != null) {
        url += '&createdById=$createdById';
      }
      if (type != null && type.trim().isNotEmpty) {
        url += '&type=${type.trim().toUpperCase()}';
      }
      if (locationId != null && locationId.trim().isNotEmpty) {
        url += '&locationId=${locationId.trim()}';
      }
      
      final response = await _apiClient.get(url);
 
      if (response.data is Map) {
        if (response.data['success'] == true) {
          final payload = response.data['payload'];
          if (payload == null) {
            return <AdSlotModel>[];
          }
          if (payload is List) {
            return payload.map((item) => AdSlotModel.fromJson(item)).toList();
          }
          final List<dynamic> list = payload['page'] ?? payload['adSlots'] ?? [];
          return list.map((item) => AdSlotModel.fromJson(item)).toList();
        }

        final message = response.data['message']?.toString().toLowerCase() ?? '';
        if (message.contains('no') || message.contains('not found') || message.contains('empty')) {
          return <AdSlotModel>[];
        }
      }
 
      throw Exception(response.data['message'] ?? 'Failed to fetch ad slots');
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final message = e.response!.data['message']?.toString().toLowerCase() ?? '';
        if (message.contains('no') || message.contains('not found') || message.contains('empty')) {
          return <AdSlotModel>[];
        }
        throw Exception(e.response!.data['message'] ?? 'Failed to fetch ad slots');
      }
      throw Exception('Network error. Please check your connection.');
    } catch (e) {
      log('Unexpected error fetching ad slots: $e');
      throw Exception('Failed to fetch ad slots: ${e.toString()}');
    }
  }

  /// Update an existing advertisement slot
  Future<AdSlotModel> updateAdSlot(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.updateAdSlot(id),
        data: data,
      );

      if (response.data['success'] == true) {
        final payload = response.data['payload'];
        return AdSlotModel.fromJson(payload);
      }

      throw Exception(response.data['message'] ?? 'Failed to update ad slot');
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;
        
        String errorMessage = 'Failed to update ad slot';
        if (responseData is Map) {
          final msg = responseData['message'];
          if (msg is List) {
            errorMessage = msg.join(', ');
          } else if (msg is String) {
            errorMessage = msg;
          } else {
            errorMessage = responseData['error'] ?? errorMessage;
          }
        }
        
        if (statusCode == 400) {
          throw Exception(errorMessage);
        } else if (statusCode == 401) {
          throw Exception('Unauthorized. Please login again.');
        } else if (statusCode == 403) {
          throw Exception('Permission denied.');
        } else {
          throw Exception(errorMessage);
        }
      }
      throw Exception('Network error occurred while updating ad slot');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Delete an existing advertisement slot
  Future<void> deleteAdSlot(String id) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.deleteAdSlot(id),
      );

      if (response.data['success'] == true) {
        return;
      }

      throw Exception(response.data['message'] ?? 'Failed to delete ad slot');
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;
        
        String errorMessage = 'Failed to delete ad slot';
        if (responseData is Map) {
          final msg = responseData['message'];
          if (msg is List) {
            errorMessage = msg.join(', ');
          } else if (msg is String) {
            errorMessage = msg;
          } else {
            errorMessage = responseData['error'] ?? errorMessage;
          }
        }
        
        if (statusCode == 400) {
          throw Exception(errorMessage);
        } else if (statusCode == 401) {
          throw Exception('Unauthorized. Please login again.');
        } else if (statusCode == 403) {
          throw Exception('Permission denied.');
        } else {
          throw Exception(errorMessage);
        }
      }
      throw Exception('Network error occurred while deleting ad slot');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
