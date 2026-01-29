import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/artists_list_response.dart';

class ArtistRepository {
  final ApiClient apiClient;

  ArtistRepository(this.apiClient);

  /// Get list of artists with pagination and filtering
  Future<ArtistsListResponse> getArtists({int page = 1, int limit = 10}) async {
    try {
      log('[ArtistRepository] Fetching artists: page=$page, limit=$limit');

      final response = await apiClient.get(
        ApiEndpoints.usersList,
        query: {
          'page': page - 1, // Backend expects 0-indexed pages
          'limit': limit,
          'filter[userType]': 'ARTIST',
        },
      );

      log(
        '[ArtistRepository] Artists response received: ${response.statusCode}',
      );
      final artistsResponse = ArtistsListResponse.fromJson(response.data);
      log(
        '[ArtistRepository] Parsed ${artistsResponse.payload.artists.length} artists',
      );
      return artistsResponse;
    } on DioException catch (e) {
      log('[ArtistRepository] DioException: ${e.message}');
      log('[ArtistRepository] Status Code: ${e.response?.statusCode}');
      log('[ArtistRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
          ? 'Forbidden: You do not have access to artists list'
          : e.response?.data['message'] ??
                e.response?.data['error'] ??
                'Failed to fetch artists. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[ArtistRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Search users by query with optional role filter
  Future<ArtistsListResponse> searchUsers({
    required String query,
    int page = 0,
    String? role,
  }) async {
    try {
      log('[ArtistRepository] Searching users: query=$query, page=$page, role=$role');

      final queryParams = {
        'q': query,
        'page': page,
      };

      // Add role filter if provided
      if (role != null && role.isNotEmpty) {
        queryParams['role'] = role;
      }

      final response = await apiClient.get(
        ApiEndpoints.searchUsers,
        query: queryParams,
      );

      log(
        '[ArtistRepository] Search response received: ${response.statusCode}',
      );
      final searchResponse = ArtistsListResponse.fromJson(response.data);
      log(
        '[ArtistRepository] Parsed ${searchResponse.payload.artists.length} users',
      );
      return searchResponse;
    } on DioException catch (e) {
      log('[ArtistRepository] DioException: ${e.message}');
      log('[ArtistRepository] Status Code: ${e.response?.statusCode}');
      log('[ArtistRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
          ? 'Forbidden: You do not have access to search users'
          : e.response?.data['message'] ??
                e.response?.data['error'] ??
                'Failed to search users. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[ArtistRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
