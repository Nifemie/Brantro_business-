import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';
import '../models/faq_model.dart';

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

  Future<FaqModel> createFaq({
    required String title,
    required String answer,
    String category = 'GENERAL',
  }) async {
    try {
      log('Creating FAQ: title=$title, category=$category');
      final response = await _apiClient.post(
        ApiEndpoints.faq,
        data: {
          'title': title,
          'description': answer,
          'category': category,
        },
      );

      final isSuccess = response.data != null &&
          ((response.data is Map && response.data['success'] == true) ||
              response.statusCode == 200 ||
              response.statusCode == 201);

      if (isSuccess && response.data is Map) {
        final payload = response.data['payload'] ?? response.data['data'];
        if (payload != null && payload is Map<String, dynamic>) {
          return FaqModel.fromJson(payload);
        }
      }

      if (response.data is Map<String, dynamic>) {
        return FaqModel.fromJson(response.data);
      }

      return FaqModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        answer: answer,
        createdAt: DateTime.now(),
      );
    } on DioException catch (e) {
      log('Error creating FAQ: ${e.message}');
      String msg = 'Failed to create FAQ';
      if (e.response?.data is Map) {
        msg = e.response?.data['message'] ?? e.response?.data['error'] ?? msg;
      }
      throw Exception(msg);
    } catch (e) {
      log('Unexpected error creating FAQ: $e');
      throw Exception('Failed to create FAQ: $e');
    }
  }

  Future<void> deleteFaq(dynamic id) async {
    try {
      log('Deleting FAQ: id=$id');
      final response = await _apiClient.delete(
        ApiEndpoints.deleteFaq(id),
      );

      final isSuccess = response.statusCode == 200 ||
          response.statusCode == 204 ||
          (response.data is Map &&
              (response.data['success'] == true ||
                  response.data['status'] == 'success'));

      if (!isSuccess) {
        final msg = response.data is Map
            ? (response.data['message'] ?? 'Failed to delete FAQ')
            : 'Failed to delete FAQ';
        throw Exception(msg);
      }
    } on DioException catch (e) {
      log('Error deleting FAQ: ${e.message}');
      String msg = 'Failed to delete FAQ';
      if (e.response?.data is Map) {
        msg = e.response?.data['message'] ?? e.response?.data['error'] ?? msg;
      }
      throw Exception(msg);
    } catch (e) {
      log('Unexpected error deleting FAQ: $e');
      throw Exception('Failed to delete FAQ: $e');
    }
  }
}
