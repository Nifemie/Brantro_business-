import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/re_useable/app_color.dart';

class ActiveFilterChips extends StatelessWidget {
  final Map<String, String?> selectedFilters;
  final Function(String key) onRemoveFilter;
  final VoidCallback onClearAll;

  const ActiveFilterChips({
    super.key,
    required this.selectedFilters,
    required this.onRemoveFilter,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.secondaryColor : AppColors.primaryColor;

    final activeEntries = selectedFilters.entries
        .where((e) => e.value != null && e.value!.isNotEmpty)
        .toList();

    if (activeEntries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Filters:',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : AppColors.grey700,
                ),
              ),
              InkWell(
                onTap: onClearAll,
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: activeColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: activeEntries.map((entry) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: activeColor.withOpacity(isDark ? 0.6 : 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${entry.key}: ${entry.value}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: activeColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () => onRemoveFilter(entry.key),
                      child: Icon(
                        Icons.close,
                        size: 14.sp,
                        color: activeColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
