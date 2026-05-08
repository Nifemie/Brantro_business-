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
      
      if (response.data['success'] == true) {
        final fileUrl = response.data['payload']['url'] as String;
        return fileUrl;
      }

      throw Exception(response.data['message'] ?? 'Failed to upload file');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      
      log('File upload FAILED: ${e.message}');

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
      throw Exception('An unexpected error occurred: $e');
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
  }) async {
    try {
      log('Fetching screens: page=$page, size=$size');
      
      final response = await _apiClient.get(
        '${ApiEndpoints.locationsList}?page=$page&size=$size',
      );

      log('Screens fetched successfully');
      return response.data;
    } on DioException catch (e) {
      log('Error fetching screens: ${e.message}');
      
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
