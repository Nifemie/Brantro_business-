import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';

class AdSlotSearchFilterCard extends StatelessWidget {
  final String title;
  final TextEditingController searchController;
  final String selectedPlatform;
  final String selectedPartnerType;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onPlatformSelected;
  final ValueChanged<String> onPartnerTypeSelected;
  final VoidCallback onCreateSlotTap;

  const AdSlotSearchFilterCard({
    super.key,
    this.title = 'All Advertisement Slots',
    required this.searchController,
    required this.selectedPlatform,
    required this.selectedPartnerType,
    required this.onSearchChanged,
    required this.onPlatformSelected,
    required this.onPartnerTypeSelected,
    required this.onCreateSlotTap,
  });

  static const List<String> _platforms = [
    'All',
    'Instagram',
    'Facebook',
    'Twitter',
    'TikTok',
  ];

  static const List<String> _partnerTypes = [
    'All',
    'Influencer',
    'Advertiser',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.secondaryColor : AppColors.primaryColor;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
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
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),

          // Filters & Search Row / Column based on screen width
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 550;

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: _buildSearchBox(context, isDark)),
                    SizedBox(width: 10.w),
                    _buildPlatformDropdown(context, isDark, activeColor),
                    SizedBox(width: 10.w),
                    _buildPartnerTypeDropdown(context, isDark, activeColor),
                    SizedBox(width: 10.w),
                    _buildCreateSlotButton(context),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildSearchBox(context, isDark),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: _buildPlatformDropdown(context, isDark, activeColor)),
                        SizedBox(width: 8.w),
                        Expanded(child: _buildPartnerTypeDropdown(context, isDark, activeColor)),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: _buildCreateSlotButton(context),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Search input field with attached search button on right
  Widget _buildSearchBox(BuildContext context, bool isDark) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : AppColors.grey300,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search slots...',
                hintStyle: TextStyle(
                  fontSize: 13.sp,
                  color: isDark ? Colors.white38 : AppColors.grey500,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, size: 16.sp),
                        onPressed: () {
                          searchController.clear();
                          onSearchChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Container(
            width: 42.w,
            height: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[100],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(7.r),
                bottomRight: Radius.circular(7.r),
              ),
              border: Border(
                left: BorderSide(
                  color: isDark ? Colors.grey[700]! : AppColors.grey300,
                ),
              ),
            ),
            child: Icon(
              Icons.search,
              size: 18.sp,
              color: isDark ? Colors.white70 : AppColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  // Platform Filter Dropdown Button
  Widget _buildPlatformDropdown(BuildContext context, bool isDark, Color activeColor) {
    final isActive = selectedPlatform != 'All';
    final labelText = isActive ? 'Platform: $selectedPlatform' : 'Platform';

    return PopupMenuButton<String>(
      onSelected: onPlatformSelected,
      color: isDark ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      itemBuilder: (context) => _platforms.map((platform) {
        final isSelected = selectedPlatform == platform;
        return PopupMenuItem<String>(
          value: platform,
          child: Text(
            platform,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? activeColor
                  : (isDark ? Colors.white : AppColors.textPrimary),
            ),
          ),
        );
      }).toList(),
      child: Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isActive
                ? activeColor
                : (isDark ? Colors.grey[700]! : AppColors.grey300),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_alt_outlined,
              size: 16.sp,
              color: isActive ? activeColor : (isDark ? Colors.white70 : AppColors.grey700),
            ),
            SizedBox(width: 6.w),
            Text(
              labelText,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? activeColor : (isDark ? Colors.white70 : AppColors.grey700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Partner Type Filter Dropdown Button
  Widget _buildPartnerTypeDropdown(BuildContext context, bool isDark, Color activeColor) {
    final isActive = selectedPartnerType != 'All';
    final labelText = isActive ? 'Partner: $selectedPartnerType' : 'Partner Type';

    return PopupMenuButton<String>(
      onSelected: onPartnerTypeSelected,
      color: isDark ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      itemBuilder: (context) => _partnerTypes.map((type) {
        final isSelected = selectedPartnerType == type;
        return PopupMenuItem<String>(
          value: type,
          child: Text(
            type,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? activeColor
                  : (isDark ? Colors.white : AppColors.textPrimary),
            ),
          ),
        );
      }).toList(),
      child: Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isActive
                ? activeColor
                : (isDark ? Colors.grey[700]! : AppColors.grey300),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_alt_outlined,
              size: 16.sp,
              color: isActive ? activeColor : (isDark ? Colors.white70 : AppColors.grey700),
            ),
            SizedBox(width: 6.w),
            Text(
              labelText,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? activeColor : (isDark ? Colors.white70 : AppColors.grey700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Button: Create Slot
  Widget _buildCreateSlotButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onCreateSlotTap,
      icon: Icon(Icons.add, size: 18.sp),
      label: Text(
        'Create Slot',
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: Size(0, 42.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        elevation: 0,
      ),
    );
  }
}
