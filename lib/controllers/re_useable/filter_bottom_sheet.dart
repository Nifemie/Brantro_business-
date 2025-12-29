import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_color.dart';
import 'app_texts.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>)? onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.onApplyFilters,
  });

  static void show(
    BuildContext context, {
    Function(Map<String, dynamic>)? onApplyFilters,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(onApplyFilters: onApplyFilters),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String selectedSort = 'Relevant Product';
  String selectedFilter1 = 'Filter 1';
  String selectedFilter2 = 'Filter 1';
  String selectedFilter3 = 'Filter 1';

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter title
                  Text(
                    'Filter',
                    style: AppTexts.h3(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 20.h),

                  // Sort section
                  Text(
                    'Sort',
                    style: AppTexts.h4(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildFilterChip('Relevant Product', selectedSort == 'Relevant Product', () {
                        setState(() => selectedSort = 'Relevant Product');
                      }),
                      _buildFilterChip('Review', selectedSort == 'Review', () {
                        setState(() => selectedSort = 'Review');
                      }),
                      _buildFilterChip('Newest Product', selectedSort == 'Newest Product', () {
                        setState(() => selectedSort = 'Newest Product');
                      }),
                      _buildFilterChip('Highest Price', selectedSort == 'Highest Price', () {
                        setState(() => selectedSort = 'Highest Price');
                      }),
                      _buildFilterChip('Lowest Price', selectedSort == 'Lowest Price', () {
                        setState(() => selectedSort = 'Lowest Price');
                      }),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Other Filter 1
                  Text(
                    'Other Filter 1',
                    style: AppTexts.h4(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildFilterChip('Filter 1', selectedFilter1 == 'Filter 1', () {
                        setState(() => selectedFilter1 = 'Filter 1');
                      }),
                      _buildFilterChip('Filter 2', selectedFilter1 == 'Filter 2', () {
                        setState(() => selectedFilter1 = 'Filter 2');
                      }),
                      _buildFilterChip('Filter 3', selectedFilter1 == 'Filter 3', () {
                        setState(() => selectedFilter1 = 'Filter 3');
                      }),
                      _buildFilterChip('Filter 4', selectedFilter1 == 'Filter 4', () {
                        setState(() => selectedFilter1 = 'Filter 4');
                      }),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Other Filter 2
                  Text(
                    'Other Filter 2',
                    style: AppTexts.h4(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildFilterChip('Filter 1', selectedFilter2 == 'Filter 1', () {
                        setState(() => selectedFilter2 = 'Filter 1');
                      }),
                      _buildFilterChip('Filter 2', selectedFilter2 == 'Filter 2', () {
                        setState(() => selectedFilter2 = 'Filter 2');
                      }),
                      _buildFilterChip('Filter 3', selectedFilter2 == 'Filter 3', () {
                        setState(() => selectedFilter2 = 'Filter 3');
                      }),
                      _buildFilterChip('Filter 4', selectedFilter2 == 'Filter 4', () {
                        setState(() => selectedFilter2 = 'Filter 4');
                      }),
                      _buildFilterChip('Filter 5', selectedFilter2 == 'Filter 5', () {
                        setState(() => selectedFilter2 = 'Filter 5');
                      }),
                      _buildFilterChip('Filter 6', selectedFilter2 == 'Filter 6', () {
                        setState(() => selectedFilter2 = 'Filter 6');
                      }),
                      _buildFilterChip('Filter 7', selectedFilter2 == 'Filter 7', () {
                        setState(() => selectedFilter2 = 'Filter 7');
                      }),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Other Filter 3
                  Text(
                    'Other Filter 3',
                    style: AppTexts.h4(color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildFilterChip('Filter 1', selectedFilter3 == 'Filter 1', () {
                        setState(() => selectedFilter3 = 'Filter 1');
                      }),
                      _buildFilterChip('Filter 2', selectedFilter3 == 'Filter 2', () {
                        setState(() => selectedFilter3 = 'Filter 2');
                      }),
                      _buildFilterChip('Filter 3', selectedFilter3 == 'Filter 3', () {
                        setState(() => selectedFilter3 = 'Filter 3');
                      }),
                      _buildFilterChip('Filter 4', selectedFilter3 == 'Filter 4', () {
                        setState(() => selectedFilter3 = 'Filter 4');
                      }),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.grey300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: AppTexts.bodySmall(
            color: isSelected ? Colors.white : AppColors.grey600,
          ),
        ),
      ),
    );
  }
}
