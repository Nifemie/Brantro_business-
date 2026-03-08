import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../dashboard/presentation/widgets/sidebar_menu.dart';
import 'widgets/settings_security_section.dart';
import 'widgets/settings_notification_section.dart';
import 'widgets/settings_general_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E2329)
          : AppColors.backgroundSecondary,
      drawer: const SidebarMenu(),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'SETTINGS', showBackButton: true),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Security: password, 2FA, biometric, sessions
                    const SecuritySettingsSection(),
                    SizedBox(height: 20.h),

                    // Notifications: push, orders, campaigns, payments
                    const NotificationSettingsSection(),
                    SizedBox(height: 20.h),

                    // Privacy, Appearance, About & Legal
                    const PrivacyAppearanceAboutSection(),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
