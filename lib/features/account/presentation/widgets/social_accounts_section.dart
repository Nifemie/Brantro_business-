import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class SocialAccountsSection extends StatelessWidget {
  const SocialAccountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Social Accounts',
                  style: AppTexts.labelMedium(color: AppColors.grey600),
                ),
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ],
            ),
          ),
          _buildSocialItem(
            icon: Icons.camera_alt,
            platform: 'Instagram',
            username: '@username',
            color: const Color(0xFFE4405F),
            onTap: () {
              // TODO: Navigate to add/edit Instagram
            },
          ),
          _buildDivider(),
          _buildSocialItem(
            icon: Icons.facebook,
            platform: 'Facebook',
            username: 'Not connected',
            color: const Color(0xFF1877F2),
            isConnected: false,
            onTap: () {
              // TODO: Navigate to add Facebook
            },
          ),
          _buildDivider(),
          _buildSocialItem(
            icon: Icons.alternate_email,
            platform: 'Twitter/X',
            username: 'Not connected',
            color: Colors.black,
            isConnected: false,
            onTap: () {
              // TODO: Navigate to add Twitter
            },
          ),
          _buildDivider(),
          _buildSocialItem(
            icon: Icons.play_circle_outline,
            platform: 'TikTok',
            username: 'Not connected',
            color: Colors.black,
            isConnected: false,
            onTap: () {
              // TODO: Navigate to add TikTok
            },
          ),
          _buildDivider(),
          _buildSocialItem(
            icon: Icons.video_library,
            platform: 'YouTube',
            username: 'Not connected',
            color: const Color(0xFFFF0000),
            isConnected: false,
            onTap: () {
              // TODO: Navigate to add YouTube
            },
          ),
          _buildDivider(),
          _buildSocialItem(
            icon: Icons.business_center,
            platform: 'LinkedIn',
            username: 'Not connected',
            color: const Color(0xFF0A66C2),
            isConnected: false,
            onTap: () {
              // TODO: Navigate to add LinkedIn
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialItem({
    required IconData icon,
    required String platform,
    required String username,
    required Color color,
    bool isConnected = true,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : AppColors.grey200,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        platform,
                        style: AppTexts.bodyMedium(
                          color: isDark ? Colors.white : AppColors.grey700,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        username,
                        style: AppTexts.bodySmall(
                          color: isConnected 
                              ? (isDark ? Colors.white60 : AppColors.grey600)
                              : (isDark ? Colors.white38 : AppColors.grey400),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isConnected ? Icons.edit_outlined : Icons.add,
                  color: isDark ? Colors.white38 : AppColors.grey400,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.grey200,
      ),
    );
  }
}
