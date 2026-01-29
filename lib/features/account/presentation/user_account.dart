import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/service/session_service.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import 'widgets/account_header.dart';
import 'widgets/profile_header_widget.dart';
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
  bool _isLoading = true;
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await SessionService.isLoggedIn();
    if (mounted) {
      setState(() {
        _isGuest = !isLoggedIn;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    if (_isGuest) {
      return Scaffold(
        backgroundColor: AppColors.backgroundSecondary,
        body: SafeArea(
          child: _buildGuestView(),
        ),
      );
    }

    // Force rebuild by invalidating providers when screen is built
    ref.invalidate(profileHeaderProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          const AccountHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  const ProfileHeaderWidget(),
                  SizedBox(height: 16.h),
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
    );
  }

  Widget _buildGuestView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 80.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 24.h),
            Text(
              'Sign in to access your account',
              style: AppTexts.h3(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Create an account or sign in to manage your profile, settings, and more.',
              style: AppTexts.bodyMedium(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            
            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/signin');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Sign In',
                  style: AppTexts.buttonMedium(),
                ),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.go('/signup');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Create Account',
                  style: AppTexts.buttonMedium(color: AppColors.primaryColor),
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Browse as guest
            TextButton(
              onPressed: () {
                context.go('/home');
              },
              child: Text(
                'Continue browsing as guest',
                style: AppTexts.bodySmall(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
