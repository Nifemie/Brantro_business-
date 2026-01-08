import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/producers_list_response.dart';

class ProducerRepository {
  final ApiClient apiClient;

  ProducerRepository(this.apiClient);

  /// Get list of producers with pagination
  Future<ProducersListResponse> getProducers({int page = 1, int limit = 10}) async {
    try {
      log('[ProducerRepository] Fetching producers: page=$page, limit=$limit');

      final response = await apiClient.get(
        ApiEndpoints.usersList,
        query: {
          'page': page - 1, // Backend expects 0-indexed pages
          'role': 'producer',
        },
      );

      log(
        '[ProducerRepository] Producers response received: ${response.statusCode}',
      );
      final producersResponse = ProducersListResponse.fromJson(response.data);
      log(
        '[ProducerRepository] Parsed ${producersResponse.payload.producers.length} producers',
      );
      return producersResponse;
    } on DioException catch (e) {
      log('[ProducerRepository] DioException: ${e.message}');
      log('[ProducerRepository] Status Code: ${e.response?.statusCode}');
      log('[ProducerRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
          ? 'Forbidden: You do not have access to producers list'
          : e.response?.data['message'] ??
                e.response?.data['error'] ??
                'Failed to fetch producers. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[ProducerRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
