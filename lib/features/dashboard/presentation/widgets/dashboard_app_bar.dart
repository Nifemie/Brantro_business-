import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/service/session_service.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../core/utils/avatar_helper.dart';
import '../../../../core/theme/theme_provider.dart';

class DashboardAppBar extends ConsumerWidget {
  final String title;
  
  const DashboardAppBar({
    super.key,
    this.title = 'WELCOME!',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return FutureBuilder<Map<String, dynamic>?>(
      future: SessionService.getUser().then((value) => 
        value != null ? Map<String, dynamic>.from(value) : null
      ),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final userId = user?['id']?.toString() ?? user?['userId']?.toString() ?? 'user';
        final avatarUrl = AvatarHelper.getAvatar(
          avatarUrl: user?['avatarUrl'] ?? '',
          userId: userId,
        );

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: theme.appBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                  size: 24.sp,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 40.w),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.grey[800],
                    letterSpacing: 1.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
                icon: Icon(
                  ref.watch(themeModeProvider) == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                  size: 20.sp,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 40.w),
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      context.push('/notifications');
                    },
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                      size: 22.sp,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 40.w),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.h),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                offset: Offset(0, 50.h),
                color: ref.watch(themeModeProvider) == ThemeMode.dark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: ref.watch(themeModeProvider) == ThemeMode.dark
                      ? const BorderSide(color: Colors.white24, width: 1)
                      : BorderSide.none,
                ),
                padding: EdgeInsets.zero,
                child: CircleAvatar(
                  radius: 16.r,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AvatarHelper.isDefaultAvatar(avatarUrl)
                      ? AssetImage(avatarUrl) as ImageProvider
                      : NetworkImage(avatarUrl),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: FutureBuilder<String?>(
                        future: SessionService.getUserFullname(),
                        builder: (context, nameSnapshot) {
                          final name = nameSnapshot.data ?? 'Welcome!';
                          return Text(
                            'Welcome $name!',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const PopupMenuDivider(),
                  _buildMenuItem(
                    value: 'profile',
                    icon: Icons.person_outline,
                    label: 'Profile',
                  ),
                  _buildMenuItem(
                    value: 'messages',
                    icon: Icons.chat_bubble_outline,
                    label: 'Messages',
                  ),
                  _buildMenuItem(
                    value: 'pricing',
                    icon: Icons.folder_outlined,
                    label: 'Pricing',
                  ),
                  _buildMenuItem(
                    value: 'help',
                    icon: Icons.help_outline,
                    label: 'Help',
                  ),
                  _buildMenuItem(
                    value: 'lock',
                    icon: Icons.lock_outline,
                    label: 'Lock screen',
                  ),
                  const PopupMenuDivider(),
                  _buildMenuItem(
                    value: 'logout',
                    icon: Icons.logout,
                    label: 'Logout',
                    isDestructive: true,
                  ),
                ],
                onSelected: (value) async {
                  switch (value) {
                    case 'profile':
                      context.push('/profile');
                      break;
                    case 'messages':
                      // TODO: Navigate to messages
                      break;
                    case 'pricing':
                      // TODO: Navigate to pricing
                      break;
                    case 'help':
                      // TODO: Navigate to help
                      break;
                    case 'lock':
                      // TODO: Lock screen
                      break;
                    case 'logout':
                      await _handleLogout(context);
                      break;
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
  }) {
    return PopupMenuItem(
      value: value,
      child: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Row(
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: isDestructive ? Colors.red : (isDark ? Colors.white70 : AppColors.grey600),
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDestructive ? Colors.red : (isDark ? Colors.white : AppColors.textPrimary),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.grey600,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await SessionService.clearSession();
      if (context.mounted) {
        context.go('/signin');
      }
    }
  }
}
