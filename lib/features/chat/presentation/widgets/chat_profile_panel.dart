import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/features/chat/presentation/widgets/profile/profile_header.dart';
import 'package:brantro_business/features/chat/presentation/widgets/profile/profile_user_info.dart';
import 'package:brantro_business/features/chat/presentation/widgets/profile/profile_details.dart';
import 'package:brantro_business/features/chat/presentation/widgets/profile/profile_shared_photos.dart';

/// A right-side drawer panel that displays the contact's profile information
/// inside the chat screen.
class ChatProfilePanel extends StatelessWidget {
  const ChatProfilePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final panelBg = isDark ? const Color(0xFF1E1E2C) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.grey900;
    final subtextColor = isDark ? Colors.white60 : AppColors.grey600;
    final dividerColor = isDark ? Colors.white12 : AppColors.grey200;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: panelBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          children: [
            ProfileHeader(
              textColor: textColor,
              subtextColor: subtextColor,
            ),
            Divider(color: dividerColor, height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    ProfileUserInfo(
                      textColor: textColor,
                      subtextColor: subtextColor,
                    ),
                    SizedBox(height: 24.h),

                    Divider(color: dividerColor, height: 1),
                    SizedBox(height: 20.h),

                    ProfileDetails(
                      textColor: textColor,
                      subtextColor: subtextColor,
                      isDark: isDark,
                    ),
                    SizedBox(height: 24.h),

                    ProfileSharedPhotos(
                      textColor: textColor,
                      subtextColor: subtextColor,
                      isDark: isDark,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
