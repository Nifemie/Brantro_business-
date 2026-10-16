import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/re_useable/app_color.dart';
import 'active_filter_chips.dart';

class SearchFilterCard extends StatelessWidget {
  final String title;
  final TextEditingController searchController;
  final String searchHint;
  final VoidCallback? onFilterTap;
  final VoidCallback? onActionButtonTap;
  final String? actionButtonLabel;
  final IconData? actionButtonIcon;
  final bool showActionButton;
  final bool showFilterButton;
  final Map<String, String?>? selectedFilters;
  final Function(String key)? onRemoveFilter;
  final VoidCallback? onClearFilters;
  final Function(String query)? onChanged;

  const SearchFilterCard({
    super.key,
    required this.title,
    required this.searchController,
    this.searchHint = 'Search...',
    this.onFilterTap,
    this.onActionButtonTap,
    this.actionButtonLabel,
    this.actionButtonIcon,
    this.showActionButton = true,
    this.showFilterButton = true,
    this.selectedFilters,
    this.onRemoveFilter,
    this.onClearFilters,
    this.onChanged,
  });

  int get _activeFilterCount {
    if (selectedFilters == null) return 0;
    return selectedFilters!.values
        .where((v) => v != null && v.isNotEmpty)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.secondaryColor : AppColors.primaryColor;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),

          // Search Bar
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : AppColors.grey300,
              ),
            ),
            child: TextField(
              controller: searchController,
              onChanged: onChanged,
              style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white38 : AppColors.grey500,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white60 : AppColors.grey500,
                  size: 20.sp,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, size: 18.sp),
                        onPressed: () {
                          searchController.clear();
                          if (onChanged != null) onChanged!('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Buttons Row
          Row(
            children: [
              // Filters Button with Badge
              if (showFilterButton)
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      OutlinedButton.icon(
                        onPressed: onFilterTap,
                        icon: Icon(
                          Icons.filter_list,
                          size: 20.sp,
                          color: _activeFilterCount > 0
                              ? activeColor
                              : (isDark ? Colors.white70 : AppColors.grey700),
                        ),
                        label: Text(
                          _activeFilterCount > 0
                              ? 'Filters ($_activeFilterCount)'
                              : 'Filters',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: _activeFilterCount > 0
                                ? FontWeight.w700
                                : FontWeight.normal,
                            color: _activeFilterCount > 0
                                ? activeColor
                                : (isDark ? Colors.white70 : AppColors.grey700),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 44.h),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(
                            color: _activeFilterCount > 0
                                ? activeColor
                                : (isDark ? Colors.grey[700]! : AppColors.grey300),
                            width: _activeFilterCount > 0 ? 1.5 : 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      if (_activeFilterCount > 0)
                        Positioned(
                          right: 8.w,
                          top: -6.h,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: activeColor,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 18.w,
                              minHeight: 18.h,
                            ),
                            child: Center(
                              child: Text(
                                '$_activeFilterCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              if (showFilterButton && showActionButton) SizedBox(width: 12.w),

              // Action Button (e.g., Upload Template)
              if (showActionButton)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onActionButtonTap,
                    icon: Icon(
                      actionButtonIcon ?? Icons.add,
                      size: 20.sp,
                    ),
                    label: Text(
                      actionButtonLabel ?? 'Action',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
            ],
          ),

          // Active Filter Chips
          if (selectedFilters != null &&
              onRemoveFilter != null &&
              onClearFilters != null)
            ActiveFilterChips(
              selectedFilters: selectedFilters!,
              onRemoveFilter: onRemoveFilter!,
              onClearAll: onClearFilters!,
            ),
        ],
      ),
    );
  }
}

