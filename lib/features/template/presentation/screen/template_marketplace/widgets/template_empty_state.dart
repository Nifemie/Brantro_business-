import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';

class TemplateEmptyState extends StatelessWidget {
  const TemplateEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Warning Icon
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              size: 40.sp,
              color: AppColors.secondaryColor,
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Title
          Text(
            'Templates',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Message
          Text(
            'No template found',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.white70 : AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}
