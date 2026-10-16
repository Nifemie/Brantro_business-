import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';

class ScreenRepository {
  final ApiClient _apiClient;

  ScreenRepository(this._apiClient);

  /// Upload a file and get the URL
  Future<String> uploadFile(String filePath, {String prefix = 'location-thumbnail'}) async {
    try {
      log('Uploading file: $filePath with prefix: $prefix');
      
      final file = File(filePath);
      final fileName = file.path.split('/').last;
      
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
        'prefix': prefix,
      });

      final response = await _apiClient.postFormData(
        ApiEndpoints.uploadFile,
        data: formData,
      );

      log('File uploaded successfully');
      
      print('[ScreenRepository] File Upload Response: ${response.data}');
      if (response.data['success'] == true) {
        final payload = response.data['payload'];
        final fileKey = payload['s3Key'] as String? ?? payload['key'] as String? ?? payload['url'] as String;
        return fileKey;
      }

      throw Exception(response.data['message'] ?? 'Failed to upload file');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      
      log('File upload FAILED: ${e.message}');
      print('=== SCREEN UPLOAD EXCEPTION DEBUG ===');
      print('Status Code: $statusCode');
      print('Response Data: $responseData');
      print('Exception: $e');
      print('=====================================');

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
      log('Unexpected error uploading file: $e');
      print('=== SCREEN UPLOAD UNEXPECTED ERROR ===');
      print('Error: $e');
      print('======================================');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<bool> deleteLocation(String id) async {
    try {
      log('Deleting screen $id...');

      final response = await _apiClient.delete(
        ApiEndpoints.deleteLocation(id),
      );

      log('Screen deleted successfully: ${response.data}');
      if (response.data['success'] == true) {
        return true;
      }
      throw Exception(response.data['message'] ?? 'Failed to delete screen');
    } on DioException catch (e) {
      log('Error deleting screen: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to delete screen';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      if (e is Exception) rethrow;
      log('Unexpected error deleting screen: $e');
      throw Exception('Failed to delete screen: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateLocation(String id, Map<String, dynamic> data) async {
    try {
      log('Updating screen $id with data: $data');

      final response = await _apiClient.put(
        ApiEndpoints.updateLocation(id),
        data: data,
      );

      log('Screen updated successfully: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      log('Error updating screen: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to update screen';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error updating screen: $e');
      throw Exception('Failed to update screen: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createLocation(Map<String, dynamic> data) async {
    try {
      log('Creating screen with data: $data');
      
      final response = await _apiClient.post(
        ApiEndpoints.createLocation,
        data: data,
      );

      log('Screen created successfully: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      log('Error creating screen: ${e.message}');
      
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data['message'] ?? 'Failed to create screen';
        
        if (statusCode == 400) {
          throw Exception('Invalid screen data: $message');
        } else if (statusCode == 401) {
          throw Exception('Unauthorized. Please login again');
        } else if (statusCode == 403) {
          throw Exception('You do not have permission to create screens');
        } else {
          throw Exception(message);
        }
      }
      
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error creating screen: $e');
      throw Exception('Failed to create screen: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getLocations({
    int page = 0,
    int size = 20,
    String? type,
    dynamic createdById,
    String? search,
    Map<String, String?>? filters,
  }) async {
    try {
      log('Fetching screens: page=$page, size=$size, type=$type, createdById=$createdById, search=$search, filters=$filters');
      
      final queryParams = <String, dynamic>{
        'page': page,
        'size': size,
        if (type != null) 'type': type,
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
        ApiEndpoints.locationsList,
        query: queryParams,
      );

      log('Screens fetched successfully');
      if (response.data['success'] == true) {
        return (response.data['payload'] as Map<String, dynamic>?) ?? {'page': []};
      }

      final msg = response.data['message']?.toString().toLowerCase() ?? '';
      if (msg.contains('no location') || msg.contains('not found') || msg.contains('empty')) {
        return {'page': [], 'totalElements': 0, 'totalPages': 0};
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch screens');
    } on DioException catch (e) {
      log('Error fetching screens: ${e.message}');
      
      final msg = e.response?.data?['message']?.toString().toLowerCase() ?? '';
      if (e.response?.statusCode == 404 || msg.contains('no location') || msg.contains('not found')) {
        return {'page': [], 'totalElements': 0, 'totalPages': 0};
      }

      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to fetch screens';
        throw Exception(message);
      }
      
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error fetching screens: $e');
      throw Exception('Failed to fetch screens: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getLocationDetails(String id) async {
    try {
      log('Fetching screen details for id: $id');
      
      final response = await _apiClient.get(
        '${ApiEndpoints.locationDetails}/$id',
      );

      log('Screen details fetched successfully');
      return response.data;
    } on DioException catch (e) {
      log('Error fetching screen details: ${e.message}');
      
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data['message'] ?? 'Failed to fetch screen details';
        
        if (statusCode == 404) {
          throw Exception('Screen not found');
        } else {
          throw Exception(message);
        }
      }
      
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error fetching screen details: $e');
      throw Exception('Failed to fetch screen details: ${e.toString()}');
    }
  }
}
