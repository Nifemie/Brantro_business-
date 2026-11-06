import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';

class CreativeRepository {
  final ApiClient _apiClient;

  CreativeRepository(this._apiClient);

  Future<Map<String, dynamic>> getCreatives({
    int page = 0,
    int size = 20,
    String? search,
    Map<String, String?>? filters,
  }) async {
    try {
      log('Fetching creatives: page=$page, size=$size, search=$search, filters=$filters');
      
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
        ApiEndpoints.creativesList,
        query: queryParams,
      );

      log('Creatives fetched successfully');
      if (response.data['success'] == true) {
        return response.data['payload'] as Map<String, dynamic>;
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch creatives');
    } on DioException catch (e) {
      log('Error fetching creatives: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to fetch creatives';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error fetching creatives: $e');
      throw Exception('Failed to fetch creatives: ${e.toString()}');
    }
  }

  Future<bool> createCreative(Map<String, dynamic> data) async {
    try {
      log('Creating creative with data: $data');
      
      final response = await _apiClient.post(
        ApiEndpoints.createCreative,
        data: data,
      );

      if (response.data['success'] == true) {
        log('Creative created successfully');
        return true;
      }
      throw Exception(response.data['message'] ?? 'Failed to create creative');
    } on DioException catch (e) {
      log('Error creating creative: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to create creative';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error creating creative: $e');
      throw Exception('Failed to create creative: ${e.toString()}');
    }
  }

  Future<void> deleteCreative(dynamic id) async {
    try {
      log('Deleting creative: id=$id');
      final response = await _apiClient.delete(
        ApiEndpoints.deleteCreative(id),
      );

      final isSuccess = response.statusCode == 200 ||
          response.statusCode == 204 ||
          (response.data is Map &&
              (response.data['success'] == true ||
                  response.data['status'] == 'success'));

      if (!isSuccess) {
        final msg = response.data is Map
            ? (response.data['message'] ?? 'Failed to delete creative')
            : 'Failed to delete creative';
        throw Exception(msg);
      }
    } on DioException catch (e) {
      log('Error deleting creative: ${e.message}');
      String msg = 'Failed to delete creative';
      if (e.response?.data is Map) {
        msg = e.response?.data['message'] ?? e.response?.data['error'] ?? msg;
      }
      throw Exception(msg);
    } catch (e) {
      log('Unexpected error deleting creative: $e');
      throw Exception('Failed to delete creative: $e');
    }
  }
}
