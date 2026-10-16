import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/core/widgets/filter_tab_bar.dart';
import 'package:brantro_business/features/dashboard/logic/dashboard_navigation_provider.dart';
import 'package:brantro_business/features/account/logic/profile_provider.dart';

class AnalyticsFilterTabs extends ConsumerWidget {
  const AnalyticsFilterTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(profileHeaderProvider).value;
    final userRole = profileData?.role?.toUpperCase();
    final isInfluencer = userRole == 'INFLUENCER' ||
        userRole == 'PRODUCER' ||
        userRole == 'ARTIST' ||
        userRole == 'TV_STATION' ||
        userRole == 'RADIO_STATION' ||
        userRole == 'UGC_CREATOR';

    final tabs = isInfluencer
        ? const ['All', 'Services']
        : const [
            'All',
            'Billboards',
            'Screens',
            'Walls',
            'Templates',
            'Creatives',
            'Services',
            'Vettings',
          ];

    final selectedIndex = ref.watch(analyticsFilterProvider);
    final safeSelectedIndex = selectedIndex >= tabs.length ? 0 : selectedIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Analytics',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        FilterTabBar(
          tabs: tabs,
          selectedIndex: safeSelectedIndex,
          onTabSelected: (index) {
            ref.read(analyticsFilterProvider.notifier).state = index;
          },
        ),
      ],
    );
  }
}
