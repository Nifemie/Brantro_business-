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
      
      print('[BillboardRepository] File Upload Response: ${response.data}');
      if (response.data['success'] == true) {
        final payload = response.data['payload'];
        final fileKey = payload['s3Key'] as String? ?? payload['key'] as String? ?? payload['url'] as String;
        return fileKey;
      }

      throw Exception(response.data['message'] ?? 'Failed to upload file');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      
      log('[BillboardRepository] File upload FAILED');
      log('[BillboardRepository] Status Code: $statusCode');
      log('File upload FAILED: ${e.message}');
      print('=== BILLBOARD UPLOAD EXCEPTION DEBUG ===');
      print('Status Code: $statusCode');
      print('Response Data: $responseData');
      print('Exception: $e');
      print('========================================');

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



  /// Delete a location
  Future<bool> deleteLocation(String id) async {
    try {
      print('[BillboardRepository] Deleting location $id...');
      log('[BillboardRepository] Deleting location $id...');

      final response = await apiClient.delete(
        ApiEndpoints.deleteLocation(id),
      );

      print('[BillboardRepository] Delete Response Data: ${response.data}');
      log('[BillboardRepository] Location deleted successfully: ${response.statusCode}');

      if (response.data['success'] == true) {
        return true;
      }

      throw Exception(response.data['message'] ?? 'Failed to delete location');
    } on DioException catch (e) {
      final responseData = e.response?.data;
      String errorMessage = 'Failed to delete location. Please try again.';
      if (responseData is Map) {
        errorMessage = responseData['message'] ?? responseData['error'] ?? errorMessage;
      }
      throw Exception(errorMessage);
    } catch (e) {
      if (e is Exception) rethrow;
      print('[BillboardRepository] Unexpected Error during delete: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Update an existing location (Billboard, Screen, or Wall)
  Future<Map<String, dynamic>> updateLocation(String id, Map<String, dynamic> data) async {
    try {
      print('[BillboardRepository] Updating location $id with payload: $data');
      log('[BillboardRepository] Updating location $id with type: ${data['type']}');

      final response = await apiClient.put(
        ApiEndpoints.updateLocation(id),
        data: data,
      );

      print('[BillboardRepository] Update Response Data: ${response.data}');
      log('[BillboardRepository] Location updated successfully: ${response.statusCode}');

      if (response.data['success'] == true) {
        return response.data['payload'] as Map<String, dynamic>;
      }

      throw Exception(response.data['message'] ?? 'Failed to update location');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      print('[BillboardRepository] Update DioException: $e');
      String errorMessage = 'Failed to update location. Please try again.';
      if (responseData is Map) {
        errorMessage = responseData['message'] ?? responseData['error'] ?? errorMessage;
      }
      throw Exception(errorMessage);
    } catch (e) {
      print('[BillboardRepository] Unexpected Error during update: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Upload/Create a new location (Billboard, Screen, or Wall)
  Future<Map<String, dynamic>> createLocation(Map<String, dynamic> data) async {
    try {
      print('[BillboardRepository] Creating location with payload: $data');
      log('[BillboardRepository] Creating location with type: ${data['type']}');
      log('[BillboardRepository] Posting to ${ApiEndpoints.createLocation}...');

      final response = await apiClient.post(
        ApiEndpoints.createLocation,
        data: data,
      );

      print('[BillboardRepository] Response Data: ${response.data}');
      log('[BillboardRepository] Location created successfully: ${response.statusCode}');
      
      if (response.data['success'] == true) {
        return response.data['payload'] as Map<String, dynamic>;
      }

      throw Exception(response.data['message'] ?? 'Failed to create location');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      
      print('[BillboardRepository] DioException: $e');
      print('[BillboardRepository] DioException Response Data: $responseData');
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
    } catch (e, stackTrace) {
      print('[BillboardRepository] Unexpected Error: $e');
      print('[BillboardRepository] StackTrace: $stackTrace');
      log('[BillboardRepository] Unexpected Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Get list of locations with pagination
  Future<Map<String, dynamic>> getLocations({
    int page = 0,
    int size = 20,
    String? type,
    dynamic createdById,
    String? search,
    Map<String, String?>? filters,
  }) async {
    try {
      log('[BillboardRepository] Fetching locations: page=$page, size=$size, type=$type, createdById=$createdById, search=$search, filters=$filters');

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

      final response = await apiClient.get(
        ApiEndpoints.locationsList,
        query: queryParams,
      );

      log('[BillboardRepository] Locations fetched successfully');
      
      if (response.data['success'] == true) {
        return (response.data['payload'] as Map<String, dynamic>?) ?? {'page': []};
      }

      final msg = response.data['message']?.toString().toLowerCase() ?? '';
      if (msg.contains('no location') || msg.contains('not found') || msg.contains('empty')) {
        return {'page': [], 'totalElements': 0, 'totalPages': 0};
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch locations');
    } on DioException catch (e) {
      log('[BillboardRepository] Fetch locations FAILED: ${e.message}');
      
      final msg = e.response?.data?['message']?.toString().toLowerCase() ?? '';
      if (e.response?.statusCode == 404 || msg.contains('no location') || msg.contains('not found')) {
        return {'page': [], 'totalElements': 0, 'totalPages': 0};
      }

      final errorMessage = e.response?.data?['message'] ?? 
                          e.response?.data?['error'] ?? 
                          'Failed to fetch locations. Please try again.';
      
      throw Exception(errorMessage);
    } catch (e) {
      log('[BillboardRepository] Unexpected Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Block dates on a location (Maintenance / Internal Reservation)
  Future<Map<String, dynamic>> blockLocationDates({
    required dynamic locationId,
    required String startDate,
    required String endDate,
    String? reason,
    String? type,
  }) async {
    try {
      final payload = {
        'startDate': startDate,
        'endDate': endDate,
        if (reason != null && reason.isNotEmpty) 'reason': reason,
        if (type != null && type.isNotEmpty) 'type': type,
      };

      log('[BillboardRepository] Blocking dates for location $locationId: $payload');

      final response = await apiClient.post(
        ApiEndpoints.locationBlockedDates(locationId),
        data: payload,
      );

      if (response.data != null && response.data['success'] == true) {
        log('[BillboardRepository] Successfully blocked dates on location $locationId');
        return response.data['payload'] as Map<String, dynamic>? ?? {};
      }

      throw Exception(response.data?['message'] ?? 'Failed to block dates');
    } on DioException catch (e) {
      log('[BillboardRepository] Block dates FAILED: ${e.message}');
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg);
    } catch (e) {
      log('[BillboardRepository] Unexpected Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Get availability and booked/blocked dates for a location
  Future<Map<String, dynamic>> getLocationAvailability(dynamic locationId) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.locationAvailability(locationId),
      );

      if (response.data != null && response.data['success'] == true) {
        return response.data['payload'] as Map<String, dynamic>? ?? {};
      }

      return {};
    } on DioException catch (e) {
      log('[BillboardRepository] Get availability FAILED: ${e.message}');
      return {};
    } catch (e) {
      log('[BillboardRepository] Unexpected error getting availability: $e');
      return {};
    }
  }
}
