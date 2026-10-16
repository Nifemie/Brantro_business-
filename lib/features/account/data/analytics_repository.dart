import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/endpoints.dart';
import '../../../core/network/api_client.dart';
import 'models/user_analytics_model.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AnalyticsRepository(apiClient);
});

class AnalyticsRepository {
  final ApiClient apiClient;

  AnalyticsRepository(this.apiClient);

  Future<UserAnalyticsModel> fetchUserAnalytics() async {
    try {
      final response = await apiClient.get(ApiEndpoints.userAnalytics);
      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload is Map<String, dynamic>) {
          return UserAnalyticsModel.fromJson(payload);
        }
      }
      return const UserAnalyticsModel();
    } on DioException catch (e) {
      log('[AnalyticsRepository] Failed to fetch analytics: ${e.message}');
      return const UserAnalyticsModel();
    } catch (e) {
      log('[AnalyticsRepository] Error fetching analytics: $e');
      return const UserAnalyticsModel();
    }
  }
}
