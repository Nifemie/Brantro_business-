import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// UGC Creator card widget for explore section
class UgcCreatorCard extends StatelessWidget {
  final String profileImage;
  final String name;
  final String location;
  final String workType; // e.g., "Full Time", "Part Time"
  final List<String> categories; // e.g., "Technology", "Finance"
  final List<String> skills; // e.g., "Tutorials", "Explainers"
  final String contentType; // e.g., "Short Videos, Voice Over"
  final double rating;
  final int likes;
  final VoidCallback? onViewServices;

  const UgcCreatorCard({
    super.key,
    required this.name,
    required this.location,
    this.profileImage = '',
    this.workType = '',
    this.categories = const [],
    this.skills = const [],
    this.contentType = '',
    this.rating = 0.0,
    this.likes = 0,
    this.onViewServices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
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
                SizedBox(height: 12.h),
                _buildCategories(),
                SizedBox(height: 12.h),
                _buildSkills(),
                if (contentType.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _buildContentType(),
                ],
                SizedBox(height: 16.h),
                _buildMetricsRow(),
                SizedBox(height: 16.h),
                _buildViewServicesButton(),
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
        
        // Work type badge (top-left)
        if (workType.isNotEmpty)
          Positioned(
            top: 12.h,
            left: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                workType,
                style: AppTexts.bodySmall(
                  color: Colors.white,
                ).copyWith(fontWeight: FontWeight.w600, fontSize: 10.sp),
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

  Widget _buildCategories() {
    if (categories.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: categories.map((category) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            category,
            style: AppTexts.bodySmall(
              color: Colors.white,
            ).copyWith(fontWeight: FontWeight.w600, fontSize: 11.sp),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkills() {
    if (skills.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: skills.map((skill) {
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
            skill,
            style: AppTexts.bodySmall(
              color: AppColors.textPrimary,
            ).copyWith(fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContentType() {
    return Row(
      children: [
        Icon(
          Icons.play_circle_outline,
          size: 14.sp,
          color: AppColors.secondaryColor,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            contentType,
            style: AppTexts.bodySmall(
              color: AppColors.secondaryColor,
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
        Icon(Icons.star, size: 16.sp, color: AppColors.warning),
        SizedBox(width: 4.w),
        Text(
          rating > 0 ? rating.toString() : '-',
          style: AppTexts.bodyMedium(
            color: AppColors.textPrimary,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 8.w),
        Text(
          'Rating',
          style: AppTexts.bodySmall(
            color: AppColors.grey600,
          ),
        ),
        SizedBox(width: 24.w),
        Icon(Icons.favorite, size: 16.sp, color: Colors.red),
        SizedBox(width: 4.w),
        Text(
          likes.toString(),
          style: AppTexts.bodyMedium(
            color: AppColors.textPrimary,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 8.w),
        Text(
          'Likes',
          style: AppTexts.bodySmall(
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget _buildViewServicesButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onViewServices,
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
              Icons.work_outline,
              size: 18.sp,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
            Text(
              'View Services',
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
