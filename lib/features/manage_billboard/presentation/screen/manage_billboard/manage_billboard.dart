import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:brantro_business/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/sidebar_menu.dart';
import 'widgets/billboard_control_panel.dart';
import 'widgets/billboard_card/billboard_card.dart';
import 'widgets/billboard_filter_panel.dart';

class ManageBillboardScreen extends ConsumerStatefulWidget {
  const ManageBillboardScreen({super.key});

  @override
  ConsumerState<ManageBillboardScreen> createState() =>
      _ManageBillboardScreenState();
}

class _ManageBillboardScreenState extends ConsumerState<ManageBillboardScreen> {
  Future<bool> _onWillPop() async {
    if (mounted) context.go('/dashboard');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) await _onWillPop();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        drawer: const SidebarMenu(),
        body: SafeArea(
          child: Column(
            children: [
              // Same pattern as ServiceMarketplaceScreen
              const DashboardAppBar(title: 'LOCATIONS'),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),

                      // Search + Filters + Create Button panel
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: const BillboardControlPanel(),
                      ),

                      SizedBox(height: 20.h),

                      // Filter label row
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Text(
                              'Filter',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Type: BILLBOARD',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Billboard cards
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: const [
                            BillboardCard(
                              imageAsset: 'assets/brantro/billboard_sample.jpg',
                              title: 'Kubwa Main Road Billboard',
                              location:
                                  'Kubwa Main Road, Kuje, Federal Capital Territory, Nigeria',
                              status: 'Active',
                            ),
                            BillboardCard(
                              imageAsset: 'assets/brantro/billboard_nyanya.png',
                              title: 'Nyanya Expressway Billboard',
                              location:
                                  'Nyanya Expressway, Gwagwalada, Federal Capital Territory, Nigeria',
                              status: 'Active',
                            ),
                            BillboardCard(
                              imageAsset:
                                  'assets/brantro/billboard_wuse_constrix.png',
                              title: 'Wuse Central Billboard',
                              location:
                                  'Wuse Central Junction, Kwali, Federal Capital Territory, Nigeria',
                              status: 'Active',
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // Search bar below cards
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: _BillboardSearchBar(isDark: isDark),
                      ),

                      SizedBox(height: 16.h),

                      // Filter panel below search bar
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: BillboardFilterPanel(isDark: isDark),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BillboardSearchBar extends StatelessWidget {
  final bool isDark;

  const _BillboardSearchBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.13)
                  : Colors.black.withValues(alpha: 0.09),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              Icon(
                Icons.search_rounded,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search ...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
            ],
          ),
        ),
      ),
    );
  }
}
