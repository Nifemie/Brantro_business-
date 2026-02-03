import '../../../core/constants/endpoints.dart';
import '../../../core/network/api_client.dart';
import 'models/purchased_creative_model.dart';

class PurchasedCreativesRepository {
  final ApiClient _apiClient;

  PurchasedCreativesRepository(this._apiClient);

  Future<PurchasedCreativesResponse> fetchPurchasedCreatives({
    int page = 0,
    int size = 10,
    String status = 'COMPLETED',
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.myCreatives}?page=$page&size=$size&status=$status',
      );

      return PurchasedCreativesResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
