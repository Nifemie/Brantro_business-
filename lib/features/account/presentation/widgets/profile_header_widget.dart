import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../logic/profile_provider.dart';
import 'profile/profile_banner_stack.dart';
import 'profile/profile_stat_item.dart';

// Profile Header Widget
class ProfileHeaderWidget extends ConsumerWidget {
  final VoidCallback? onEditPhoto;

  const ProfileHeaderWidget({super.key, this.onEditPhoto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileDataAsync = ref.watch(profileHeaderProvider);

    return profileDataAsync.when(
      data: (profileData) => _buildHeader(context, profileData),
      loading: () => _buildLoadingSkeleton(),
      error: (_, __) => _buildHeader(
        context,
        const ProfileHeaderData(
          avatarUrl: '',
          fullName: 'User',
          email: '',
          role: 'USER',
          experience: '0+ Years',
          productions: 0,
          genres: [],
          userId: 'user',
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProfileHeaderData profileData) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Banner Image with Profile Picture Overlay
          ProfileBannerStack(
            profileData: profileData,
            onEditPhoto: onEditPhoto,
          ),

          SizedBox(height: 60.h),

          // Name and Role
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profileData.fullName,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _formatRole(profileData.role),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: isDark ? Colors.white70 : AppColors.grey600,
                      ),
                      color: theme.cardTheme.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 20.sp,
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.grey700,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.grey700,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Future.delayed(Duration.zero, () {
                              context.push(
                                '/edit-profile',
                                extra: {
                                  'fullName': profileData.fullName,
                                  'email': profileData.email,
                                  'userId': profileData.userId,
                                  'avatarUrl': profileData.avatarUrl,
                                },
                              );
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(
                                Icons.share,
                                size: 20.sp,
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.grey700,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Share Profile',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.grey700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Navigate to messages
                        },
                        icon: Icon(Icons.chat_bubble_outline, size: 18.sp),
                        label: Text('Message'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Follow/Unfollow
                        },
                        icon: Icon(Icons.add, size: 18.sp),
                        label: Text('Follow'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.secondaryColor,
                          side: BorderSide(
                            color: AppColors.secondaryColor,
                            width: 1.5,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Stats Section
                Row(
                  children: [
                    ProfileStatItem(
                      icon: Icons.access_time,
                      iconColor: AppColors.secondaryColor,
                      label: 'Experience',
                      value: profileData.experience,
                    ),
                    SizedBox(width: 24.w),
                    ProfileStatItem(
                      icon: Icons.emoji_events,
                      iconColor: AppColors.secondaryColor,
                      label: 'Productions',
                      value: '${profileData.productions} Items',
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Genres Section
                if (profileData.genres.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.music_note,
                        color: AppColors.secondaryColor,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileData.genres.join(', '),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Genres / Niche',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 60.h),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Container(
                  width: 150.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRole(String role) {
    return role
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
