import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/template_order_request.dart';
import 'models/template_order_response.dart';
import 'models/creative_order_request.dart';
import 'models/creative_order_response.dart';
import 'models/service_order_request.dart';
import 'models/service_order_response.dart';

class CheckoutRepository {
  final ApiClient apiClient;

  CheckoutRepository(this.apiClient);

  /// Submit template order
  Future<TemplateOrderResponse> submitTemplateOrder(TemplateOrderRequest request) async {
    try {
      log('[CheckoutRepository] Submitting template order: ${request.toJson()}');

      final response = await apiClient.post(
        ApiEndpoints.templateOrder,
        data: request.toJson(),
      );

      log('[CheckoutRepository] Order response received: ${response.statusCode}');
      log('[CheckoutRepository] Response data: ${response.data}');

      final orderResponse = TemplateOrderResponse.fromJson(response.data);
      log('[CheckoutRepository] Order submitted successfully: ${orderResponse.message}');
      
      return orderResponse;
    } on DioException catch (e) {
      log('[CheckoutRepository] DioException: ${e.message}');
      log('[CheckoutRepository] Status Code: ${e.response?.statusCode}');
      log('[CheckoutRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
              ? 'Forbidden: You do not have permission to place orders'
              : e.response?.statusCode == 400
                  ? e.response?.data['message'] ?? 'Invalid order data'
                  : e.response?.data['message'] ??
                      e.response?.data['error'] ??
                      'Failed to submit order. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[CheckoutRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Submit creative order
  Future<CreativeOrderResponse> submitCreativeOrder(CreativeOrderRequest request) async {
    try {
      log('[CheckoutRepository] Submitting creative order: ${request.toJson()}');

      final response = await apiClient.post(
        ApiEndpoints.creativeOrder,
        data: request.toJson(),
      );

      log('[CheckoutRepository] Order response received: ${response.statusCode}');
      log('[CheckoutRepository] Response data: ${response.data}');

      final orderResponse = CreativeOrderResponse.fromJson(response.data);
      log('[CheckoutRepository] Order submitted successfully: ${orderResponse.message}');
      
      return orderResponse;
    } on DioException catch (e) {
      log('[CheckoutRepository] DioException: ${e.message}');
      log('[CheckoutRepository] Status Code: ${e.response?.statusCode}');
      log('[CheckoutRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
              ? 'Forbidden: You do not have permission to place orders'
              : e.response?.statusCode == 400
                  ? e.response?.data['message'] ?? 'Invalid order data'
                  : e.response?.data['message'] ??
                      e.response?.data['error'] ??
                      'Failed to submit creative order. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[CheckoutRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Submit service order
  Future<ServiceOrderResponse> submitServiceOrder(ServiceOrderRequest request) async {
    try {
      log('[CheckoutRepository] Submitting service order: ${request.toJson()}');

      final response = await apiClient.post(
        ApiEndpoints.serviceOrder,
        data: request.toJson(),
      );

      log('[CheckoutRepository] Service order response received: ${response.statusCode}');
      log('[CheckoutRepository] Response data: ${response.data}');

      final orderResponse = ServiceOrderResponse.fromJson(response.data);
      log('[CheckoutRepository] Service order submitted successfully: ${orderResponse.message}');
      
      return orderResponse;
    } on DioException catch (e) {
      log('[CheckoutRepository] DioException: ${e.message}');
      log('[CheckoutRepository] Status Code: ${e.response?.statusCode}');
      log('[CheckoutRepository] Error Response: ${e.response?.data}');

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
              ? 'Forbidden: You do not have permission to place orders'
              : e.response?.statusCode == 400
                  ? e.response?.data['message'] ?? 'Invalid order data'
                  : e.response?.data['message'] ??
                      e.response?.data['error'] ??
                      'Failed to submit service order. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      log('[CheckoutRepository] Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
