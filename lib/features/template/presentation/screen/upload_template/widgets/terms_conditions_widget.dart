import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';

class TermsConditionsWidget extends StatelessWidget {
  final bool isDark;
  final bool agreeToTerms;
  final Function(bool) onTermsChanged;

  const TermsConditionsWidget({
    super.key,
    required this.isDark,
    required this.agreeToTerms,
    required this.onTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Conditions',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          Text(
            ' (Agreement)',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.white60 : AppColors.grey500,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'By uploading this template, you confirm you own full rights to the design and agree to Brantro\'s content policies, licensing rules, and community standards.',
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.white70 : AppColors.grey600,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          InkWell(
            onTap: () => onTermsChanged(!agreeToTerms),
            child: Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: agreeToTerms
                        ? AppColors.secondaryColor
                        : (isDark ? Colors.grey[800] : Colors.white),
                    border: Border.all(
                      color: agreeToTerms
                          ? AppColors.secondaryColor
                          : (isDark ? Colors.grey[600]! : AppColors.grey400),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: agreeToTerms
                      ? Icon(
                          Icons.check,
                          size: 14.sp,
                          color: Colors.white,
                        )
                      : null,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'I agree to the Terms & Conditions',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : AppColors.grey700,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
