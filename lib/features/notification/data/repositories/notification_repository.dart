import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../models/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return NotificationRepository(apiClient);
});

class NotificationRepository {
  final ApiClient apiClient;

  NotificationRepository(this.apiClient);

  /// Fetch paginated notifications list
  Future<Map<String, dynamic>> getNotifications({
    int page = 0,
    int size = 15,
  }) async {
    try {
      log('[NotificationRepository] Fetching notifications: page=$page, size=$size');

      final response = await apiClient.get(
        '${ApiEndpoints.notificationList}?page=$page&size=$size',
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        if (payload is Map<String, dynamic>) {
          final rawList = payload['page'] as List<dynamic>? ?? [];
          final items = rawList
              .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
              .toList();

          return {
            'items': items,
            'currentPage': payload['currentPage'] ?? page,
            'totalPages': payload['totalPages'] ?? 1,
            'totalElements': payload['totalElements'] ?? items.length,
            'size': payload['size'] ?? size,
          };
        } else if (payload is List) {
          final items = payload
              .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
              .toList();
          return {
            'items': items,
            'currentPage': page,
            'totalPages': 1,
            'totalElements': items.length,
            'size': size,
          };
        }
      }

      return {
        'items': <NotificationModel>[],
        'currentPage': page,
        'totalPages': 1,
        'totalElements': 0,
        'size': size,
      };
    } on DioException catch (e) {
      log('[NotificationRepository] Fetch notifications FAILED: ${e.message}');
      final msg = e.response?.data?['message'] ?? e.message;
      throw Exception(msg ?? 'Failed to fetch notifications');
    } catch (e) {
      log('[NotificationRepository] Unexpected error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Mark single notification as read/seen
  Future<bool> markNotificationAsRead(
    dynamic id, {
    String status = 'SEEN',
  }) async {
    try {
      log('[NotificationRepository] Marking notification $id as $status');

      final response = await apiClient.put(
        ApiEndpoints.markNotificationStatus(id, status: status),
      );

      if (response.data != null && response.data['success'] == true) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      log('[NotificationRepository] Mark as read FAILED: ${e.message}');
      return false;
    } catch (e) {
      log('[NotificationRepository] Unexpected error marking as read: $e');
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      log('[NotificationRepository] Marking all notifications as read');

      final response = await apiClient.put(
        ApiEndpoints.notificationReadAll,
      );

      if (response.data != null && response.data['success'] == true) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      log('[NotificationRepository] Mark all as read FAILED: ${e.message}');
      return false;
    } catch (e) {
      log('[NotificationRepository] Unexpected error marking all as read: $e');
      return false;
    }
  }
}
