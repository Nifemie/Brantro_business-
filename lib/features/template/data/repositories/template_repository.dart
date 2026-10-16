import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';

class TemplateRepository {
  final ApiClient _apiClient;

  TemplateRepository(this._apiClient);

  Future<Map<String, dynamic>> getTemplates({
    int page = 0,
    int size = 20,
    String? search,
    Map<String, String?>? filters,
  }) async {
    try {
      log('Fetching templates: page=$page, size=$size, search=$search, filters=$filters');
      
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
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
        ApiEndpoints.templateList,
        query: queryParams,
      );

      log('Templates fetched successfully');
      if (response.data['success'] == true) {
        return response.data['payload'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch templates');
    } on DioException catch (e) {
      log('Error fetching templates: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to fetch templates';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error fetching templates: $e');
      throw Exception('Failed to fetch templates: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createTemplate(Map<String, dynamic> data) async {
    try {
      log('Creating template with payload: $data');
      final response = await _apiClient.post(
        ApiEndpoints.createTemplate,
        data: data,
      );

      log('Template created successfully');
      if (response.data['success'] == true) {
        return response.data;
      }
      throw Exception(response.data['message'] ?? 'Failed to create template');
    } on DioException catch (e) {
      log('Error creating template: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to create template';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error creating template: $e');
      throw Exception('Failed to create template: ${e.toString()}');
    }
  }
}
