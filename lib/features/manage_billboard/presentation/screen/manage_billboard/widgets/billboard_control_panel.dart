import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:brantro_business/core/theme/theme_provider.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class BillboardControlPanel extends ConsumerStatefulWidget {
  const BillboardControlPanel({super.key});

  @override
  ConsumerState<BillboardControlPanel> createState() =>
      _BillboardControlPanelState();
}

class _BillboardControlPanelState extends ConsumerState<BillboardControlPanel> {
  String _currentFilter = '';

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    final bgColor = isDark ? const Color(0xFF1E2125) : Colors.white;
    final inputBgColor = isDark ? const Color(0xFF1A1C20) : AppColors.grey100;
    final borderColor = isDark ? const Color(0xFF2C3138) : AppColors.grey200;
    final textColor = isDark ? Colors.grey[400] : AppColors.grey600;
    final iconColor = isDark ? Colors.grey[500] : AppColors.grey500;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header label
          Text(
            'Manage Billboard',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 14.h),

          // Row 1: Search + Filters
          Row(
            children: [
              // Search Input
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: inputBgColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search locations...',
                            hintStyle: TextStyle(
                              color: textColor,
                              fontSize: 14.sp,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                      ),
                      // Vertical divider
                      Container(
                        width: 1,
                        height: double.infinity,
                        color: borderColor,
                      ),
                      // Search icon
                      SizedBox(
                        width: 48.w,
                        height: 48.h,
                        child: Icon(
                          Icons.search,
                          color: iconColor,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),

              // Filters Button — white popup matching screenshot
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: PopupMenuButton<String>(
                  onSelected: (val) {
                    setState(() => _currentFilter = val == 'All' ? '' : val);
                  },
                  offset: Offset(0, 56.h),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    side: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  itemBuilder: (context) => [
                    _filterItem('All'),
                    _filterItem('Active'),
                    _filterItem('Pending'),
                    _filterItem('InActive'),
                  ],
                  child: Container(
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.grey[400],
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _currentFilter.isEmpty ? 'Filters' : _currentFilter,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Create or Upload Billboard — compact button (does not exceed search bar width)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  // TODO: Navigate to create/upload billboard
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00388B),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Create or Upload Billboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _filterItem(String text) {
    return PopupMenuItem<String>(
      value: text,
      height: 48.h,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xFF90A4AE),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
