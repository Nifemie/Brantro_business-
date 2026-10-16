import '../models/notification_model.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final bool isLoadingMore;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final String? error;
  final String selectedFilter; // 'All', 'Unread'

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalElements = 0,
    this.error,
    this.selectedFilter = 'All',
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get filteredNotifications {
    if (selectedFilter == 'Unread') {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications;
  }

  bool get hasMore => currentPage + 1 < totalPages;

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    bool? isLoadingMore,
    int? currentPage,
    int? totalPages,
    int? totalElements,
    String? error,
    String? selectedFilter,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      error: error,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
