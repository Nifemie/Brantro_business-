import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';

class ProfileRepository {
  final ApiClient apiClient;

  ProfileRepository(this.apiClient);

  /// Fetch user profile details by ID
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      final response = await apiClient.get(ApiEndpoints.userDetails(userId));
      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload is Map<String, dynamic>) {
          return payload;
        }
      }
      throw Exception('Failed to parse user details response');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to fetch user details. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Update user profile details by ID
  Future<Map<String, dynamic>> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.updateUser(userId),
        data: data,
      );
      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload is Map<String, dynamic>) {
          return payload;
        }
        return response.data;
      }
      throw Exception(response.data?['message'] ?? 'Failed to update user profile');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to update user profile. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
