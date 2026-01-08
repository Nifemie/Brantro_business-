import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class ProducerCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String location;
  final double? rating;
  final int likes;
  final int productions;
  final VoidCallback? onViewAdSlotsTap;
  final double width;

  const ProducerCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.location,
    this.rating,
    this.likes = 0,
    this.productions = 0,
    this.onViewAdSlotsTap,
    this.width = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
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
                _buildName(),
                SizedBox(height: 6.h),
                _buildLocation(),
                SizedBox(height: 16.h),
                _buildStatsRow(),
                SizedBox(height: 16.h),
                _buildActionButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        // Gradient background
        Container(
          height: 100.h,
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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(12.r),
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
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        
        // Profile picture
        Positioned(
          bottom: 0,
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
              backgroundColor: AppColors.grey300,
              backgroundImage: avatarUrl.startsWith('http')
                  ? NetworkImage(avatarUrl)
                  : AssetImage(avatarUrl) as ImageProvider,
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
          color: const Color(0xFFE91E63),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            location,
            style: AppTexts.bodySmall(
              color: const Color(0xFFE91E63),
            ).copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem(
          icon: Icons.star,
          iconColor: AppColors.warning,
          value: rating?.toString() ?? '—',
          label: 'Rating',
        ),
        SizedBox(width: 24.w),
        _buildStatItem(
          icon: Icons.favorite,
          iconColor: Colors.red,
          value: likes.toString(),
          label: 'Likes',
        ),
        SizedBox(width: 24.w),
        _buildStatItem(
          icon: Icons.video_library,
          iconColor: AppColors.primaryColor,
          value: productions.toString(),
          label: 'Productions',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
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
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTexts.bodySmall(
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onViewAdSlotsTap,
        icon: Icon(
          Icons.calendar_month,
          size: 16.sp,
          color: Colors.white,
        ),
        label: Text(
          'View Ad Slots',
          style: AppTexts.bodyMedium(
            color: Colors.white,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}
