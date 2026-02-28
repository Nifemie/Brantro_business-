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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
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
                      ? Colors.blue.shade50
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
                          ? Colors.blue.shade600
                          : Colors.grey.shade600,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Individual',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: selectedType.toLowerCase().contains('personal')
                            ? Colors.blue.shade600
                            : Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Offer services as an\nindividual',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Divider
          Container(width: 1, height: 80.h, color: Colors.grey.shade300),
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
                      ? Colors.blue.shade50
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
                          ? Colors.blue.shade600
                          : Colors.grey.shade600,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Company',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: selectedType.toLowerCase().contains('business')
                            ? Colors.blue.shade600
                            : Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Offer services as a\nbusiness',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
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
