import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// TV station card widget for home section
class TvStationCard extends StatelessWidget {
  final String stationName;
  final String location;
  final String stationType; // Terrestrial, Satellite, Cable, etc.
  final bool isFree;
  final bool isLive;
  final double rating;
  final int favorites;
  final int yearsOnAir;
  final List<String> categories;
  final String broadcastArea; // e.g., "Borno, Yobe, Adamawa"
  final VoidCallback? onViewRates;
  final VoidCallback? onViewProfile;

  const TvStationCard({
    super.key,
    required this.stationName,
    required this.location,
    this.stationType = 'Terrestrial',
    this.isFree = false,
    this.isLive = false,
    this.rating = 0.0,
    this.favorites = 0,
    this.yearsOnAir = 0,
    this.categories = const [],
    this.broadcastArea = '',
    this.onViewRates,
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
                if (broadcastArea.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _buildBroadcastArea(),
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
        
        // Station type badge (top-left)
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
                  Icons.tv,
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
        
        // Free badge (top-center-left)
        if (isFree)
          Positioned(
            top: 12.h,
            left: 100.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Free',
                style: AppTexts.bodySmall(
                  color: Colors.white,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
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
                  '170.0K/day',
                  style: AppTexts.bodySmall(
                    color: AppColors.grey700,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        
        // Live badge (bottom-right of header)
        if (isLive)
          Positioned(
            top: 50.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'LIVE',
                style: AppTexts.bodySmall(
                  color: Colors.white,
                ).copyWith(fontWeight: FontWeight.bold, fontSize: 10.sp),
              ),
            ),
          ),
        
        // TV logo (overlapping)
        Positioned(
          bottom: -24.h,
          left: 16.w,
          child: Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.grey300,
                width: 3,
              ),
            ),
            child: Icon(
              Icons.tv,
              color: AppColors.primaryColor,
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
          label: '',
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

  Widget _buildBroadcastArea() {
    return Row(
      children: [
        Icon(
          Icons.broadcast_on_personal,
          size: 14.sp,
          color: AppColors.grey600,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            broadcastArea,
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
        // View Rates button (filled)
        Expanded(
          child: ElevatedButton(
            onPressed: onViewRates,
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
