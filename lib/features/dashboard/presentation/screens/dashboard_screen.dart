import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/alert_banner.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/stat_card.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/performance_chart.dart';

import 'package:brantro_business/features/dashboard/presentation/widgets/conversions_chart.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/top_pages_table.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/recent_orders_table.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/sidebar_menu.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: const SidebarMenu(),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // TODO: Implement refresh logic when backend is ready
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      const AlertBanner(
                        message:
                            'We regret to inform you that our server is under maintenance. We will be back shortly.',
                      ),

                      SizedBox(height: 16.h),
                      StatCard(
                        icon: Icons.local_fire_department_rounded,
                        iconColor: Colors.orange,
                        title: 'Total Orders',
                        value: '13,647',
                        percentageChange: 2.3,
                        isPositive: true,
                        changeLabel: 'Last Week',
                        onViewMore: () {
                          // TODO: Navigate to orders screen
                        },
                      ),

                      SizedBox(height: 16.h),
                      StatCard(
                        icon: Icons.emoji_events_rounded,
                        iconColor: Colors.orange,
                        title: 'New Leads',
                        value: '9,526',
                        percentageChange: 8.1,
                        isPositive: true,
                        changeLabel: 'Last Week',
                        onViewMore: () {
                          // TODO: Navigate to leads screen
                        },
                      ),

                      SizedBox(height: 16.h),
                      StatCard(
                        icon: Icons.shopping_bag_rounded,
                        iconColor: Colors.orange,
                        title: 'Deals',
                        value: '976',
                        percentageChange: 0.3,
                        isPositive: false,
                        changeLabel: 'Last Week',
                        onViewMore: () {
                          // TODO: Navigate to deals screen
                        },
                      ),

                      SizedBox(height: 16.h),
                      StatCard(
                        icon: Icons.monetization_on_rounded,
                        iconColor: Colors.orange,
                        title: 'Booked Revenue',
                        value: '₦123.6k',
                        percentageChange: 10.6,
                        isPositive: false,
                        changeLabel: 'Last Week',
                        onViewMore: () {
                          // TODO: Navigate to revenue screen
                        },
                      ),

                      SizedBox(height: 20.h),
                      const PerformanceChart(),

                      SizedBox(height: 20.h),
                      const ConversionsChart(),

                      SizedBox(height: 20.h),
                      const TopPagesTable(),

                      SizedBox(height: 20.h),
                      const RecentOrdersTable(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
