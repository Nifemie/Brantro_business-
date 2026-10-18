import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class QuickActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final IconData? customIcon;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.isPrimary,
    this.customIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Define colors based on primary status
    final bgColor = isPrimary ? AppColors.primaryColor : Colors.transparent;

    final borderColor = isPrimary
        ? (isDark ? Colors.white.withValues(alpha: 0.15) : Colors.transparent)
        : const Color(0xFFE87A4F); // Orange from the image

    final textColor = isPrimary
        ? Colors.white
        : const Color(0xFFE87A4F); // Orange from the image

    final icon = customIcon ?? (isPrimary ? Icons.arrow_upward : Icons.account_balance);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(100.r),
            border: isPrimary && !isDark
                ? null
                : Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 20.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: AppTexts.buttonMedium(
                      color: textColor,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
