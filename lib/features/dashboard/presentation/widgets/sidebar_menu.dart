import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/sidebar_navigation_list.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300.w,
      backgroundColor: AppColors.primaryColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Branding Header
            Padding(
              padding: EdgeInsets.only(top: 40.h, bottom: 20.h),
              child: Center(
                child: Image.asset(
                  'assets/brantro/screensy-05.png',
                  height: 32.h, // Reduced height
                ),
              ),
            ),

            Divider(
              color: Colors.black.withOpacity(0.3), // Darker line
              thickness: 1,
              height: 1,
            ),

            // Navigation List
            const Expanded(child: SidebarNavigationList()),
          ],
        ),
      ),
    );
  }
}
