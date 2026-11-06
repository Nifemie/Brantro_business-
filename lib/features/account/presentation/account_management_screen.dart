import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../core/service/session_service.dart';
import '../logic/profile_provider.dart';
import '../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'widgets/settings_shared_widgets.dart';

class AccountManagementScreen extends ConsumerWidget {
  const AccountManagementScreen({super.key});

  Future<void> _handleDeleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your business account? This action is permanent and cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final repo = ref.read(profileRepositoryProvider);
        await repo.deleteAccount();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your account has been deleted.'),
              backgroundColor: AppColors.primaryColor,
            ),
          );
          await SessionService.performFullLogout(ref, context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete account: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E2329)
          : AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(
              title: 'ACCOUNT MANAGEMENT',
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('IDENTITY'),
                    SettingsCard(
                      children: [
                        _buildStatusTile(
                          icon: Icons.verified_user_outlined,
                          title: 'Account Status',
                          status: 'VERIFIED',
                          statusColor: AppColors.success,
                        ),
                        SettingsDivider(),
                        SettingsNavTile(
                          icon: Icons.business_outlined,
                          title: 'Business Information',
                          subtitle: 'Legal name, RC number, and tax ID',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    _buildSectionHeader('SECURITY & DEVICES'),
                    SettingsCard(
                      children: [
                        SettingsNavTile(
                          icon: Icons.devices_outlined,
                          title: 'Active Sessions',
                          subtitle: 'Manage devices logged into this account',
                          onTap: () {},
                        ),
                        SettingsDivider(),
                        SettingsNavTile(
                          icon: Icons.link_outlined,
                          title: 'Linked Accounts',
                          subtitle: 'Google, Apple, and social connections',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    _buildSectionHeader('DATA & PRIVACY'),
                    SettingsCard(
                      children: [
                        SettingsNavTile(
                          icon: Icons.download_outlined,
                          title: 'Download My Data',
                          subtitle: 'Request a copy of your business data',
                          onTap: () {},
                        ),
                        SettingsDivider(),
                        SettingsNavTile(
                          icon: Icons.archive_outlined,
                          title: 'Archive Account',
                          subtitle:
                              'Temporarily deactivate your business presence',
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Center(
                      child: TextButton(
                        onPressed: () => _handleDeleteAccount(context, ref),
                        child: Text(
                          'DELETE ACCOUNT',
                          style: AppTexts.labelMedium(color: AppColors.error)
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
      child: Text(
        title,
        style: AppTexts.labelMedium(color: AppColors.grey600).copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildStatusTile({
    required IconData icon,
    required String title,
    required String status,
    required Color statusColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 22.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: AppTexts.bodyMedium().copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
