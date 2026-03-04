import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_provider.dart';
import 'app_popup_menu.dart';

class DashboardAppBar extends ConsumerWidget {
  final String title;

  const DashboardAppBar({super.key, this.title = 'WELCOME!'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 14.w,
                  height: 2.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white70 : Colors.grey[700],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 22.w,
                  height: 2.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white70 : Colors.grey[700],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14.w,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white70 : Colors.grey[700],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Container(
                      width: 4.w,
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white70 : Colors.grey[700],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 40.w),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey[900],
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.wb_sunny_outlined
                  : Icons.dark_mode_outlined,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              size: 24.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 40.w),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  context.push('/notifications');
                },
                icon: Icon(
                  Icons.notifications,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                  size: 26.sp,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 40.w),
              ),
              Positioned(
                right: 4,
                top: 2,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF05252), // Lighter red from screenshot
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.h),
                  child: Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const AppPopupMenu(),
        ],
      ),
    );
  }
}
