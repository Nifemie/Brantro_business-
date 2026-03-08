import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';

class ContactHeader extends StatelessWidget {
  const ContactHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.primaryColor, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Fill out the form below and we\'ll get back to you as soon as possible.',
              style: AppTexts.bodySmall(color: AppColors.grey700),
            ),
          ),
        ],
      ),
    );
  }
}
