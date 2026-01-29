import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/services_response.dart';
import 'models/service_model.dart';

class ServiceRepository {
  final ApiClient apiClient;

  ServiceRepository(this.apiClient);

  /// Fetch services with pagination
  Future<ServicesResponse> getServices({int page = 0, int size = 10}) async {
    try {
      log('[ServiceRepository] Fetching services: page=$page, size=$size');

      final response = await apiClient.get(
        ApiEndpoints.servicesList,
        query: {
          'page': page,
          'size': size,
        },
      );

      log('[ServiceRepository] Services response received: ${response.statusCode}');
      
      final payload = response.data['payload'];
      if (payload == null) {
        return ServicesResponse.fromJson({});
      }

      final servicesResponse = ServicesResponse.fromJson(payload);
      log('[ServiceRepository] Parsed ${servicesResponse.services.length} services');
      return servicesResponse;
    } on DioException catch (e) {
      log('[ServiceRepository] DioException: ${e.message}');
      log('[ServiceRepository] Status Code: ${e.response?.statusCode}');
      log('[ServiceRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
              ? 'Forbidden: You do not have access to services list'
              : e.response?.data['message'] ??
                  e.response?.data['error'] ??
                  'Failed to fetch services. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[ServiceRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Search services by query
  Future<ServicesResponse> searchServices({
    required String query,
    int page = 0,
    int size = 10,
  }) async {
    try {
      log('[ServiceRepository] Searching services: query=$query, page=$page');

      final response = await apiClient.get(
        ApiEndpoints.searchServices,
        query: {
          'q': query,
          'page': page,
          'size': size,
        },
      );

      log('[ServiceRepository] Search response received: ${response.statusCode}');
      
      final payload = response.data['payload'];
      if (payload == null) {
        return ServicesResponse.fromJson({});
      }

      final searchResponse = ServicesResponse.fromJson(payload);
      log('[ServiceRepository] Parsed ${searchResponse.services.length} services');
      return searchResponse;
    } on DioException catch (e) {
      log('[ServiceRepository] DioException: ${e.message}');
      log('[ServiceRepository] Status Code: ${e.response?.statusCode}');
      log('[ServiceRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
              ? 'Forbidden: You do not have access to search services'
              : e.response?.data['message'] ??
                  e.response?.data['error'] ??
                  'Failed to search services. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[ServiceRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
  /// Get service details by ID
  Future<ServiceModel> getServiceById(String id) async {
    try {
      log('[ServiceRepository] Fetching service details for id=$id');

      final response = await apiClient.get(
        '${ApiEndpoints.serviceDetails}/$id',
      );

      log('[ServiceRepository] Service details response received: ${response.statusCode}');
      
      final payload = response.data['payload'];
      if (payload == null) {
        throw Exception('Service not found');
      }

      return ServiceModel.fromJson(payload);
    } on DioException catch (e) {
      log('[ServiceRepository] DioException: ${e.message}');
      
      final errorMessage = e.response?.statusCode == 404
          ? 'Service not found'
          : e.response?.data['message'] ?? 'Failed to fetch service details';

      throw Exception(errorMessage);
    } catch (e) {
      log('[ServiceRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
