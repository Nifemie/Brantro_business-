import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/contact_message_request.dart';
import 'models/contact_message_response.dart';

class ContactRepository {
  final ApiClient apiClient;

  ContactRepository(this.apiClient);

  /// Send contact message to backend: POST /api/v1/message
  Future<ContactMessageResponse> sendMessage(ContactMessageRequest request) async {
    try {
      log('[ContactRepository] POST ${ApiEndpoints.sendMessage} Payload: ${request.toJson()}');

      final response = await apiClient.post(
        ApiEndpoints.sendMessage,
        data: request.toJson(),
      );

      log('[ContactRepository] Response: status=${response.statusCode}, data=${response.data}');

      if (response.data is Map<String, dynamic>) {
        return ContactMessageResponse.fromJson(response.data);
      } else {
        return ContactMessageResponse(
          success: true,
          message: 'Your message has been sent successfully.',
        );
      }
    } on DioException catch (e) {
      log('[ContactRepository] sendMessage ERROR: status=${e.response?.statusCode}, body=${e.response?.data}');
      if (e.response != null) {
        final responseData = e.response!.data;
        String errorMessage = 'Failed to send message. Please try again.';
        if (responseData is Map) {
          final msg = responseData['message'];
          if (msg is List) {
            errorMessage = msg.join(', ');
          } else if (msg is String) {
            errorMessage = msg;
          } else {
            errorMessage = responseData['error']?.toString() ?? errorMessage;
          }
        } else if (responseData != null) {
          errorMessage = responseData.toString();
        }
        throw Exception(errorMessage);
      }
      throw Exception('Network error. Please check your connection.');
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }
}
