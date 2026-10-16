import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/color_utils.dart';

/// Role card widget for grid display
class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onSelect;
  final bool isSelected;

  const RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onSelect,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onSelect,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: isSelected
                ? AppColors.primaryColor
                : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200),
            width: isSelected ? 2 : 1,
          ),
        ),
        color: isSelected
            ? (isDark ? AppColors.primaryColor.withOpacity(0.2) : AppColors.primaryColor.withOpacity(0.05))
            : (isDark ? const Color(0xFF1E232D) : Colors.white),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon in circular background
              Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(isDark ? 0.25 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, size: 24.sp, color: isDark ? const Color(0xFFFF8B3D) : AppColors.primaryColor),
                ),
              ),
              SizedBox(height: 12.h),

              // Title
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 6.h),

              // Description
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    height: 1.2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
