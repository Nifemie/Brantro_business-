import '../../../../core/constants/endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/purchased_service_model.dart';

class PurchasedServicesRepository {
  final ApiClient _apiClient;

  PurchasedServicesRepository(this._apiClient);

  Future<PurchasedServicesResponse> fetchPurchasedServices({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.myServices}?page=$page&size=$size',
      );

      return PurchasedServicesResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateServiceRequirements({
    required int itemId,
    required String description,
    List<String>? links,
    List<Map<String, dynamic>>? files,
  }) async {
    try {
      final requestBody = <String, dynamic>{
        'description': description,
      };
      
      // Only add links if they exist and are not empty
      if (links != null && links.isNotEmpty) {
        requestBody['links'] = links;
      }
      
      // Only add files if they exist and are not empty
      // Note: Files need to be uploaded first to get URLs
      // For now, we're just sending file metadata
      if (files != null && files.isNotEmpty) {
        requestBody['files'] = files.map((file) {
          // If file has a URL, use it; otherwise use the name as placeholder
          return {
            'url': file['url'] ?? file['name'] ?? '',
          };
        }).toList();
      }

      final response = await _apiClient.put(
        ApiEndpoints.updateServiceRequirements(itemId),
        data: requestBody,
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> cancelServiceOrder({
    required int itemId,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.cancelServiceOrder(itemId),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
