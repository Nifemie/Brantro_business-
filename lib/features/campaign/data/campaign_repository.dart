import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/campaigns_response.dart';
import 'models/campaign_model.dart';

class CampaignRepository {
  final ApiClient apiClient;

  CampaignRepository(this.apiClient);

  Future<CampaignsResponse> getMyCampaigns({
    int page = 0,
    int size = 10,
    String? status,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
      };
      
      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status.toUpperCase();
      }

      final response = await apiClient.get(
        ApiEndpoints.myCampaigns,
        query: queryParams,
      );
      
      final campaignsResponse = CampaignsResponse.fromJson(response.data);
      
      // Handle "No record found" as empty result, not an error
      if (!campaignsResponse.success && campaignsResponse.message.toLowerCase().contains('no record')) {
        return CampaignsResponse(
          success: true,
          message: 'No campaigns found',
          payload: CampaignsPayload(
            page: [],
            size: '10',
            currentPage: 0,
            totalPages: 0,
          ),
        );
      }
      
      if (!campaignsResponse.success) {
        throw Exception(campaignsResponse.message);
      }
      
      return campaignsResponse;
    } on DioException catch (e) {
      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.data['message'] ??
              e.response?.data['error'] ??
              'Failed to fetch campaigns';

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<CampaignModel> getCampaignDetails(int campaignId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.campaignDetails}/$campaignId');
      
      if (response.data['success'] == true && response.data['payload'] != null) {
        return CampaignModel.fromJson(response.data['payload']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch campaign details');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.data['message'] ?? 'Failed to fetch campaign details';

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Map<String, dynamic>> cancelCampaign(int campaignId) async {
    try {
      final response = await apiClient.put(ApiEndpoints.cancelCampaign(campaignId));
      
      if (response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Campaign cancelled successfully',
        };
      } else {
        throw Exception(response.data['message'] ?? 'Failed to cancel campaign');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.data['message'] ?? 'Failed to cancel campaign';

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
