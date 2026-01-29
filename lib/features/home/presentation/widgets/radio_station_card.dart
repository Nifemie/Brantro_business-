import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// Radio station card widget for home section
class RadioStationCard extends StatelessWidget {
  final String stationName;
  final String location;
  final String stationType; // FM or AM
  final double rating;
  final int favorites;
  final int yearsOnAir;
  final List<String> categories;
  final VoidCallback? onBookAdSlot;
  final VoidCallback? onViewProfile;

  const RadioStationCard({
    super.key,
    required this.stationName,
    required this.location,
    this.stationType = 'FM',
    this.rating = 0.0,
    this.favorites = 0,
    this.yearsOnAir = 0,
    this.categories = const [],
    this.onBookAdSlot,
    this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with badges
          _buildHeader(),
          
          // Content section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h), // Space for overlapping logo
                _buildStationName(),
                SizedBox(height: 6.h),
                _buildLocation(),
                SizedBox(height: 16.h),
                _buildMetricsRow(),
                SizedBox(height: 16.h),
                _buildCategories(),
                SizedBox(height: 16.h),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Gradient background
        Container(
          height: 80.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.grey600,
                AppColors.grey500,
                AppColors.grey400,
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
          ),
        ),
        
        // FM/AM badge (top-left)
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF7B68EE), // Purple color
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.radio,
                  color: Colors.white,
                  size: 12.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  stationType,
                  style: AppTexts.bodySmall(
                    color: Colors.white,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        
        // Location badge (top-right)
        Positioned(
          top: 12.h,
          right: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.grey700,
                  size: 12.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  '1.2M/day',
                  style: AppTexts.bodySmall(
                    color: AppColors.grey700,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        
        // Radio logo (overlapping)
        Positioned(
          bottom: -24.h,
          left: 16.w,
          child: Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: Icon(
              Icons.radio,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStationName() {
    return Text(
      stationName,
      style: AppTexts.h3(
        color: AppColors.textPrimary,
      ).copyWith(fontWeight: FontWeight.w700),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 14.sp,
          color: AppColors.grey600,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            location,
            style: AppTexts.bodySmall(
              color: AppColors.grey600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        _buildMetricItem(
          icon: Icons.star,
          iconColor: AppColors.warning,
          value: rating > 0 ? rating.toString() : '-',
          label: 'Rating',
        ),
        SizedBox(width: 24.w),
        _buildMetricItem(
          icon: Icons.favorite,
          iconColor: Colors.red,
          value: favorites > 0 ? favorites.toString() : '-',
          label: '',
        ),
        SizedBox(width: 24.w),
        _buildMetricItem(
          icon: Icons.access_time,
          iconColor: AppColors.info,
          value: yearsOnAir > 0 ? '$yearsOnAir yrs' : '-',
          label: 'On Air',
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: iconColor),
            SizedBox(width: 4.w),
            Text(
              value,
              style: AppTexts.bodyMedium(
                color: AppColors.textPrimary,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        if (label.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppTexts.bodySmall(
              color: AppColors.grey600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategories() {
    if (categories.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: categories.map((category) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: AppColors.grey300,
              width: 1,
            ),
          ),
          child: Text(
            category,
            style: AppTexts.bodySmall(
              color: AppColors.textPrimary,
            ).copyWith(fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Book Ad Slot button (filled)
        Expanded(
          child: ElevatedButton(
            onPressed: onBookAdSlot,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
            'View Rates',
            style: AppTexts.bodyMedium(
                color: Colors.white,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        
        // View Profile button (outlined)
        Expanded(
          child: OutlinedButton(
            onPressed: onViewProfile,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.secondaryColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              'View Profile',
              style: AppTexts.bodyMedium(
                color: AppColors.secondaryColor,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
