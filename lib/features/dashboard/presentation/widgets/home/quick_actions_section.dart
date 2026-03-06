import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:brantro_business/core/widgets/service_quick_action_button.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            childAspectRatio: 0.95,
            children: [
              ServiceQuickActionButton(
                icon: Icons.map_outlined,
                label: 'Billboards',
                iconColor: AppColors.secondaryColor,
                onTap: () {
                  context.push('/billboard-marketplace');
                },
              ),
              ServiceQuickActionButton(
                icon: Icons.tv_rounded,
                label: 'Digital Screens',
                iconColor: AppColors.secondaryColor,
                onTap: () {
                  context.push('/screen-marketplace');
                },
              ),
              ServiceQuickActionButton(
                icon: Icons.wallpaper_outlined,
                label: 'Ad Walls',
                iconColor: AppColors.secondaryColor,
                onTap: () {
                  context.push('/wall-marketplace');
                },
              ),
              ServiceQuickActionButton(
                icon: Icons.style_outlined,
                label: 'Templates',
                iconColor: AppColors.secondaryColor,
                onTap: () {
                  context.push('/template-marketplace');
                },
              ),
              ServiceQuickActionButton(
                icon: Icons.palette_outlined,
                label: 'Creatives',
                iconColor: AppColors.secondaryColor,
                onTap: () {
                  context.push('/creative-marketplace');
                },
              ),
              ServiceQuickActionButton(
                icon: Icons.business_center_outlined,
                label: 'Services',
                iconColor: AppColors.secondaryColor,
                onTap: () {
                  context.push('/service-marketplace');
                },
              ),
              ServiceQuickActionButton(
                icon: Icons.verified_user_outlined,
                label: 'Vettings',
                iconColor: AppColors.secondaryColor,
                onTap: () {
                  // TODO: Navigate to vettings marketplace
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
