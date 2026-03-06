import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/service/session_service.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../logic/profile_provider.dart';
import 'widgets/profile_header_widget.dart';
import 'widgets/kyc_verification_banner.dart';
import 'widgets/action_buttons.dart';
import 'widgets/help_support_section.dart';
import 'widgets/account_menu_section.dart';
import 'widgets/social_accounts_section.dart';
import 'widgets/my_settings.dart';

class UserAccount extends ConsumerStatefulWidget {
  const UserAccount({super.key});

  @override
  ConsumerState<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends ConsumerState<UserAccount> {
  @override
  Widget build(BuildContext context) {
    // Force rebuild by invalidating providers when screen is built
    ref.invalidate(profileHeaderProvider);
    
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const SidebarMenu(),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'PROFILE'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    const ProfileHeaderWidget(),
                    SizedBox(height: 16.h),
                    const KycVerificationBanner(),
                    SizedBox(height: 8.h),
                    const ActionButtons(),
                    SizedBox(height: 8.h),
                    const HelpSupportSection(),
                    SizedBox(height: 8.h),
                    const AccountMenuSection(),
                    SizedBox(height: 8.h),
                    const SocialAccountsSection(),
                    SizedBox(height: 8.h),
                    const MySettings(),
                    SizedBox(height: 24.h),
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
