import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/ad_campaign_model.dart';

final adCampaignRepositoryProvider = Provider<AdCampaignRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AdCampaignRepository(apiClient);
});

class AdCampaignRepository {
  final ApiClient apiClient;

  AdCampaignRepository(this.apiClient);

  Future<List<AdCampaignModel>> fetchAdCampaigns({
    int page = 0,
    int size = 10,
    String? adSlotId,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'size': size,
        if (adSlotId != null) 'adSlotId': adSlotId,
      };

      final response = await apiClient.get(
        ApiEndpoints.adCampaignList,
        query: queryParams,
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload != null && payload['page'] != null) {
          final List<dynamic> data = payload['page'];
          return data.map((json) => AdCampaignModel.fromJson(json)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      log('[AdCampaignRepository] Failed to fetch ad campaigns: ${e.message}');
      throw Exception('Failed to load ad campaigns: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      log('[AdCampaignRepository] Error fetching ad campaigns: $e');
      throw Exception('An unexpected error occurred while loading ad campaigns.');
    }
  }

  Future<AdCampaignModel> cancelCampaign(String campaignId) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.cancelAdCampaign(campaignId),
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        return AdCampaignModel.fromJson(payload);
      }
      throw Exception(response.data?['message'] ?? 'Failed to cancel campaign');
    } on DioException catch (e) {
      log('[AdCampaignRepository] Failed to cancel ad campaign: ${e.message}');
      throw Exception(e.response?.data['message'] ?? 'Failed to cancel campaign');
    } catch (e) {
      log('[AdCampaignRepository] Error canceling ad campaign: $e');
      throw Exception('An unexpected error occurred while canceling the campaign.');
    }
  }
}
