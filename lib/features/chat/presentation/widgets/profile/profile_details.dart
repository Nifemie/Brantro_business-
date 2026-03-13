import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class ProfileDetails extends StatelessWidget {
  final Color textColor;
  final Color subtextColor;
  final bool isDark;

  const ProfileDetails({
    super.key,
    required this.textColor,
    required this.subtextColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(
          icon: Icons.phone_outlined,
          label: 'Phone Number:',
          value: '+1 (+1)-555-1564-261',
          textColor: textColor,
          subtextColor: subtextColor,
        ),
        SizedBox(height: 20.h),

        _InfoRow(
          icon: Icons.location_on_outlined,
          label: 'Location:',
          value: 'California, USA',
          textColor: textColor,
          subtextColor: subtextColor,
        ),
        SizedBox(height: 20.h),

        _InfoRow(
          icon: Icons.language,
          label: 'Languages:',
          value: 'English, German, Spanish,',
          textColor: textColor,
          subtextColor: subtextColor,
        ),
        SizedBox(height: 20.h),

        _GroupsSection(
          textColor: textColor,
          subtextColor: subtextColor,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textColor;
  final Color subtextColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textColor,
    required this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: subtextColor),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.only(left: 26.w),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: subtextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupsSection extends StatelessWidget {
  final Color textColor;
  final Color subtextColor;

  const _GroupsSection({
    required this.textColor,
    required this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_outline, size: 18.sp, color: subtextColor),
              SizedBox(width: 8.w),
              Text(
                'Groups:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 26.w),
            child: Row(
              children: [
                _TagChip(
                  label: 'Work',
                  bgColor: const Color(0xFF4CAF50),
                ),
                SizedBox(width: 8.w),
                _TagChip(
                  label: 'Friends',
                  bgColor: AppColors.secondaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color bgColor;

  const _TagChip({required this.label, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
