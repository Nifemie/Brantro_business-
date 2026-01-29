import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import '../data/models/ad_slot_model.dart';
import '../data/models/ad_slots_response.dart';
import '../data/models/create_ad_slot_request.dart';

class AdSlotService {
  final ApiClient apiClient;

  AdSlotService(this.apiClient);

  /// Fetch ad slots with pagination
  Future<AdSlotsResponse> fetchAdSlots({int page = 0, int size = 20}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.adSlotsList,
        query: {'page': page, 'size': size},
      );

      final payload = response.data['payload'];
      if (payload == null) {
        // Return empty response if payload is missing (e.g. "No Ads slot available")
        return AdSlotsResponse.fromJson({});
      }

      return AdSlotsResponse.fromJson(payload);
    } catch (e) {
      rethrow;
    }
  }

  /// Search ad slots by query
  Future<AdSlotsResponse> searchAdSlots({
    required String query,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.searchAdSlots,
        query: {'q': query, 'page': page, 'size': size},
      );

      final payload = response.data['payload'];
      if (payload == null) {
        return AdSlotsResponse.fromJson({});
      }

      return AdSlotsResponse.fromJson(payload);
    } catch (e) {
      rethrow;
    }
  }

  /// Create a new ad slot
  Future<AdSlot> createAdSlot(CreateAdSlotRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.createAdSlot,
        data: request.toJson(),
      );

      // Assuming API returns the created ad slot in payload
      return AdSlot.fromJson(response.data['payload'] ?? response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get ad slot details by ID
  Future<AdSlot> getAdSlotById(String id) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.adSlotsDetails}/$id',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['payload'] != null) {
          return AdSlot.fromJson(data['payload']);
        } else {
          throw Exception(data['message'] ?? 'Ad slot not found');
        }
      } else {
        throw Exception('Failed to load ad slot: ${response.statusCode}');
      }
    } catch (e) {
      // Improve error message if possible
      throw Exception('Error fetching ad slot details: $e');
    }
  }
}
