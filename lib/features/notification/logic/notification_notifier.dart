import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/notification_repository.dart';
import '../models/notification_model.dart';
import 'notification_state.dart';

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const NotificationState()) {
    fetchNotifications();
  }

  /// Fetch initial notifications or refresh
  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (state.isLoading && !isRefresh) return;

    state = state.copyWith(
      isLoading: !isRefresh,
      error: null,
      currentPage: 0,
    );

    try {
      final result = await _repository.getNotifications(page: 0, size: 15);
      final items = result['items'] as List<NotificationModel>;
      final currentPage = result['currentPage'] as int? ?? 0;
      final totalPages = result['totalPages'] as int? ?? 1;
      final totalElements = result['totalElements'] as int? ?? items.length;

      state = state.copyWith(
        notifications: items,
        isLoading: false,
        currentPage: currentPage,
        totalPages: totalPages,
        totalElements: totalElements,
        error: null,
      );
    } catch (e) {
      log('[NotificationNotifier] Error fetching notifications: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Load more notifications (infinite scroll pagination)
  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    final nextPage = state.currentPage + 1;
    state = state.copyWith(isLoadingMore: true);

    try {
      final result = await _repository.getNotifications(page: nextPage, size: 15);
      final newItems = result['items'] as List<NotificationModel>;
      final currentPage = result['currentPage'] as int? ?? nextPage;
      final totalPages = result['totalPages'] as int? ?? state.totalPages;
      final totalElements = result['totalElements'] as int? ?? state.totalElements;

      state = state.copyWith(
        notifications: [...state.notifications, ...newItems],
        isLoadingMore: false,
        currentPage: currentPage,
        totalPages: totalPages,
        totalElements: totalElements,
      );
    } catch (e) {
      log('[NotificationNotifier] Error loading more notifications: $e');
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Mark single notification as read (optimistic update + API call)
  Future<void> markAsRead(String id) async {
    final originalList = state.notifications;
    final targetIndex = originalList.indexWhere((n) => n.id == id);
    if (targetIndex == -1) return;

    if (originalList[targetIndex].isRead) return; // already read

    // Optimistic UI update
    final updatedList = List<NotificationModel>.from(originalList);
    updatedList[targetIndex] = updatedList[targetIndex].copyWith(
      isRead: true,
      status: 'SEEN',
    );
    state = state.copyWith(notifications: updatedList);

    try {
      await _repository.markNotificationAsRead(id, status: 'SEEN');
    } catch (e) {
      log('[NotificationNotifier] Failed to sync mark as read: $e');
    }
  }

  /// Mark all notifications as read (optimistic update + API call)
  Future<void> markAllAsRead() async {
    final originalList = state.notifications;
    if (originalList.every((n) => n.isRead)) return; // all already read

    // Optimistic UI update
    final updatedList = originalList.map((n) => n.copyWith(isRead: true, status: 'SEEN')).toList();
    state = state.copyWith(notifications: updatedList);

    try {
      final success = await _repository.markAllAsRead();
      if (!success) {
        log('[NotificationNotifier] Backend mark all as read returned false');
      }
    } catch (e) {
      log('[NotificationNotifier] Failed to mark all as read on backend: $e');
    }
  }

  /// Filter change ('All' or 'Unread')
  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  /// Remove/Delete notification locally
  void removeNotification(String id) {
    final updated = state.notifications.where((n) => n.id != id).toList();
    state = state.copyWith(notifications: updated);
  }
}
