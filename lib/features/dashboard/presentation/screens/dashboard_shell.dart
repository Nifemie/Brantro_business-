import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/sidebar_menu.dart';
import 'package:brantro_business/features/dashboard/presentation/screens/home_screen.dart';
import 'package:brantro_business/features/orders/presentation/screens/orders_screen.dart';
import 'package:brantro_business/features/dashboard/presentation/screens/wallet_screen.dart';
import 'package:brantro_business/features/account/presentation/user_account.dart';
import 'package:brantro_business/controllers/re_useable/bottom_nav_bar.dart';
import 'package:brantro_business/features/dashboard/logic/dashboard_navigation_provider.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'dart:ui';

class DashboardShell extends ConsumerStatefulWidget {
  const DashboardShell({super.key});

  @override
  ConsumerState<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends ConsumerState<DashboardShell> {
  DateTime? _lastBackPressed;

  final List<Widget> _screens = const [
    HomeScreen(),
    OrdersScreen(),
    WalletScreen(),
    UserAccount(),
  ];

  Future<bool> _onWillPop() async {
    final currentIndex = ref.read(dashboardNavigationProvider);

    // If not on home screen, go back to home
    if (currentIndex != 0) {
      ref.read(dashboardNavigationProvider.notifier).state = 0;
      return false;
    }

    // If on home screen, show exit confirmation
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        _lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      _lastBackPressed = now;

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Press back again to exit'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      }
      return false;
    }

    // Exit the app
    SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = ref.watch(dashboardNavigationProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        drawer: const SidebarMenu(),
        body: Column(
          children: [
            if (currentIndex != 3) const DashboardAppBar(showBackButton: false),
            Expanded(
              child: _screens[currentIndex],
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: BottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(dashboardNavigationProvider.notifier).state = index;
            },
            onFabTap: () => _showQuickActionMenu(context),
          ),
        ),
      ),
    );
  }

  void _showQuickActionMenu(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.3)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildQuickActionItem(
                    context,
                    icon: Icons.style_outlined,
                    title: 'Upload Template',
                    subtitle: 'Add a new design template',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/upload-template');
                    },
                  ),
                  _buildQuickActionItem(
                    context,
                    icon: Icons.palette_outlined,
                    title: 'Upload Creative',
                    subtitle: 'Add creative content',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/upload-creative');
                    },
                  ),
                  _buildQuickActionItem(
                    context,
                    icon: Icons.map_outlined,
                    title: 'Add Billboard',
                    subtitle: 'Register a new billboard',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to add billboard
                    },
                  ),
                  _buildQuickActionItem(
                    context,
                    icon: Icons.business_center_outlined,
                    title: 'Add Service',
                    subtitle: 'Offer a new service',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to add service
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.secondaryColor, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
