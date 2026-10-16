import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Account type tab selector widget
class AccountTypeTab extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const AccountTypeTab({
    required this.selectedType,
    required this.onTypeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Individual Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged('Personal'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r),
                  ),
                  color: selectedType.toLowerCase().contains('personal')
                      ? (isDark ? const Color(0xFF003380).withOpacity(0.3) : Colors.blue.shade50)
                      : Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 24.sp,
                      color: selectedType.toLowerCase().contains('personal')
                          ? (isDark ? const Color(0xFF60A5FA) : Colors.blue.shade600)
                          : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Individual',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: selectedType.toLowerCase().contains('personal')
                            ? (isDark ? Colors.white : Colors.blue.shade600)
                            : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Offer services as an\nindividual',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Divider
          Container(width: 1, height: 80.h, color: isDark ? Colors.white12 : Colors.grey.shade300),
          // Company Tab
          Expanded(
            child: GestureDetector(
              onTap: () => onTypeChanged('Business'),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                  color: selectedType.toLowerCase().contains('business')
                      ? (isDark ? const Color(0xFF003380).withOpacity(0.3) : Colors.blue.shade50)
                      : Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 24.sp,
                      color: selectedType.toLowerCase().contains('business')
                          ? (isDark ? const Color(0xFF60A5FA) : Colors.blue.shade600)
                          : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Company',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: selectedType.toLowerCase().contains('business')
                            ? (isDark ? Colors.white : Colors.blue.shade600)
                            : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Offer services as a\nbusiness',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
