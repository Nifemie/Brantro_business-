import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/creatives_response.dart';
import 'models/creative_model.dart';

class CreativeRepository {
  final ApiClient apiClient;

  CreativeRepository(this.apiClient);

  Future<CreativesResponse> getCreatives({int page = 0, int size = 10}) async {
    try {
      log('[CreativeRepository] Fetching creatives: page=$page, size=$size');

      final response = await apiClient.get(
        ApiEndpoints.creativesList,
        query: {
          'page': page,
          'size': size,
        },
      );

      log('[CreativeRepository] Creatives response received: ${response.statusCode}');
      final creativesResponse = CreativesResponse.fromJson(response.data);
      log('[CreativeRepository] Parsed ${creativesResponse.payload.creatives.length} creatives');
      
      return creativesResponse;
    } on DioException catch (e) {
      log('[CreativeRepository] DioException: ${e.message}');
      log('[CreativeRepository] Status Code: ${e.response?.statusCode}');
      log('[CreativeRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
              ? 'Forbidden: You do not have access to creatives'
              : e.response?.data['message'] ??
                  e.response?.data['error'] ??
                  'Failed to fetch creatives. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[CreativeRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<CreativeModel> getCreativeById(int id) async {
    try {
      log('[CreativeRepository] Fetching creative by ID: $id');

      final response = await apiClient.get('${ApiEndpoints.creativeDetails}/$id');

      log('[CreativeRepository] Creative detail response received: ${response.statusCode}');
      
      // The API returns: {"success": true, "message": "...", "payload": {...creative data...}}
      final creativeData = response.data['payload'];
      final creative = CreativeModel.fromJson(creativeData);
      
      log('[CreativeRepository] Parsed creative: ${creative.title}');
      
      return creative;
    } on DioException catch (e) {
      log('[CreativeRepository] DioException: ${e.message}');
      log('[CreativeRepository] Status Code: ${e.response?.statusCode}');
      log('[CreativeRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 404
          ? 'Creative not found'
          : e.response?.statusCode == 401
              ? 'Unauthorized: Please log in again'
              : e.response?.data['message'] ??
                  e.response?.data['error'] ??
                  'Failed to fetch creative details. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[CreativeRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
