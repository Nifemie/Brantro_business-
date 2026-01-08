import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/service/session_service.dart';

// Profile Header Data Model
class ProfileHeaderData {
  final String avatarUrl;
  final String fullName;
  final String email;
  final String role;
  final String memberSince;

  const ProfileHeaderData({
    required this.avatarUrl,
    required this.fullName,
    required this.email,
    required this.role,
    required this.memberSince,
  });
}

// Profile Header provider
final profileHeaderProvider = FutureProvider<ProfileHeaderData>((ref) async {
  final isLoggedIn = await SessionService.isLoggedIn();
  
  // If not logged in, return guest data
  if (!isLoggedIn) {
    return const ProfileHeaderData(
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      fullName: 'Guest',
      email: '',
      role: 'GUEST',
      memberSince: '',
    );
  }
  
  // For logged-in users, fetch real data
  final user = await SessionService.getUser();
  final fullName = await SessionService.getUserFullname();
  final email = await SessionService.getUsername();
  
  // Extract year from user data if available
  String memberSince = 'Member since 2025';
  if (user != null && user['createdAt'] != null) {
    try {
      final createdAt = DateTime.parse(user['createdAt']);
      memberSince = 'Member since ${createdAt.year}';
    } catch (e) {
      // Use default if parsing fails
    }
  }
  
  return ProfileHeaderData(
    avatarUrl: user?['avatarUrl'] ?? 'https://i.pravatar.cc/150?img=12',
    fullName: fullName ?? user?['name'] ?? 'User',
    email: email ?? user?['emailAddress'] ?? '',
    role: user?['role'] ?? 'USER',
    memberSince: memberSince,
  );
});

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
      data: (profileData) => _buildHeader(profileData),
      loading: () => _buildLoadingSkeleton(),
      error: (_, __) => _buildHeader(const ProfileHeaderData(
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        fullName: 'User',
        email: '',
        role: 'USER',
        memberSince: 'Member since 2025',
      )),
    );
  }

  Widget _buildHeader(ProfileHeaderData profileData) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with Camera Icon
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Avatar
              Container(
                width: 102.w,
                height: 102.w,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(profileData.avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Camera Icon Button
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditPhoto ?? () {},
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
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

          SizedBox(height: 16.h),

          // Full Name
          Text(
            profileData.fullName,
            style: AppTexts.h3(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),

          if (profileData.email.isNotEmpty && profileData.role != 'GUEST') ...[
            SizedBox(height: 4.h),
            Text(
              profileData.email,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
          ],

          SizedBox(height: 12.h),

          // Role Badge - only show for non-guest users
          if (profileData.role != 'GUEST')
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              child: Text(
                _formatRole(profileData.role),
                style: AppTexts.labelSmall(color: AppColors.primaryColor),
              ),
            ),

          if (profileData.memberSince.isNotEmpty && profileData.role != 'GUEST') ...[
            SizedBox(height: 8.h),
            // Member Since
            Text(
              profileData.memberSince,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Container(
            width: 102.w,
            height: 102.w,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: 150.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }

  String _formatRole(String role) {
    // Convert SUPER_ADMIN to Super Admin, etc.
    return role
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
