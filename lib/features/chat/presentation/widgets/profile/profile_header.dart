import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends StatelessWidget {
  final Color textColor;
  final Color subtextColor;

  const ProfileHeader({
    super.key,
    required this.textColor,
    required this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Profile',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              color: subtextColor,
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }
}
