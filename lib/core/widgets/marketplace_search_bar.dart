import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../core/theme/theme_provider.dart';

class MarketplaceSearchBar extends ConsumerWidget {
  final VoidCallback onAddServicePressed;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onSearchChanged;
  final String currentStatus;

  const MarketplaceSearchBar({
    super.key,
    required this.onAddServicePressed,
    required this.onStatusChanged,
    required this.onSearchChanged,
    this.currentStatus = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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
          // Row 1: Search Input & Filter Button
          Row(
            children: [
              // Search Input Box
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
                          onChanged: onSearchChanged,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search services...',
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
                      // Divider
                      Container(
                        width: 1,
                        height: double.infinity,
                        color: borderColor,
                      ),
                      // Search Icon Button
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.r),
                          bottomRight: Radius.circular(8.r),
                        ),
                        child: SizedBox(
                          width: 48.w,
                          height: 48.h,
                          child: Icon(
                            Icons.search,
                            color: iconColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Status / Filter Button
              Theme(
                data: theme.copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: PopupMenuButton<String>(
                  onSelected: onStatusChanged,
                  offset: Offset(0, 56.h),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    side: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                  itemBuilder: (context) => [
                    _buildStatusMenuItem('All', true),
                    _buildStatusMenuItem('Active', false),
                    _buildStatusMenuItem('Pending', false),
                    _buildStatusMenuItem('Inactive', false),
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
                          currentStatus.isEmpty ? 'Status' : currentStatus,
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
          SizedBox(height: 16.h),

          // Row 2: Add Service Button
          InkWell(
            onTap: onAddServicePressed,
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                      child: Icon(Icons.add, color: Colors.white, size: 12.sp),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Add Service',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildStatusMenuItem(String text, bool isFirst) {
    return PopupMenuItem<String>(
      value: text,
      height: 48.h,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: const Color(
              0xFF90A4AE,
            ),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
