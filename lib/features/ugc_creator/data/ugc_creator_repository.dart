import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/ugc_creator_response.dart';

class UgcCreatorRepository {
  final ApiClient apiClient;

  UgcCreatorRepository(this.apiClient);

  Future<UgcCreatorResponse> getUgcCreators({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.usersList,
        query: {'page': page, 'limit': limit, 'role': 'UGC_CREATOR'},
      );

      final ugcCreatorResponse = UgcCreatorResponse.fromJson(
        response.data['payload'],
      );
      return ugcCreatorResponse;
    } catch (e) {
      rethrow;
    }
  }
}
