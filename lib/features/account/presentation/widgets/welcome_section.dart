import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class WelcomeSection extends StatelessWidget {
  final String userName;
  final String userEmail;

  const WelcomeSection({
    super.key,
    this.userName = 'Tosin',
    this.userEmail = 'tosinmoses@gmail.com',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome $userName!',
            style: AppTexts.h3(color: AppColors.textPrimary),
          ),
          SizedBox(height: 4.h),
          Text(
            userEmail,
            style: AppTexts.bodySmall(color: AppColors.secondaryColor),
          ),
        ],
      ),
    );
  }
}
