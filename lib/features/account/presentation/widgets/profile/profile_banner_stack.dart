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

    return Stack(
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
    );
  }
}
