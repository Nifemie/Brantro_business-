import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';

class RecentOrdersHeader extends StatelessWidget {
  const RecentOrdersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 16.h,
        spacing: 24.w,
        children: [
          Text(
            'Recent Orders',
            style: AppTexts.displaySmall(
              color: AppColors.primaryColor,
            ).copyWith(fontSize: 16.sp),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: AppColors.secondaryColor, size: 14.sp),
                SizedBox(width: 6.w),
                Text(
                  'Create Order',
                  style: AppTexts.labelMedium(
                    color: AppColors.secondaryColor,
                  ).copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
