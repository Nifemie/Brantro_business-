import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/tv_station_response.dart';

class TvStationRepository {
  final ApiClient apiClient;

  TvStationRepository(this.apiClient);

  Future<TvStationResponse> getTvStations({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.usersList,
        query: {'page': page, 'role': 'TV_STATION'},
      );

      final tvStationResponse = TvStationResponse.fromJson(
        response.data['payload'],
      );
      return tvStationResponse;
    } catch (e) {
      rethrow;
    }
  }
}
