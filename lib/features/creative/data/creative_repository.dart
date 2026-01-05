import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/creative_response.dart';

class CreativeRepository {
  final ApiClient apiClient;

  CreativeRepository(this.apiClient);

  Future<CreativeResponse> getCreatives({int page = 0, int limit = 10}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.usersList,
        query: {'page': page, 'limit': limit, 'role': 'CREATIVE'},
      );

      final creativeResponse = CreativeResponse.fromJson(
        response.data['payload'],
      );
      return creativeResponse;
    } catch (e) {
      rethrow;
    }
  }
}
