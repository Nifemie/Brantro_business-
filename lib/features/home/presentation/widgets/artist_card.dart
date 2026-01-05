import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class ArtistCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String username;
  final String location;
  final List<String> categories;
  final List<String> contentTypes;
  final double? rating;
  final int likes;
  final int followers;
  final bool isOnline;
  final VoidCallback? onPortfolioTap;
  final VoidCallback? onViewSlotsTap;
  final double width;

  const ArtistCard({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.username,
    required this.location,
    this.categories = const [],
    this.contentTypes = const ['Stories', 'Reels', 'Short Videos'],
    this.rating,
    this.likes = 0,
    this.followers = 0,
    this.isOnline = false,
    this.onPortfolioTap,
    this.onViewSlotsTap,
    this.width = 320,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.grey700,
            AppColors.grey600,
            AppColors.grey400,
            Colors.white,
          ],
          stops: const [0.0, 0.2, 0.4, 1.0],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instagram badge (optional)
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 12.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Instagram',
                    style: AppTexts.labelSmall(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Profile section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with online status
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 32.r,
                      backgroundColor: AppColors.grey300,
                      backgroundImage: avatarUrl.startsWith('http')
                          ? NetworkImage(avatarUrl)
                          : AssetImage(avatarUrl) as ImageProvider,
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 14.w,
                          height: 14.h,
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
                ),
                SizedBox(height: 12.h),

                // Name
                Text(
                  name,
                  style: AppTexts.h3(color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),

                // Username
                Text(
                  username,
                  style: AppTexts.bodySmall(color: AppColors.grey600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),

                // Location
                Row(
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
                        style: AppTexts.bodySmall(color: AppColors.grey600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Categories
                if (categories.isNotEmpty)
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: categories.map((category) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: AppColors.grey300,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          category,
                          style: AppTexts.labelSmall(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                SizedBox(height: 12.h),

                // Content types
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 4.sp,
                      color: AppColors.grey600,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        contentTypes.join(' • '),
                        style: AppTexts.bodySmall(color: AppColors.grey600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Metrics
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Rating
                    _MetricItem(
                      icon: Icons.star,
                      iconColor: AppColors.warning,
                      value: rating?.toString() ?? '—',
                      label: 'Rating',
                    ),
                    // Likes
                    _MetricItem(
                      icon: Icons.favorite,
                      iconColor: Colors.red,
                      value: likes.toString(),
                      label: 'Likes',
                    ),
                    // Followers
                    _MetricItem(
                      icon: Icons.ac_unit,
                      iconColor: AppColors.secondaryColor,
                      value: followers.toString(),
                      label: 'Followers',
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Action buttons
                Row(
                  children: [
                    // Portfolio button (outlined)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onPortfolioTap,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.secondaryColor,
                            width: 1.5,
                          ),
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
                              'Portfolio',
                              style: AppTexts.buttonMedium(
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // View Slots button (filled)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onViewSlotsTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          elevation: 0,
                        ),
                        child: Text(
                          'View Slots',
                          style: AppTexts.buttonMedium(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _MetricItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: iconColor,
            ),
            SizedBox(width: 4.w),
            Text(
              value,
              style: AppTexts.labelLarge(color: AppColors.textPrimary),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTexts.labelSmall(color: AppColors.grey600),
        ),
      ],
    );
  }
}
