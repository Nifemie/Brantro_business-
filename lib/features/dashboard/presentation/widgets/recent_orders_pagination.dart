import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';

class RecentOrdersPagination extends StatelessWidget {
  const RecentOrdersPagination({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 16.h,
        spacing: 16.w,
        children: [
          RichText(
            text: TextSpan(
              style: AppTexts.bodyMedium(color: AppColors.textSecondary),
              children: [
                const TextSpan(text: 'Showing '),
                TextSpan(
                  text: '5',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const TextSpan(text: ' of '),
                TextSpan(
                  text: '90,521',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const TextSpan(text: ' orders'),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPageButton(context, icon: Icons.chevron_left, isActive: false),
              SizedBox(width: 8.w),
              _buildPageButton(context, text: '1', isActive: true),
              SizedBox(width: 8.w),
              _buildPageButton(context, text: '2', isActive: false),
              SizedBox(width: 8.w),
              _buildPageButton(context, text: '3', isActive: false),
              SizedBox(width: 8.w),
              _buildPageButton(context, icon: Icons.chevron_right, isActive: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(
    BuildContext context, {
    String? text,
    IconData? icon,
    required bool isActive,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : theme.cardTheme.color,
        shape: BoxShape.circle,
        border: isActive ? null : Border.all(color: AppColors.borderDefault),
      ),
      alignment: Alignment.center,
      child: text != null
          ? Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            )
          : Icon(icon, size: 18.sp, color: AppColors.textSecondary),
    );
  }
}
