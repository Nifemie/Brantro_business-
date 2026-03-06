import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/core/widgets/filter_tab_bar.dart';
import 'package:brantro_business/features/dashboard/logic/dashboard_navigation_provider.dart';

class AnalyticsFilterTabs extends ConsumerWidget {
  const AnalyticsFilterTabs({super.key});

  static const List<String> _tabs = [
    'All',
    'Billboards',
    'Screens',
    'Walls',
    'Templates',
    'Creatives',
    'Services',
    'Vettings',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(analyticsFilterProvider);

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
          tabs: _tabs,
          selectedIndex: selectedIndex,
          onTabSelected: (index) {
            ref.read(analyticsFilterProvider.notifier).state = index;
          },
        ),
      ],
    );
  }
}
