import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/endpoints.dart';
import '../models/social_account_model.dart';

class SocialAccountRepository {
  final ApiClient apiClient;

  SocialAccountRepository(this.apiClient);

  /// Fetch user social accounts
  Future<List<SocialAccountModel>> fetchSocialAccounts() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.mySocialAccounts,
        query: {
          'page': 0,
          'size': 100,
        },
      );
      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload is List) {
          return payload.map((item) => SocialAccountModel.fromJson(item)).toList();
        } else if (payload is Map<String, dynamic> && payload['page'] is List) {
          // If response uses standard paginated list
          return (payload['page'] as List)
              .map((item) => SocialAccountModel.fromJson(item))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to fetch social accounts. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Create/Add a social media account
  Future<SocialAccountModel> createSocialAccount({
    required String platform,
    required String handle,
    required String profileUrl,
    required int followers,
    required bool isPrimary,
    required bool isActive,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.socialAccount,
        data: {
          'platform': platform,
          'handle': handle,
          'profileUrl': profileUrl,
          'followers': followers,
          'isPrimary': isPrimary,
          'isActive': isActive,
        },
      );
      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload is Map<String, dynamic>) {
          return SocialAccountModel.fromJson(payload);
        }
      }
      throw Exception('Failed to parse social account response');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to add social account. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Delete a social media account by ID
  Future<void> deleteSocialAccount(int accountId) async {
    try {
      final response = await apiClient.delete('${ApiEndpoints.socialAccount}/$accountId');
      if (response.data != null && response.data['success'] == true) {
        return;
      }
      throw Exception('Failed to delete social account');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to delete social account. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
