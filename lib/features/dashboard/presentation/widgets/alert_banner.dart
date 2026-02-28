import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertBanner extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onDismiss;

  const AlertBanner({
    super.key,
    required this.message,
    this.backgroundColor,
    this.textColor,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13.sp,
                color: textColor ?? Colors.orange.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(
                Icons.close,
                size: 18.sp,
                color: textColor ?? Colors.orange.shade900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
