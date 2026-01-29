import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/contact_message_request.dart';
import 'models/contact_message_response.dart';

class ContactRepository {
  final ApiClient apiClient;

  ContactRepository(this.apiClient);

  /// Send contact message
  Future<ContactMessageResponse> sendMessage(ContactMessageRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.sendMessage,
        data: request.toJson(),
      );

      final messageResponse = ContactMessageResponse.fromJson(response.data);
      return messageResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to send message. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
