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
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          color: Colors.white,
          child: Column(
            children: [
              // Only show balance button for guest users
              if (!isLoggedIn) ...[
                _buildBalanceButton(context),
                SizedBox(height: 12.h),
              ],
              _buildLiveChatButton(),
              SizedBox(height: 16.h),
            ],
          ),
        );
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

  Widget _buildLiveChatButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20.sp),
          SizedBox(width: 12.w),
          Text(
            'Live Chat',
            style: AppTexts.bodyMedium(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
