import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// Artist profile card widget for explore section (new compact design)
class ArtistProfileCard extends StatelessWidget {
  final int userId;
  final String profileImage;
  final String name;
  final String location;
  final List<String> tags;
  final double? rating;
  final int likes;
  final int works;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onViewSlotsTap;

  const ArtistProfileCard({
    super.key,
    required this.userId,
    required this.profileImage,
    required this.name,
    required this.location,
    this.tags = const [],
    this.rating,
    this.likes = 0,
    this.works = 0,
    this.isFavorite = false,
    this.onFavoriteTap,
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
          // Header with gradient and badges
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
                SizedBox(height: 12.h),
                _buildTags(),
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
        
        // Artist badge (top-left)
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 12.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Artist',
                  style: AppTexts.bodySmall(
                    color: Colors.white,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        
        // Favorite button (top-right)
        Positioned(
          top: 12.h,
          right: 12.w,
          child: GestureDetector(
            onTap: onFavoriteTap,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : AppColors.grey600,
                size: 18.sp,
              ),
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
              backgroundImage: profileImage.isNotEmpty
                  ? (profileImage.startsWith('http')
                      ? NetworkImage(profileImage) as ImageProvider
                      : AssetImage(profileImage))
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
          color: const Color(0xFFE91E63), // Pink/red color for location
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

  Widget _buildTags() {
    if (tags.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: tags.map((tag) {
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
            tag,
            style: AppTexts.bodySmall(
              color: AppColors.textPrimary,
            ).copyWith(fontWeight: FontWeight.w500),
          ),
        );
      }).toList().cast<Widget>(),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem(
          icon: Icons.star,
          iconColor: AppColors.warning,
          value: rating != null ? rating.toString() : '—',
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
          icon: Icons.work_outline,
          iconColor: AppColors.primaryColor,
          value: works.toString(),
          label: 'Works',
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
      child: Builder(
        builder: (context) {
          return ElevatedButton.icon(
            onPressed: () {
              // Navigate to artist ad slots screen using push instead of goNamed
              context.push(
                '/artist-ad-slots/${userId}',
                extra: {
                  'sellerName': name,
                  'sellerAvatar': profileImage,
                  'sellerType': 'Artist',
                },
              );
              
              // Also call the callback if provided
              onViewSlotsTap?.call();
            },
            icon: Icon(
              Icons.calendar_today,
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
          );
        }
      ),
    );
  }
}
