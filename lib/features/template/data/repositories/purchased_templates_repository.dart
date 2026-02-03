import '../../../../core/constants/endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/purchased_template_model.dart';

class PurchasedTemplatesRepository {
  final ApiClient _apiClient;

  PurchasedTemplatesRepository(this._apiClient);

  Future<PurchasedTemplatesResponse> fetchPurchasedTemplates({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.myTemplates}?page=$page&size=$size',
      );

      return PurchasedTemplatesResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
