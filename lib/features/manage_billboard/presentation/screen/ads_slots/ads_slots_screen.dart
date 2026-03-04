import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/sidebar_menu.dart';
import 'widgets/ads_slots_control_panel.dart';

class AdsSlotsScreen extends StatelessWidget {
  final String billboardTitle;

  const AdsSlotsScreen({super.key, required this.billboardTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const SidebarMenu(),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'ADS SLOTS'),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Control panel with search, filters, toggle, create
                    AdsSlotsControlPanel(isDark: isDark),

                    SizedBox(height: 20.h),

                    // TODO: Ad slots list/grid content will go here
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
