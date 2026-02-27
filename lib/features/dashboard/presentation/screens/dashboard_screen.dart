import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/alert_banner.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                        message: 'We regret to inform you that our server is under maintenance. We will be back shortly.',
                      ),
                      SizedBox(height: 20.h),
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
