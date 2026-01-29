import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// Influencer profile card widget for explore section
class InfluencerCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String username;
  final String location;
  final String platform;
  final double rating;
  final int likes;
  final int followers;
  final VoidCallback? onPortfolioTap;
  final VoidCallback? onViewSlotsTap;

  const InfluencerCard({
    super.key,
    required this.profileImage,
    required this.name,
    required this.username,
    required this.location,
    this.platform = 'Instagram',
    this.rating = 0.0,
    this.likes = 0,
    this.followers = 0,
    this.onPortfolioTap,
    this.onViewSlotsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header with platform badge and profile image
          _buildHeader(),
          
          // User information
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo(),
                SizedBox(height: 16.h),
                _buildStatsRow(),
                SizedBox(height: 16.h),
                _buildActionButtons(),
                SizedBox(height: 16.h),
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.grey300,
                AppColors.grey200,
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
          ),
        ),
        
        // Platform badge
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  platform,
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
              backgroundImage: profileImage.isNotEmpty && 
                               !profileImage.startsWith('assets/')
                  ? NetworkImage(profileImage) as ImageProvider
                  : profileImage.isNotEmpty
                      ? AssetImage(profileImage)
                      : null,
              backgroundColor: AppColors.grey200,
              child: profileImage.isEmpty
                  ? Icon(Icons.person, size: 30.sp, color: AppColors.grey400)
                  : null,
            ),
          ),
        ),
        
        // Online indicator
        Positioned(
          bottom: 2.h,
          left: 60.w,
          child: Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        // Name
        Text(
          name,
          style: AppTexts.h3(
            color: AppColors.textPrimary,
          ).copyWith(fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        
        // Username
        Text(
          '@$username',
          style: AppTexts.bodyMedium(
            color: const Color(0xFF00A3E0),
          ).copyWith(fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6.h),
        
        // Location
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 14.sp,
              color: AppColors.grey500,
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
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.grey200, width: 1),
          bottom: BorderSide(color: AppColors.grey200, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.star,
            iconColor: AppColors.warning,
            label: 'Rating',
            value: rating > 0 ? rating.toString() : '—',
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.favorite,
            iconColor: Colors.red,
            label: 'Likes',
            value: likes.toString(),
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.people,
            iconColor: AppColors.primaryColor,
            label: 'Followers',
            value: followers.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40.h,
      width: 1,
      color: AppColors.grey200,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Portfolio button (outlined)
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onPortfolioTap,
            icon: Icon(
              Icons.link,
              size: 16.sp,
              color: AppColors.primaryColor,
            ),
            label: Text(
              'Portfolio',
              style: AppTexts.bodyMedium(
                color: AppColors.primaryColor,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        
        // View Slots button (filled)
        Expanded(
          child: ElevatedButton(
            onPressed: onViewSlotsTap,
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
              'View Slots',
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
