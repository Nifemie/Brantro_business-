import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/service/session_service.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SessionService.isLoggedIn(),
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.data ?? false;
        
        // Only show balance button for guest users
        if (!isLoggedIn) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            color: Colors.transparent,
            child: Column(
              children: [
                _buildBalanceButton(context),
                SizedBox(height: 12.h),
              ],
            ),
          );
        }
        
        // Return empty widget for logged in users
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBalanceButton(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to login screen
        context.push('/signin');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.white, size: 20.sp),
            SizedBox(width: 12.w),
            Text(
              'Login to see your balance',
              style: AppTexts.bodyMedium(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
