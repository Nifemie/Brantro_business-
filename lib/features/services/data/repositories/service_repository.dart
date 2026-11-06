import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';

class ServiceRepository {
  final ApiClient _apiClient;

  ServiceRepository(this._apiClient);

  Future<Map<String, dynamic>> getServices({
    int page = 0,
    int size = 20,
    dynamic createdById,
    String? search,
    Map<String, String?>? filters,
  }) async {
    try {
      log('Fetching services: page=$page, size=$size, createdById=$createdById, search=$search, filters=$filters');
      
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
        if (createdById != null) 'createdById': createdById,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      if (filters != null) {
        filters.forEach((key, value) {
          if (value != null && value.isNotEmpty && value != 'All') {
            final paramKey = key.toLowerCase().replaceAll(' ', '_');
            queryParams[paramKey] = value;
          }
        });
      }

      final response = await _apiClient.get(
        ApiEndpoints.servicesList,
        query: queryParams,
      );

      log('Services fetched successfully');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['success'] == true && data['payload'] != null) {
          final payload = data['payload'];
          if (payload is Map<String, dynamic>) {
            return payload;
          } else if (payload is List) {
            return {'page': payload, 'totalPages': 1, 'totalItems': payload.length};
          }
        }

        // Gracefully return empty state when no services are found
        final message = data['message']?.toString().toLowerCase() ?? '';
        if (message.contains('no creative services') || message.contains('not found') || message.contains('empty')) {
          return {'page': [], 'totalPages': 0, 'totalItems': 0};
        }
      }

      throw Exception(data?['message'] ?? 'Failed to fetch services');
    } on DioException catch (e) {
      log('Error fetching services: ${e.message}');
      if (e.response != null && e.response?.data is Map) {
        final message = e.response!.data['message']?.toString().toLowerCase() ?? '';
        if (message.contains('no creative services') || message.contains('not found')) {
          return {'page': [], 'totalPages': 0, 'totalItems': 0};
        }
        final msg = e.response!.data['message'] ?? 'Failed to fetch services';
        throw Exception(msg);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error fetching services: $e');
      throw Exception('Failed to fetch services: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createService(Map<String, dynamic> data) async {
    try {
      log('Creating service: ${data['title']}');
      final response = await _apiClient.post(
        ApiEndpoints.createService,
        data: data,
      );

      if (response.data['success'] == true) {
        return response.data['payload'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Failed to create service');
    } on DioException catch (e) {
      log('Error creating service: ${e.message}');
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Failed to create service');
      }
      throw Exception('Network error. Please check your connection');
    }
  }

  Future<void> deleteService(dynamic id) async {
    try {
      log('Deleting service: id=$id');
      final response = await _apiClient.delete(
        ApiEndpoints.deleteService(id),
      );

      final isSuccess = response.statusCode == 200 ||
          response.statusCode == 204 ||
          (response.data is Map &&
              (response.data['success'] == true ||
                  response.data['status'] == 'success'));

      if (!isSuccess) {
        final msg = response.data is Map
            ? (response.data['message'] ?? 'Failed to delete service')
            : 'Failed to delete service';
        throw Exception(msg);
      }
    } on DioException catch (e) {
      log('Error deleting service: ${e.message}');
      String msg = 'Failed to delete service';
      if (e.response?.data is Map) {
        msg = e.response?.data['message'] ?? e.response?.data['error'] ?? msg;
      }
      throw Exception(msg);
    } catch (e) {
      log('Unexpected error deleting service: $e');
      throw Exception('Failed to delete service: $e');
    }
  }
}
