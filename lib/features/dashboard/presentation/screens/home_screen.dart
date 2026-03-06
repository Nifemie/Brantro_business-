import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/wallet_balance_card.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/quick_actions_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/analytics_filter_tabs.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/analytics_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_orders_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_billboards_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_screens_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_walls_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_ad_slots_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh logic when backend is ready
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WalletBalanceCard(),
            SizedBox(height: 24.h),
            const QuickActionsSection(),
            SizedBox(height: 24.h),
            const AnalyticsFilterTabs(),
            const AnalyticsSection(),
            SizedBox(height: 24.h),
            const RecentOrdersSection(),
            SizedBox(height: 24.h),
            const RecentBillboardsSection(),
            SizedBox(height: 24.h),
            const RecentScreensSection(),
            SizedBox(height: 24.h),
            const RecentWallsSection(),
            SizedBox(height: 24.h),
            const RecentAdSlotsSection(),
            SizedBox(height: 80.h), // Extra padding for bottom nav
          ],
        ),
      ),
    );
  }
}
