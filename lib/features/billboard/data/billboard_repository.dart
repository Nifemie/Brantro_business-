import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/billboards_list_response.dart';

class BillboardRepository {
  final ApiClient apiClient;

  BillboardRepository(this.apiClient);

  /// Get list of billboards with pagination
  Future<BillboardsListResponse> getBillboards({int page = 0, int size = 15}) async {
    try {
      log('[BillboardRepository] Fetching billboards: page=$page, size=$size');

      final response = await apiClient.get(
        ApiEndpoints.locationsList,
        query: {
          'page': page,
          'type': 'BILLBOARD',
        },
      );

      log(
        '[BillboardRepository] Billboards response received: ${response.statusCode}',
      );
      final billboardsResponse = BillboardsListResponse.fromJson(response.data);
      log(
        '[BillboardRepository] Parsed ${billboardsResponse.payload.billboards.length} billboards',
      );
      return billboardsResponse;
    } on DioException catch (e) {
      log('[BillboardRepository] DioException: ${e.message}');
      log('[BillboardRepository] Status Code: ${e.response?.statusCode}');
      log('[BillboardRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
          ? 'Forbidden: You do not have access to billboards list'
          : e.response?.data['message'] ??
                e.response?.data['error'] ??
                'Failed to fetch billboards. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[BillboardRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
