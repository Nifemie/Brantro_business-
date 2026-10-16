import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/service/session_service.dart';
import '../../../dashboard/logic/dashboard_navigation_provider.dart';

class MySettings extends ConsumerWidget {
  const MySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return FutureBuilder<bool>(
      future: SessionService.isLoggedIn(),
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.data ?? false;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'My Settings',
                  style: AppTexts.labelMedium(color: AppColors.grey600),
                ),
              ),
              _buildSettingItem(
                title: 'Settings',
                onTap: () {
                  context.push('/settings');
                },
              ),
              _buildDivider(),
              _buildAuthButton(context, ref, isLoggedIn),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuthButton(BuildContext context, WidgetRef ref, bool isLoggedIn) {
    return InkWell(
      onTap: () async {
        if (isLoggedIn) {
          // Show confirmation dialog before logout
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                'Logout',
                style: AppTexts.h3(color: AppColors.textPrimary),
              ),
              content: Text(
                'Are you sure you want to logout?',
                style: AppTexts.bodyMedium(color: AppColors.grey700),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(
                    'Cancel',
                    style: AppTexts.labelMedium(color: AppColors.grey600),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(
                    'Logout',
                    style: AppTexts.labelMedium(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );

          if (shouldLogout == true && context.mounted) {
            await SessionService.performFullLogout(ref, context);

            // Show success message after navigation
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'You have been logged out successfully',
                    ),
                    backgroundColor: AppColors.success,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            });
          }
        } else {
          // Navigate to login screen
          context.go('/signin');
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              isLoggedIn ? Icons.logout : Icons.login,
              color: isLoggedIn ? AppColors.error : AppColors.primaryColor,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              isLoggedIn ? 'Logout' : 'Login',
              style: AppTexts.bodyMedium(
                color: isLoggedIn ? AppColors.error : AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTexts.bodyMedium(
                    color: isDark ? Colors.white : AppColors.grey700,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.white38 : AppColors.grey400,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(height: 1, thickness: 1, color: AppColors.grey200),
    );
  }
}
