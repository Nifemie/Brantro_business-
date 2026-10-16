import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/features/account/logic/analytics_provider.dart';

class AudienceAnalyticsCards extends ConsumerWidget {
  const AudienceAnalyticsCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analyticsAsync = ref.watch(userAnalyticsProvider);

    return analyticsAsync.when(
      data: (analytics) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights_rounded,
                size: 20.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                'Live Audience Analytics',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.6,
            children: [
              _buildMetricCard(
                title: 'Followers',
                value: _formatNumber(analytics.followers),
                icon: Icons.people_alt_outlined,
                color: const Color(0xFF3B82F6),
                isDark: isDark,
              ),
              _buildMetricCard(
                title: 'Impressions',
                value: _formatNumber(analytics.impressions),
                icon: Icons.remove_red_eye_outlined,
                color: const Color(0xFF10B981),
                isDark: isDark,
              ),
              _buildMetricCard(
                title: 'Total Reach',
                value: _formatNumber(analytics.reach),
                icon: Icons.cell_tower_rounded,
                color: const Color(0xFF8B5CF6),
                isDark: isDark,
              ),
              _buildMetricCard(
                title: 'Profile Views',
                value: _formatNumber(analytics.profileViews),
                icon: Icons.account_circle_outlined,
                color: const Color(0xFFF59E0B),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E232D) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : AppColors.shadow.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, size: 16.sp, color: color),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
