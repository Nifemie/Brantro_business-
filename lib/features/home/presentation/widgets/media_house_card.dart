import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// Media house card widget for home section
class MediaHouseCard extends StatelessWidget {
  final String mediaHouseName;
  final String location;
  final List<String> mediaTypes; // Online, Video, Print, etc.
  final double rating;
  final int favorites;
  final int yearsActive;
  final List<String> categories;
  final String coverageArea; // e.g., "Lagos, FCT, Kano"
  final String reach; // e.g., "12.0M /month"
  final VoidCallback? onPlatformTap;
  final VoidCallback? onViewAdSlots;

  const MediaHouseCard({
    super.key,
    required this.mediaHouseName,
    required this.location,
    this.mediaTypes = const [],
    this.rating = 0.0,
    this.favorites = 0,
    this.yearsActive = 0,
    this.categories = const [],
    this.coverageArea = '',
    this.reach = '',
    this.onPlatformTap,
    this.onViewAdSlots,
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
                _buildMediaHouseName(),
                SizedBox(height: 6.h),
                _buildLocation(),
                SizedBox(height: 16.h),
                _buildMetricsRow(),
                SizedBox(height: 16.h),
                _buildCategories(),
                if (coverageArea.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _buildCoverageArea(),
                ],
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
        
        // Media type badges (top-left)
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Wrap(
            spacing: 6.w,
            children: mediaTypes.take(2).map((type) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: type.toLowerCase() == 'online' 
                      ? AppColors.grey300 
                      : AppColors.grey400,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  type,
                  style: AppTexts.bodySmall(
                    color: AppColors.grey800,
                  ).copyWith(fontWeight: FontWeight.w600, fontSize: 10.sp),
                ),
              );
            }).toList(),
          ),
        ),
        
        // Reach badge (top-right)
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
                  Icons.visibility,
                  color: AppColors.grey700,
                  size: 12.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  reach.isNotEmpty ? reach : '0 /month',
                  style: AppTexts.bodySmall(
                    color: AppColors.grey700,
                  ).copyWith(fontWeight: FontWeight.w500, fontSize: 10.sp),
                ),
              ],
            ),
          ),
        ),
        
        // Media house logo (overlapping)
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
            child: Center(
              child: Text(
                _getInitials(mediaHouseName),
                style: AppTexts.h4(
                  color: Colors.white,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty && words[0].length >= 2) {
      return words[0].substring(0, 2).toUpperCase();
    }
    return 'MH';
  }

  Widget _buildMediaHouseName() {
    return Text(
      mediaHouseName,
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
          value: rating > 0 ? rating.toString() : '0.0',
          label: '',
        ),
        SizedBox(width: 24.w),
        _buildMetricItem(
          icon: Icons.favorite,
          iconColor: Colors.red,
          value: favorites.toString(),
          label: '',
        ),
        SizedBox(width: 24.w),
        _buildMetricItem(
          icon: Icons.access_time,
          iconColor: AppColors.info,
          value: yearsActive > 0 ? '$yearsActive yrs' : '0 yrs',
          label: '',
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
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: iconColor),
        SizedBox(width: 4.w),
        Text(
          value,
          style: AppTexts.bodyMedium(
            color: AppColors.textPrimary,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        if (label.isNotEmpty) ...[
          SizedBox(width: 4.w),
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

  Widget _buildCoverageArea() {
    return Row(
      children: [
        Icon(
          Icons.public,
          size: 14.sp,
          color: AppColors.grey600,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            coverageArea,
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Platform button (outlined)
        Expanded(
          child: OutlinedButton(
            onPressed: onPlatformTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.secondaryColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.link,
                  size: 16.sp,
                  color: AppColors.secondaryColor,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Platform',
                  style: AppTexts.bodyMedium(
                    color: AppColors.secondaryColor,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        
        // View Ad Slots button (filled)
        Expanded(
          child: ElevatedButton(
            onPressed: onViewAdSlots,
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
              'View Ad Slots',
              style: AppTexts.bodyMedium(
                color: Colors.white,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
