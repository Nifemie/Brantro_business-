import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/radio_station_response.dart';

class RadioStationRepository {
  final ApiClient apiClient;

  RadioStationRepository(this.apiClient);

  Future<RadioStationResponse> getRadioStations({
    int page = 0,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.usersList,
        query: {'page': page, 'role': 'RADIO_STATION'},
      );

      final radioStationResponse = RadioStationResponse.fromJson(
        response.data['payload'],
      );
      return radioStationResponse;
    } catch (e) {
      rethrow;
    }
  }
}
