import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';

class WallRepository {
  final ApiClient _apiClient;

  WallRepository(this._apiClient);

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
      
      print('[WallRepository] File Upload Response: ${response.data}');
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
      print('=== WALL UPLOAD EXCEPTION DEBUG ===');
      print('Status Code: $statusCode');
      print('Response Data: $responseData');
      print('Exception: $e');
      print('===================================');

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
      print('=== WALL UPLOAD UNEXPECTED ERROR ===');
      print('Error: $e');
      print('====================================');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<bool> deleteLocation(String id) async {
    try {
      log('Deleting wall $id...');

      final response = await _apiClient.delete(
        ApiEndpoints.deleteLocation(id),
      );

      log('Wall deleted successfully: ${response.data}');
      if (response.data['success'] == true) {
        return true;
      }
      throw Exception(response.data['message'] ?? 'Failed to delete wall');
    } on DioException catch (e) {
      log('Error deleting wall: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to delete wall';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      if (e is Exception) rethrow;
      log('Unexpected error deleting wall: $e');
      throw Exception('Failed to delete wall: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateLocation(String id, Map<String, dynamic> data) async {
    try {
      log('Updating wall $id with data: $data');

      final response = await _apiClient.put(
        ApiEndpoints.updateLocation(id),
        data: data,
      );

      log('Wall updated successfully: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      log('Error updating wall: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to update wall';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error updating wall: $e');
      throw Exception('Failed to update wall: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createLocation(Map<String, dynamic> data) async {
    try {
      log('Creating wall with data: $data');
      
      final response = await _apiClient.post(
        ApiEndpoints.createLocation,
        data: data,
      );

      log('Wall created successfully: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      log('Error creating wall: ${e.message}');
      
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data['message'] ?? 'Failed to create wall';
        
        if (statusCode == 400) {
          throw Exception('Invalid wall data: $message');
        } else if (statusCode == 401) {
          throw Exception('Unauthorized. Please login again');
        } else if (statusCode == 403) {
          throw Exception('You do not have permission to create walls');
        } else {
          throw Exception(message);
        }
      }
      
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error creating wall: $e');
      throw Exception('Failed to create wall: ${e.toString()}');
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
      log('Fetching walls: page=$page, size=$size, type=$type, createdById=$createdById, search=$search, filters=$filters');
      
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

      log('Walls fetched successfully');
      if (response.data['success'] == true) {
        return (response.data['payload'] as Map<String, dynamic>?) ?? {'page': []};
      }

      final msg = response.data['message']?.toString().toLowerCase() ?? '';
      if (msg.contains('no location') || msg.contains('not found') || msg.contains('empty')) {
        return {'page': [], 'totalElements': 0, 'totalPages': 0};
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch walls');
    } on DioException catch (e) {
      log('Error fetching walls: ${e.message}');
      
      final msg = e.response?.data?['message']?.toString().toLowerCase() ?? '';
      if (e.response?.statusCode == 404 || msg.contains('no location') || msg.contains('not found')) {
        return {'page': [], 'totalElements': 0, 'totalPages': 0};
      }

      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to fetch walls';
        throw Exception(message);
      }
      
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error fetching walls: $e');
      throw Exception('Failed to fetch walls: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getLocationDetails(String id) async {
    try {
      log('Fetching wall details for id: $id');
      
      final response = await _apiClient.get(
        '${ApiEndpoints.locationDetails}/$id',
      );

      log('Wall details fetched successfully');
      return response.data;
    } on DioException catch (e) {
      log('Error fetching wall details: ${e.message}');
      
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data['message'] ?? 'Failed to fetch wall details';
        
        if (statusCode == 404) {
          throw Exception('Wall not found');
        } else {
          throw Exception(message);
        }
      }
      
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error fetching wall details: $e');
      throw Exception('Failed to fetch wall details: ${e.toString()}');
    }
  }
}
