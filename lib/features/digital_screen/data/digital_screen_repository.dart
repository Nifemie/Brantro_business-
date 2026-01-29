import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/digital_screens_list_response.dart';

class DigitalScreenRepository {
  final ApiClient apiClient;

  DigitalScreenRepository(this.apiClient);

  /// Get list of digital screens with pagination
  Future<DigitalScreensListResponse> getDigitalScreens({int page = 0, int size = 15}) async {
    try {
      log('[DigitalScreenRepository] Fetching digital screens: page=$page, size=$size');

      final response = await apiClient.get(
        ApiEndpoints.locationsList,
        query: {
          'page': page,
          'type': 'SCREEN',
        },
      );

      log(
        '[DigitalScreenRepository] Digital screens response received: ${response.statusCode}',
      );
      final screensResponse = DigitalScreensListResponse.fromJson(response.data);
      log(
        '[DigitalScreenRepository] Parsed ${screensResponse.payload.screens.length} digital screens',
      );
      return screensResponse;
    } on DioException catch (e) {
      log('[DigitalScreenRepository] DioException: ${e.message}');
      log('[DigitalScreenRepository] Status Code: ${e.response?.statusCode}');
      log('[DigitalScreenRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
          ? 'Forbidden: You do not have access to digital screens list'
          : e.response?.data['message'] ??
                e.response?.data['error'] ??
                'Failed to fetch digital screens. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[DigitalScreenRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
