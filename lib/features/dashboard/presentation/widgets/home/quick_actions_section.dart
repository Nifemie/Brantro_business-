import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:brantro_business/core/widgets/service_quick_action_button.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/features/account/logic/profile_provider.dart';
import 'package:brantro_business/features/account/logic/persona_provider.dart';

class QuickActionsSection extends ConsumerWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileData = ref.watch(profileHeaderProvider).value;
    final activePersona = ref.watch(activePersonaProvider);
    
    bool isInfluencer;
    bool isCreator;
    bool isHost;

    if (activePersona == null) {
      // Unified view of all active roles
      isInfluencer = profileData?.isInfluencer ?? true;
      isCreator = profileData?.isCreator ?? false;
      isHost = profileData?.isHost ?? false;
    } else {
      final p = activePersona.toUpperCase();
      isInfluencer = ['INFLUENCER', 'ARTIST', 'PRODUCER', 'TV_STATION', 'RADIO_STATION', 'UGC_CREATOR', 'MEDIA_HOUSE'].contains(p);
      isCreator = ['CREATOR', 'CREATIVE', 'DESIGNER'].contains(p);
      isHost = p == 'HOST';
    }

    final List<Widget> actionButtons = [];

    // Host persona tools
    if (isHost) {
      actionButtons.addAll([
        ServiceQuickActionButton(
          icon: Icons.map_outlined,
          label: 'Billboards',
          iconColor: AppColors.secondaryColor,
          onTap: () => context.push('/billboard-marketplace'),
        ),
        ServiceQuickActionButton(
          icon: Icons.tv_rounded,
          label: 'Digital Screens',
          iconColor: AppColors.secondaryColor,
          onTap: () => context.push('/screen-marketplace'),
        ),
        ServiceQuickActionButton(
          icon: Icons.wallpaper_outlined,
          label: 'Ad Walls',
          iconColor: AppColors.secondaryColor,
          onTap: () => context.push('/wall-marketplace'),
        ),
        ServiceQuickActionButton(
          icon: Icons.directions_car_filled_outlined,
          label: 'Vehicles',
          iconColor: AppColors.secondaryColor,
          onTap: () => context.push('/vehicle-marketplace'),
        ),
      ]);
    }

    // Influencer / Media House / Artist persona tools
    if (isInfluencer) {
      actionButtons.addAll([
        ServiceQuickActionButton(
          icon: Icons.business_center_outlined,
          label: 'Services',
          iconColor: AppColors.secondaryColor,
          onTap: () => context.push('/service-marketplace'),
        ),
        ServiceQuickActionButton(
          icon: Icons.layers_outlined,
          label: 'Ad Slots',
          iconColor: AppColors.secondaryColor,
          onTap: () => context.push('/all-ad-slots'),
        ),
      ]);
    }

    // Creator / Designer persona tools
    if (isCreator) {
      actionButtons.addAll([
        ServiceQuickActionButton(
          icon: Icons.style_outlined,
          label: 'Templates',
          iconColor: AppColors.secondaryColor,
          onTap: () => context.push('/template-marketplace'),
        ),
        ServiceQuickActionButton(
          icon: Icons.palette_outlined,
          label: 'Creatives',
          iconColor: AppColors.secondaryColor,
          onTap: () => context.push('/creative-marketplace'),
        ),
      ]);
    }

    // Fallback if no specific role matched
    if (actionButtons.isEmpty) {
      actionButtons.addAll([
        ServiceQuickActionButton(
          icon: Icons.business_center_outlined,
          label: 'Services',
          iconColor: AppColors.secondaryColor,
          onTap: () => context.push('/service-marketplace'),
        ),
        ServiceQuickActionButton(
          icon: Icons.layers_outlined,
          label: 'Ad Slots',
          iconColor: AppColors.secondaryColor,
          onTap: () => context.push('/all-ad-slots'),
        ),
      ]);
    }

    // Standard support tools for all users
    actionButtons.addAll([
      ServiceQuickActionButton(
        icon: Icons.help_outline_rounded,
        label: 'FAQs',
        iconColor: AppColors.secondaryColor,
        onTap: () => context.push('/faqs'),
      ),
      ServiceQuickActionButton(
        icon: Icons.campaign_outlined,
        label: 'Announcements',
        iconColor: AppColors.secondaryColor,
        onTap: () => context.push('/announcements'),
      ),
    ]);

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
            children: actionButtons,
          ),
        ),
      ],
    );
  }
}
