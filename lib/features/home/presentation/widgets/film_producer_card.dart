import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// Film Producer card widget for explore section
class FilmProducerCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String location;
  final double rating;
  final int likes;
  final int productions;
  final VoidCallback? onViewAdSlots;

  const FilmProducerCard({
    super.key,
    required this.name,
    required this.location,
    this.profileImage = '',
    this.rating = 0.0,
    this.likes = 0,
    this.productions = 0,
    this.onViewAdSlots,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
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
          // Header with gradient
          _buildHeader(),
          
          // Content section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h), // Space for overlapping profile
                _buildName(),
                SizedBox(height: 6.h),
                _buildLocation(),
                SizedBox(height: 16.h),
                _buildMetricsRow(),
                SizedBox(height: 16.h),
                _buildViewAdSlotsButton(),
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
        
        // Film Producer badge (top-left)
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.grey800,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.movie,
                  color: Colors.white,
                  size: 12.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Film Producer',
                  style: AppTexts.bodySmall(
                    color: Colors.white,
                  ).copyWith(fontWeight: FontWeight.w600, fontSize: 10.sp),
                ),
              ],
            ),
          ),
        ),
        
        // Favorite icon (top-right)
        Positioned(
          top: 12.h,
          right: 12.w,
          child: Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              color: AppColors.grey600,
              size: 16.sp,
            ),
          ),
        ),
        
        // Profile picture (overlapping)
        Positioned(
          bottom: -24.h,
          left: 16.w,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 30.r,
              backgroundImage: profileImage.isNotEmpty 
                  ? AssetImage(profileImage) 
                  : null,
              child: profileImage.isEmpty
                  ? Icon(Icons.person, size: 30.sp, color: AppColors.grey400)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildName() {
    return Text(
      name,
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
          value: likes.toString(),
          label: 'Likes',
        ),
        SizedBox(width: 24.w),
        _buildMetricItem(
          icon: Icons.movie_creation,
          iconColor: AppColors.info,
          value: productions.toString(),
          label: 'Productions',
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
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTexts.bodySmall(
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget _buildViewAdSlotsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onViewAdSlots,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 18.sp,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
            Text(
              'View Ad Slots',
              style: AppTexts.bodyLarge(
                color: Colors.white,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
