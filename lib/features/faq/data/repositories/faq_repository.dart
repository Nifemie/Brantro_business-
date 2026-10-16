import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';

class FaqRepository {
  final ApiClient _apiClient;

  FaqRepository(this._apiClient);

  Future<Map<String, dynamic>> getFaqs({
    int page = 0,
    int size = 20,
  }) async {
    try {
      log('Fetching FAQs: page=$page, size=$size');
      
      final queryParams = {
        'page': page,
        'size': size,
      };

      final response = await _apiClient.get(
        ApiEndpoints.faqList,
        query: queryParams,
      );

      log('FAQs fetched successfully');
      if (response.data['success'] == true) {
        return response.data['payload'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch FAQs');
    } on DioException catch (e) {
      log('Error fetching FAQs: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to fetch FAQs';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error fetching FAQs: $e');
      throw Exception('Failed to fetch FAQs: ${e.toString()}');
    }
  }
}
