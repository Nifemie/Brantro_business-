import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/utils/avatar_helper.dart';
import '../../../logic/profile_provider.dart';

class ProfileBannerStack extends StatelessWidget {
  final ProfileHeaderData profileData;
  final VoidCallback? onEditPhoto;

  const ProfileBannerStack({
    super.key,
    required this.profileData,
    this.onEditPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = AvatarHelper.getAvatar(
      avatarUrl: profileData.avatarUrl,
      userId: profileData.userId,
    );

    final hasBanner = profileData.bannerUrl.trim().isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Banner Image or Clean Empty Placeholder
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            color: isDark ? const Color(0xFF1E232B) : const Color(0xFFE2E8F0),
            image: hasBanner
                ? DecorationImage(
                    image: AvatarHelper.getImageProvider(profileData.bannerUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: !hasBanner
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: isDark ? Colors.white24 : Colors.grey[400],
                        size: 36.sp,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'No cover photo added',
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey[500],
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
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
                    image: AvatarHelper.getImageProvider(avatarUrl),
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
    );
  }
}
