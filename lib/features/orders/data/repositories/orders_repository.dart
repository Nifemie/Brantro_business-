import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/order_model.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return OrdersRepository(apiClient);
});

class OrdersRepository {
  final ApiClient apiClient;

  OrdersRepository(this.apiClient);

  Future<List<OrderModel>> fetchCreativeOrders({int page = 0, int size = 10, String? creativeId}) async {
    try {
      final queryParams = {
        'page': page,
        'size': size,
        if (creativeId != null) 'creativeId': creativeId,
      };

      final response = await apiClient.get(
        ApiEndpoints.creativeOrdersList,
        query: queryParams,
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload != null && payload['page'] != null) {
          final List<dynamic> data = payload['page'];
          return data.map((json) => OrderModel.fromCreativeOrderJson(json)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      log('[OrdersRepository] Failed to fetch creative orders: ${e.message}');
      throw Exception('Failed to load creative orders: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      log('[OrdersRepository] Error fetching creative orders: $e');
      throw Exception('An unexpected error occurred while loading orders.');
    }
  }

  Future<List<OrderModel>> fetchTemplateOrders({int page = 0, int size = 10, String? templateId}) async {
    try {
      final queryParams = {
        'page': page,
        'size': size,
        if (templateId != null) 'templateId': templateId,
      };

      final response = await apiClient.get(
        ApiEndpoints.templateOrdersList,
        query: queryParams,
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload != null && payload['page'] != null) {
          final List<dynamic> data = payload['page'];
          return data.map((json) => OrderModel.fromTemplateOrderJson(json)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      log('[OrdersRepository] Failed to fetch template orders: ${e.message}');
      throw Exception('Failed to load template orders: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      log('[OrdersRepository] Error fetching template orders: $e');
      throw Exception('An unexpected error occurred while loading orders.');
    }
  }

  Future<List<OrderModel>> fetchServiceOrders({int page = 0, int size = 10, String? serviceId}) async {
    try {
      final queryParams = {
        'page': page,
        'size': size,
        if (serviceId != null) 'serviceId': serviceId,
      };

      final response = await apiClient.get(
        ApiEndpoints.serviceOrdersList,
        query: queryParams,
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload != null && payload['page'] != null) {
          final List<dynamic> data = payload['page'];
          return data.map((json) => OrderModel.fromServiceOrderJson(json)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      log('[OrdersRepository] Failed to fetch service orders: ${e.message}');
      throw Exception('Failed to load service orders: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      log('[OrdersRepository] Error fetching service orders: $e');
      throw Exception('An unexpected error occurred while loading orders.');
    }
  }

  Future<OrderModel> fetchServiceOrderDetails(dynamic id) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.serviceOrderDetails(id),
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload != null) {
          return OrderModel.fromServiceOrderJson(payload);
        }
      }
      throw Exception('Failed to load order details.');
    } on DioException catch (e) {
      log('[OrdersRepository] Failed to fetch service order details: ${e.message}');
      throw Exception('Failed to load order details: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      log('[OrdersRepository] Error fetching service order details: $e');
      throw Exception('An unexpected error occurred while loading order details.');
    }
  }

  Future<OrderModel> fetchOrderDetails(dynamic id, String serviceType) async {
    try {
      String endpoint;
      if (serviceType == 'creative') {
        endpoint = ApiEndpoints.creativeOrderDetails(id);
      } else if (serviceType == 'template') {
        endpoint = ApiEndpoints.templateOrderDetails(id);
      } else {
        endpoint = ApiEndpoints.serviceOrderDetails(id);
      }

      final response = await apiClient.get(endpoint);

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload != null) {
          if (serviceType == 'creative') {
            return OrderModel.fromCreativeOrderJson(payload);
          } else if (serviceType == 'template') {
            return OrderModel.fromTemplateOrderJson(payload);
          } else {
            return OrderModel.fromServiceOrderJson(payload);
          }
        }
      }
      throw Exception('Failed to load order details.');
    } on DioException catch (e) {
      log('[OrdersRepository] Failed to fetch order details: ${e.message}');
      throw Exception('Failed to load order details: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      log('[OrdersRepository] Error fetching order details: $e');
      throw Exception('An unexpected error occurred while loading order details.');
    }
  }

  Future<void> makeItemDecision({
    required dynamic itemId,
    required String decision,
    String? startDate,
    String? endDate,
    String? remark,
  }) async {
    try {
      final payload = {
        'status': decision, // 'ACCEPTED' or 'REJECTED'
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (remark != null) 'remark': remark,
      };

      final response = await apiClient.put(
        ApiEndpoints.serviceOrderItemDecision(itemId),
        data: payload,
      );

      if (response.data != null && response.data['success'] == true) {
        log('[OrdersRepository] Successfully made decision $decision for item $itemId');
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to make decision');
      }
    } on DioException catch (e) {
      log('[OrdersRepository] Failed to make decision: ${e.message}');
      throw Exception('Failed to process request: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      log('[OrdersRepository] Error making decision: $e');
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> updateItemProgress({
    required dynamic itemId,
    required String remark,
    required int percent,
  }) async {
    try {
      final payload = {
        'remark': remark,
        'percent': percent,
      };

      final response = await apiClient.put(
        ApiEndpoints.serviceOrderItemProgress(itemId),
        data: payload,
      );

      if (response.data != null && response.data['success'] == true) {
        log('[OrdersRepository] Successfully updated progress to $percent% for item $itemId');
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to update progress');
      }
    } on DioException catch (e) {
      log('[OrdersRepository] Failed to update progress: ${e.message}');
      throw Exception('Failed to process request: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      log('[OrdersRepository] Error updating progress: $e');
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> deliverItemWork({
    required dynamic itemId,
    required String feedback,
    String? attachmentUrl,
  }) async {
    try {
      final payload = {
        'feedback': feedback,
        if (attachmentUrl != null && attachmentUrl.isNotEmpty)
          'attachments': [
            {'url': attachmentUrl}
          ],
      };

      final response = await apiClient.put(
        ApiEndpoints.serviceOrderItemDelivery(itemId),
        data: payload,
      );

      if (response.data != null && response.data['success'] == true) {
        log('[OrdersRepository] Successfully delivered work for item $itemId');
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to deliver work');
      }
    } on DioException catch (e) {
      log('[OrdersRepository] Failed to deliver work: ${e.message}');
      throw Exception('Failed to process request: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      log('[OrdersRepository] Error delivering work: $e');
      throw Exception('An unexpected error occurred.');
    }
  }

  Future<void> requestItemRevision({
    required dynamic itemId,
    required String reason,
  }) async {
    try {
      final payload = {
        'reason': reason,
      };

      final response = await apiClient.put(
        ApiEndpoints.serviceOrderItemRevision(itemId),
        data: payload,
      );

      if (response.data != null && response.data['success'] == true) {
        log('[OrdersRepository] Successfully requested revision for item $itemId');
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to request revision');
      }
    } on DioException catch (e) {
      log('[OrdersRepository] Failed to request revision: ${e.message}');
      throw Exception('Failed to process request: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      log('[OrdersRepository] Error requesting revision: $e');
      throw Exception('An unexpected error occurred.');
    }
  }
}
