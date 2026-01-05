import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/media_house_response.dart';

class MediaHouseRepository {
  final ApiClient apiClient;

  MediaHouseRepository(this.apiClient);

  Future<MediaHouseResponse> getMediaHouses({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.usersList,
        query: {'page': page, 'role': 'MEDIA_HOUSE'},
      );

      final mediaHouseResponse = MediaHouseResponse.fromJson(
        response.data['payload'],
      );
      return mediaHouseResponse;
    } catch (e) {
      rethrow;
    }
  }
}
