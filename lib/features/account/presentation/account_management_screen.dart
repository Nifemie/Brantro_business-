import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'widgets/settings_shared_widgets.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        onPressed: () {},
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
