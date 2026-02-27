import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/service/session_service.dart';

class MySettings extends StatelessWidget {
  const MySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SessionService.isLoggedIn(),
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.data ?? false;
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
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
              _buildSettingItem(
                title: 'Payment Settings',
                onTap: () {
                  // TODO: Navigate to Payment Settings
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                title: 'Address Book',
                onTap: () {
                  // TODO: Navigate to Address Book
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                title: 'Account Management',
                onTap: () {
                  // TODO: Navigate to Account Management
                },
              ),
              _buildDivider(),
              _buildSettingItem(
                title: 'Close Account',
                onTap: () {
                  // TODO: Navigate to Close Account
                },
              ),
              _buildDivider(),
              _buildAuthButton(context, isLoggedIn),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuthButton(BuildContext context, bool isLoggedIn) {
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
            // Clear session data
            final prefs = await SharedPreferences.getInstance();
            await prefs.clear(); // Clear all data
            
            // Navigate to signin
            context.pushReplacement('/signin');
            
            // Show success message after navigation
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('You have been logged out successfully'),
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
          context.push('/signin');
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTexts.bodyMedium(color: AppColors.grey700),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.grey400,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.grey200,
      ),
    );
  }
}
