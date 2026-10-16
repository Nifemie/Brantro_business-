import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';

class VehicleRepository {
  final ApiClient _apiClient;

  VehicleRepository(this._apiClient);

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
      
      print('[VehicleRepository] File Upload Response: ${response.data}');
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
      print('=== VEHICLE UPLOAD EXCEPTION DEBUG ===');
      print('Status Code: $statusCode');
      print('Response Data: $responseData');
      print('Exception: $e');
      print('======================================');

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
      print('=== VEHICLE UPLOAD UNEXPECTED ERROR ===');
      print('Error: $e');
      print('=======================================');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<bool> deleteLocation(String id) async {
    try {
      log('Deleting vehicle $id...');

      final response = await _apiClient.delete(
        ApiEndpoints.deleteLocation(id),
      );

      log('Vehicle deleted successfully: ${response.data}');
      if (response.data['success'] == true) {
        return true;
      }
      throw Exception(response.data['message'] ?? 'Failed to delete vehicle');
    } on DioException catch (e) {
      log('Error deleting vehicle: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to delete vehicle';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      if (e is Exception) rethrow;
      log('Unexpected error deleting vehicle: $e');
      throw Exception('Failed to delete vehicle: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateLocation(String id, Map<String, dynamic> data) async {
    try {
      log('Updating vehicle $id with data: $data');

      final response = await _apiClient.put(
        ApiEndpoints.updateLocation(id),
        data: data,
      );

      log('Vehicle updated successfully: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      log('Error updating vehicle: ${e.message}');
      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to update vehicle';
        throw Exception(message);
      }
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error updating vehicle: $e');
      throw Exception('Failed to update vehicle: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createLocation(Map<String, dynamic> data) async {
    try {
      log('Creating vehicle with data: $data');
      
      final response = await _apiClient.post(
        ApiEndpoints.createLocation,
        data: data,
      );

      log('Vehicle created successfully: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      log('Error creating vehicle: ${e.message}');
      
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data['message'] ?? 'Failed to create vehicle';
        
        if (statusCode == 400) {
          throw Exception('Invalid vehicle data: $message');
        } else if (statusCode == 401) {
          throw Exception('Unauthorized. Please login again');
        } else if (statusCode == 403) {
          throw Exception('You do not have permission to create vehicles');
        } else {
          throw Exception(message);
        }
      }
      
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error creating vehicle: $e');
      throw Exception('Failed to create vehicle: ${e.toString()}');
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
      log('Fetching vehicles: page=$page, size=$size, type=$type, createdById=$createdById, search=$search, filters=$filters');
      
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

      log('Vehicles fetched successfully');
      if (response.data['success'] == true) {
        return (response.data['payload'] as Map<String, dynamic>?) ?? {'page': []};
      }

      final msg = response.data['message']?.toString().toLowerCase() ?? '';
      if (msg.contains('no location') || msg.contains('not found') || msg.contains('empty')) {
        return {'page': [], 'totalElements': 0, 'totalPages': 0};
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch vehicles');
    } on DioException catch (e) {
      log('Error fetching vehicles: ${e.message}');
      
      final msg = e.response?.data?['message']?.toString().toLowerCase() ?? '';
      if (e.response?.statusCode == 404 || msg.contains('no location') || msg.contains('not found')) {
        return {'page': [], 'totalElements': 0, 'totalPages': 0};
      }

      if (e.response != null) {
        final message = e.response!.data['message'] ?? 'Failed to fetch vehicles';
        throw Exception(message);
      }
      
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error fetching vehicles: $e');
      throw Exception('Failed to fetch vehicles: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getLocationDetails(String id) async {
    try {
      log('Fetching vehicle details for id: $id');
      
      final response = await _apiClient.get(
        '${ApiEndpoints.locationDetails}/$id',
      );

      log('Vehicle details fetched successfully');
      return response.data;
    } on DioException catch (e) {
      log('Error fetching vehicle details: ${e.message}');
      
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data['message'] ?? 'Failed to fetch vehicle details';
        
        if (statusCode == 404) {
          throw Exception('Vehicle not found');
        } else {
          throw Exception(message);
        }
      }
      
      throw Exception('Network error. Please check your connection');
    } catch (e) {
      log('Unexpected error fetching vehicle details: $e');
      throw Exception('Failed to fetch vehicle details: ${e.toString()}');
    }
  }
}
