import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class TransactionFilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const TransactionFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _buildFilterChip(context, 'All'),
          SizedBox(width: 8.w),
          _buildFilterChip(context, 'Credit'),
          SizedBox(width: 8.w),
          _buildFilterChip(context, 'Debit'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    final isSelected = selectedFilter == label;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.secondaryColor : AppColors.primaryColor;

    return GestureDetector(
      onTap: () {
        onFilterChanged(label);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : (isDark ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? Colors.grey[700]! : AppColors.grey300),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTexts.bodyMedium(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
