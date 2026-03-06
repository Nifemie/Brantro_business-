import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';

class OrderFilterTabs extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const OrderFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filters = [
      {'value': 'all', 'label': 'All'},
      {'value': 'billboard', 'label': 'Billboards'},
      {'value': 'screen', 'label': 'Screens'},
      {'value': 'wall', 'label': 'Walls'},
      {'value': 'template', 'label': 'Templates'},
      {'value': 'creative', 'label': 'Creatives'},
      {'value': 'service', 'label': 'Services'},
      {'value': 'vetting', 'label': 'Vettings'},
    ];

    return Container(
      height: 48.h,
      margin: EdgeInsets.symmetric(vertical: 12.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['value'];

          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              label: Text(
                filter['label']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.grey[700]),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onFilterChanged(filter['value']!);
                }
              },
              backgroundColor: isDark ? Colors.grey[850] : Colors.grey[100],
              selectedColor: AppColors.primaryColor,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? AppColors.primaryColor
                    : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
          );
        },
      ),
    );
  }
}
