import 'models/vetting_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';

class VettingRepository {
  final ApiClient _apiClient;

  VettingRepository(this._apiClient);

  /// Fetch all vetting options
  Future<List<VettingOptionModel>> fetchVettingOptions({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.vettingList,
        query: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['payload'] != null) {
          final List<dynamic> vettingList = data['payload']['page'] ?? [];
          return vettingList
              .map((json) => VettingOptionModel.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load vetting options');
        }
      } else {
        throw Exception('Failed to load vetting options: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching vetting options: $e');
    }
  }

  /// Get vetting details by ID
  Future<VettingOptionModel> getVettingById(String id) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.vettingDetails}/$id',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['payload'] != null) {
          return VettingOptionModel.fromJson(data['payload']);
        } else {
          throw Exception(data['message'] ?? 'Vetting option not found');
        }
      } else {
        throw Exception('Failed to load vetting option: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching vetting details: $e');
    }
  }
}
