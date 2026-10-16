import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../re_useable/app_color.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onFabTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    this.onFabTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 68.h + bottomPadding,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[900]! : const Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.6)
                : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home', isDark),
                _buildNavItem(1, Icons.receipt_long_rounded, 'Orders', isDark),
                SizedBox(width: 48.w), // Space for FAB
                _buildNavItem(2, Icons.account_balance_wallet_rounded, 'Wallet', isDark),
                _buildNavItem(3, Icons.person_rounded, 'Profile', isDark),
              ],
            ),
            Positioned(
              top: -20.h,
              left: MediaQuery.of(context).size.width / 2 - 28.w,
              child: GestureDetector(
                onTap: onFabTap,
                child: Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 32.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = currentIndex == index;
    // Light mode: orange when selected, medium grey when not
    // Dark mode: orange when selected, light grey when not
    final color = isSelected
        ? AppColors.secondaryColor
        : (isDark ? Colors.grey[500]! : const Color(0xFF9E9E9E));

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: AppColors.secondaryColor.withOpacity(0.08),
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(icon, color: color, size: 22.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
