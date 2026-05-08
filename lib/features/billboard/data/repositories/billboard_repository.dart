import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:brantro_business/core/network/api_client.dart';
import 'package:brantro_business/core/constants/endpoints.dart';

class BillboardRepository {
  final ApiClient apiClient;

  BillboardRepository(this.apiClient);

  /// Upload a file and get the URL
  Future<String> uploadFile(String filePath, {String prefix = 'location-thumbnail'}) async {
    try {
      log('[BillboardRepository] Uploading file: $filePath with prefix: $prefix');
      
      final file = File(filePath);
      final fileName = file.path.split('/').last;
      
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
        'prefix': prefix,
      });

      final response = await apiClient.postFormData(
        ApiEndpoints.uploadFile,
        data: formData,
      );

      log('[BillboardRepository] File uploaded successfully');
      
      if (response.data['success'] == true) {
        final fileUrl = response.data['payload']['url'] as String;
        return fileUrl;
      }

      throw Exception(response.data['message'] ?? 'Failed to upload file');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      
      log('[BillboardRepository] File upload FAILED');
      log('[BillboardRepository] Status Code: $statusCode');
      log('[BillboardRepository] Error Data: $responseData');

      String errorMessage = 'Failed to upload file. Please try again.';

      if (statusCode == 400) {
        errorMessage = responseData?['message'] ?? 'Invalid file';
      } else if (statusCode == 413) {
        errorMessage = 'File is too large';
      } else if (responseData is Map) {
        errorMessage = responseData['message'] ?? responseData['error'] ?? errorMessage;
      }

      throw Exception(errorMessage);
    } catch (e) {
      log('[BillboardRepository] Unexpected Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }



  /// Upload/Create a new location (Billboard, Screen, or Wall)
  Future<Map<String, dynamic>> createLocation(Map<String, dynamic> data) async {
    try {
      log('[BillboardRepository] Creating location with type: ${data['type']}');
      log('[BillboardRepository] Posting to ${ApiEndpoints.createLocation}...');

      final response = await apiClient.post(
        ApiEndpoints.createLocation,
        data: data,
      );

      log('[BillboardRepository] Location created successfully: ${response.statusCode}');
      
      if (response.data['success'] == true) {
        return response.data['payload'] as Map<String, dynamic>;
      }

      throw Exception(response.data['message'] ?? 'Failed to create location');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      
      log('[BillboardRepository] Create location FAILED');
      log('[BillboardRepository] Status Code: $statusCode');
      log('[BillboardRepository] Error Data: $responseData');
      log('[BillboardRepository] Message: ${e.message}');

      String errorMessage = 'Failed to create location. Please try again.';

      if (statusCode == 400) {
        errorMessage = responseData?['message'] ?? 'Invalid data provided';
      } else if (statusCode == 401) {
        errorMessage = 'Unauthorized: Please log in again';
      } else if (statusCode == 403) {
        errorMessage = 'Forbidden: You do not have permission';
      } else if (statusCode != null && statusCode >= 500) {
        errorMessage = 'Server error ($statusCode). Please try again later.';
      } else if (responseData is Map) {
        errorMessage = responseData['message'] ?? responseData['error'] ?? errorMessage;
      }

      throw Exception(errorMessage);
    } catch (e) {
      log('[BillboardRepository] Unexpected Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Get list of locations with pagination
  Future<Map<String, dynamic>> getLocations({
    int page = 0,
    int size = 20,
    String? type,
  }) async {
    try {
      log('[BillboardRepository] Fetching locations: page=$page, size=$size, type=$type');

      final queryParams = {
        'page': page,
        'size': size,
        if (type != null) 'type': type,
      };

      final response = await apiClient.get(
        ApiEndpoints.locationsList,
        query: queryParams,
      );

      log('[BillboardRepository] Locations fetched successfully');
      
      if (response.data['success'] == true) {
        return response.data['payload'] as Map<String, dynamic>;
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch locations');
    } on DioException catch (e) {
      log('[BillboardRepository] Fetch locations FAILED: ${e.message}');
      
      final errorMessage = e.response?.data?['message'] ?? 
                          e.response?.data?['error'] ?? 
                          'Failed to fetch locations. Please try again.';
      
      throw Exception(errorMessage);
    } catch (e) {
      log('[BillboardRepository] Unexpected Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
