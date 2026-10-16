import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../../logic/notification_provider.dart';
import '../../models/notification_model.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationProvider.notifier).loadMore();
    }
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Mark as read
    ref.read(notificationProvider.notifier).markAsRead(notification.id);

    // Deep link or navigate based on actionUrl or type
    if (notification.actionUrl != null && notification.actionUrl!.isNotEmpty) {
      final url = notification.actionUrl!;
      if (url.startsWith('/')) {
        context.push(url);
      }
    } else {
      switch (notification.type) {
        case NotificationType.order:
        case NotificationType.revision:
          final orderId = notification.metadata?['orderId']?.toString();
          if (orderId != null) {
            context.push('/orders/details/$orderId');
          } else {
            context.push('/orders');
          }
          break;
        case NotificationType.payment:
          context.push('/wallet');
          break;
        case NotificationType.message:
          context.push('/chat');
          break;
        case NotificationType.system:
          break;
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (mounted) {
      context.go('/dashboard');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final notifState = ref.watch(notificationProvider);
    final notifNotifier = ref.read(notificationProvider.notifier);

    final filteredList = notifState.filteredNotifications;
    final unreadCount = notifState.unreadCount;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        drawer: const SidebarMenu(),
        body: SafeArea(
          child: Column(
            children: [
              const DashboardAppBar(title: 'NOTIFICATIONS'),

              // Filter Tabs & Mark All Read Row
              _buildFilterAndActionRow(isDark, notifState.selectedFilter, unreadCount),

              // Notifications List
              Expanded(
                child: notifState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : notifState.error != null && notifState.notifications.isEmpty
                        ? _buildErrorState(isDark, notifState.error!)
                        : filteredList.isEmpty
                            ? _buildEmptyState(isDark)
                            : RefreshIndicator(
                                onRefresh: () => notifNotifier.fetchNotifications(isRefresh: true),
                                color: AppColors.primaryColor,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                  itemCount: filteredList.length + (notifState.isLoadingMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == filteredList.length) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 16.h),
                                        child: const Center(
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      );
                                    }

                                    final notification = filteredList[index];
                                    return NotificationCard(
                                      notification: notification,
                                      onTap: () => _handleNotificationTap(notification),
                                      onDelete: () => notifNotifier.removeNotification(notification.id),
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterAndActionRow(bool isDark, String selectedFilter, int unreadCount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          // Filter Tabs (All / Unread)
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  _buildFilterTab('All', isDark, selectedFilter == 'All'),
                  _buildFilterTab(
                    'Unread',
                    isDark,
                    selectedFilter == 'Unread',
                    badge: unreadCount > 0 ? unreadCount : null,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 10.w),

          // "Mark all as read" button
          if (unreadCount > 0)
            InkWell(
              onTap: () => ref.read(notificationProvider.notifier).markAllAsRead(),
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.done_all_rounded, color: AppColors.primaryColor, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Read all',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, bool isDark, bool isSelected, {int? badge}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(notificationProvider.notifier).setFilter(label),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? Colors.grey[800] : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? Colors.white : AppColors.textPrimary)
                      : (isDark ? Colors.white60 : AppColors.grey600),
                ),
              ),
              if (badge != null) ...[
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    badge.toString(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80.sp,
            color: isDark ? Colors.white24 : AppColors.grey300,
          ),
          SizedBox(height: 16.h),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.white38 : AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isDark, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 60.sp, color: Colors.red[300]),
            SizedBox(height: 16.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white70 : Colors.black87),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => ref.read(notificationProvider.notifier).fetchNotifications(isRefresh: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
