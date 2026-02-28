import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/re_useable/app_color.dart';
import '../../controllers/re_useable/app_texts.dart';

enum NotificationType {
  success,
  error,
  info,
  warning,
}

class NotificationService {
  static OverlayEntry? _currentOverlay;

  /// Show a notification toast
  static void show(
    BuildContext context, {
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    // Remove any existing notification
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _NotificationToast(
        message: message,
        type: type,
        actionLabel: actionLabel,
        onActionTap: onActionTap,
        onDismiss: () {
          overlayEntry.remove();
          _currentOverlay = null;
        },
      ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);

    // Auto dismiss after duration
    Future.delayed(duration, () {
      if (_currentOverlay == overlayEntry) {
        overlayEntry.remove();
        _currentOverlay = null;
      }
    });
  }

  /// Show success notification
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    show(
      context,
      message: message,
      type: NotificationType.success,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show error notification
  static void showError(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    show(
      context,
      message: message,
      type: NotificationType.error,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show info notification
  static void showInfo(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    show(
      context,
      message: message,
      type: NotificationType.info,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }

  /// Show cart notification (specialized for cart actions)
  static void showCartNotification(
    BuildContext context, {
    required String itemName,
    required String itemType,
    VoidCallback? onViewCart,
  }) {
    show(
      context,
      message: '$itemName added to cart',
      type: NotificationType.success,
      actionLabel: 'View Cart',
      onActionTap: onViewCart,
      duration: const Duration(seconds: 4),
    );
  }
}

class _NotificationToast extends StatefulWidget {
  final String message;
  final NotificationType type;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final VoidCallback onDismiss;

  const _NotificationToast({
    required this.message,
    required this.type,
    this.actionLabel,
    this.onActionTap,
    required this.onDismiss,
  });

  @override
  State<_NotificationToast> createState() => _NotificationToastState();
}

class _NotificationToastState extends State<_NotificationToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.info:
        return AppColors.primaryColor;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Icon(
                        _getIcon(),
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),

                      // Message
                      Expanded(
                        child: Text(
                          widget.message,
                          style: AppTexts.bodyMedium(color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Action button
                      if (widget.actionLabel != null &&
                          widget.onActionTap != null) ...[
                        SizedBox(width: 12.w),
                        TextButton(
                          onPressed: () {
                            widget.onActionTap?.call();
                            widget.onDismiss();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            widget.actionLabel!,
                            style: AppTexts.labelSmall(color: Colors.white)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],

                      // Close button
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: widget.onDismiss,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
