import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class ProfileUserInfo extends StatelessWidget {
  final Color textColor;
  final Color subtextColor;

  const ProfileUserInfo({
    super.key,
    required this.textColor,
    required this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48.r,
          backgroundColor: AppColors.grey300,
          backgroundImage: const AssetImage(
            'assets/icons/avatars/avatars/avatar-3.jpg',
          ),
        ),
        SizedBox(height: 12.h),

        Text(
          'Anna M. Hines',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        SizedBox(height: 14.h),

        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.email_outlined, size: 18.sp),
          label: Text(
            'Send Email',
            style: TextStyle(fontSize: 13.sp),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            elevation: 0,
          ),
        ),
        SizedBox(height: 12.h),

        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13.sp,
              color: subtextColor,
            ),
            children: const [
              TextSpan(text: 'Last Interacted: '),
              TextSpan(
                text: 'online',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
