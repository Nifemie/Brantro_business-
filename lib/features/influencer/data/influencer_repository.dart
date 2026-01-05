import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/influencer_response.dart';

class InfluencerRepository {
  final ApiClient apiClient;

  InfluencerRepository(this.apiClient);

  Future<InfluencerResponse> getInfluencers({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.usersList,
        query: {'page': page, 'role': 'Influencer'},
      );

      final influencerResponse = InfluencerResponse.fromJson(
        response.data['payload'],
      );
      return influencerResponse;
    } catch (e) {
      rethrow;
    }
  }
}
