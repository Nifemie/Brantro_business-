import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../core/utils/avatar_helper.dart';
import '../../logic/profile_provider.dart';

// Profile Header Widget
class ProfileHeaderWidget extends ConsumerWidget {
  final VoidCallback? onEditPhoto;

  const ProfileHeaderWidget({
    super.key,
    this.onEditPhoto,
  });

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
    final avatarUrl = AvatarHelper.getAvatar(
      avatarUrl: profileData.avatarUrl,
      userId: profileData.userId,
    );

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
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Banner Image
              Container(
                height: 200.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  image: DecorationImage(
                    image: profileData.bannerUrl.isNotEmpty
                        ? NetworkImage(profileData.bannerUrl)
                        : const AssetImage('assets/promotions/billboard1.jpg')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Profile Picture (Overlapping)
              Positioned(
                bottom: -50.h,
                left: 20.w,
                child: Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        image: DecorationImage(
                          image: AvatarHelper.isDefaultAvatar(avatarUrl)
                              ? AssetImage(avatarUrl) as ImageProvider
                              : NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Camera icon for editing
                    if (onEditPhoto != null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: onEditPhoto,
                          child: Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
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
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _formatRole(profileData.role),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark ? Colors.white70 : AppColors.grey600,
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
                                color: isDark ? Colors.white70 : AppColors.grey700,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  color: isDark ? Colors.white : AppColors.grey700,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Future.delayed(Duration.zero, () {
                              context.push('/edit-profile');
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(
                                Icons.share,
                                size: 20.sp,
                                color: isDark ? Colors.white70 : AppColors.grey700,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Share Profile',
                                style: TextStyle(
                                  color: isDark ? Colors.white : AppColors.grey700,
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
                    _buildStatItem(
                      icon: Icons.access_time,
                      iconColor: AppColors.secondaryColor,
                      label: 'Experience',
                      value: profileData.experience,
                    ),
                    SizedBox(width: 24.w),
                    _buildStatItem(
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

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          
          return Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: iconColor, size: 24.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.white70 : AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
