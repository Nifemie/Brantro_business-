import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// Designer/Creative profile card widget for explore section
class DesignerCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String location;
  final String specialization; // e.g., "Campaign Based"
  final int yearsExperience;
  final int likes;
  final int followers;
  final VoidCallback? onViewPortfolio;
  final VoidCallback? onViewServices;

  const DesignerCard({
    super.key,
    required this.profileImage,
    required this.name,
    required this.location,
    this.specialization = '',
    this.yearsExperience = 0,
    this.likes = 0,
    this.followers = 0,
    this.onViewPortfolio,
    this.onViewServices,
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
        
        // Specialization badge (top-left)
        if (specialization.isNotEmpty)
          Positioned(
            top: 12.h,
            left: 12.w,
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
                    Icons.campaign,
                    color: AppColors.grey800,
                    size: 12.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    specialization,
                    style: AppTexts.bodySmall(
                      color: AppColors.grey800,
                    ).copyWith(fontWeight: FontWeight.w600, fontSize: 10.sp),
                  ),
                ],
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
              backgroundImage: AssetImage(profileImage),
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
          label: 'Yrs Exp.',
          value: yearsExperience > 0 ? yearsExperience.toString() : '-',
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
          value: followers.toString(),
          label: 'Followers',
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    IconData? icon,
    Color? iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.sp, color: iconColor ?? AppColors.grey600),
              SizedBox(width: 4.w),
            ],
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        // View Portfolio button (outlined)
        Expanded(
          child: OutlinedButton(
            onPressed: onViewPortfolio,
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
                  'View Portfolio',
                  style: AppTexts.bodySmall(
                    color: AppColors.secondaryColor,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        
        // View Services button (filled)
        Expanded(
          child: ElevatedButton(
            onPressed: onViewServices,
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
              'View Services',
              style: AppTexts.bodySmall(
                color: Colors.white,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
