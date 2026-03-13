import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class ChatSettingsDrawer extends StatelessWidget {
  const ChatSettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final panelBg = isDark ? const Color(0xFF1E222D) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.primaryColor;
    final subtextColor = isDark ? Colors.white60 : AppColors.grey500;
    
    final iconColor = isDark ? Colors.white70 : const Color(0xFF455A64);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: panelBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context), // Close drawer
                    icon: Icon(
                      Icons.close,
                      color: textColor,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Text(
                'Setting',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            
            SizedBox(height: 16.h),

            // Profile Info Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.grey300,
                    backgroundImage: const AssetImage(
                      'assets/icons/avatars/avatars/avatar-1.jpg', // Gaston Lapierre avatar
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gaston Lapierre',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Hey there! I am using Brantro Chat.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: subtextColor,
                            height: 1.3,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.qr_code_2,
                    color: subtextColor,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            Divider(color: isDark ? Colors.white12 : AppColors.grey200, height: 1),
            SizedBox(height: 16.h),

            // Settings Options
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _SettingsOptionTile(
                    icon: Icons.vpn_key_outlined,
                    title: 'Account',
                    subtitle: 'Privacy, security,\nchange number',
                    textColor: textColor,
                    subtextColor: subtextColor,
                    iconColor: iconColor,
                  ),
                  _SettingsOptionTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'Chats',
                    subtitle: 'Theme, wallpapers,\nchat history',
                    textColor: textColor,
                    subtextColor: subtextColor,
                    iconColor: iconColor,
                  ),
                  _SettingsOptionTile(
                    icon: Icons.notifications_none,
                    title: 'Notification',
                    subtitle: 'Message, group,\ncall tones',
                    textColor: textColor,
                    subtextColor: subtextColor,
                    iconColor: iconColor,
                  ),
                  _SettingsOptionTile(
                    icon: Icons.data_usage,
                    title: 'Storage and data',
                    subtitle: 'Network usage,\nauto download',
                    textColor: textColor,
                    subtextColor: subtextColor,
                    iconColor: iconColor,
                  ),
                  _SettingsOptionTile(
                    icon: Icons.info_outline,
                    title: 'Help',
                    subtitle: 'Help center, contact\nus, privacy policy',
                    textColor: textColor,
                    subtextColor: subtextColor,
                    iconColor: iconColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color subtextColor;
  final Color iconColor;

  const _SettingsOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.subtextColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Icon(
                icon,
                color: iconColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: subtextColor,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: iconColor,
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
