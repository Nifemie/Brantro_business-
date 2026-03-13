import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/features/chat/presentation/widgets/list_drawer/drawer_search_bar.dart';
import 'package:brantro_business/features/chat/presentation/widgets/list_drawer/drawer_online_users.dart';
import 'package:brantro_business/features/chat/presentation/widgets/list_drawer/drawer_tabs.dart';
import 'package:brantro_business/features/chat/presentation/widgets/list_drawer/drawer_chat_list.dart';
import 'package:brantro_business/features/chat/presentation/widgets/list_drawer/drawer_group_list.dart';
import 'package:brantro_business/features/chat/presentation/widgets/list_drawer/drawer_contact_list.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_settings_drawer.dart';

class ChatListDrawer extends StatefulWidget {
  const ChatListDrawer({super.key});

  @override
  State<ChatListDrawer> createState() => _ChatListDrawerState();
}

class _ChatListDrawerState extends State<ChatListDrawer> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final panelBg = isDark ? const Color(0xFF1E222D) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.grey900;
    final subtextColor = isDark ? Colors.white60 : AppColors.grey600;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: panelBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 16.w, top: 12.h, bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Slide in the settings drawer over the current one
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: 'Settings',
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const Align(
                            alignment: Alignment.centerLeft,
                            child: Material(
                              elevation: 16,
                              child: ChatSettingsDrawer(),
                            ),
                          );
                        },
                        transitionBuilder: (context, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.settings_outlined,
                      color: subtextColor,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),

            DrawerSearchBar(textColor: textColor, isDark: isDark),
            SizedBox(height: 12.h),

            const DrawerOnlineUsers(),
            SizedBox(height: 16.h),

            DrawerTabs(
              isDark: isDark,
              activeIndex: _activeIndex,
              onTabChanged: (index) {
                setState(() {
                  _activeIndex = index;
                });
              },
            ),

            if (_activeIndex == 0)
              DrawerChatList(isDark: isDark)
            else if (_activeIndex == 1)
              DrawerGroupList(isDark: isDark)
            else
              DrawerContactList(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

