import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';
import 'package:brantro_business/features/account/logic/analytics_provider.dart';

class ConversionsChart extends ConsumerWidget {
  const ConversionsChart({super.key});

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final analytics = ref.watch(userAnalyticsProvider).value;

    final followers = analytics?.followers ?? 0;
    final reach = analytics?.reach ?? 0;
    final impressions = analytics?.impressions ?? 0;

    double conversionPercent = 65.2;
    if (impressions > 0 && reach > 0) {
      conversionPercent = ((reach / impressions) * 100).clamp(5.0, 99.0);
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Audience Conversions',
            style: AppTexts.h3(
              color: isDark ? Colors.white : AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            height: 200.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: 140,
                    sectionsSpace: 0,
                    centerSpaceRadius: 70.r,
                    sections: _buildDashedSections(isDark, conversionPercent),
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${conversionPercent.toStringAsFixed(1)}%',
                        style: AppTexts.displayMedium(
                          color: isDark
                              ? Colors.white
                              : AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Audience Reach Ratio',
                        style: AppTexts.labelMedium(
                          color: isDark
                              ? Colors.white70
                              : AppColors.primaryColor,
                        ).copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Followers', _formatNumber(followers)),
              _buildStatItem('Total Reach', _formatNumber(reach)),
              _buildStatItem('Impressions', _formatNumber(impressions)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Column(
          children: [
            Text(label, style: AppTexts.labelMedium(color: AppColors.grey500)),
            SizedBox(height: 8.h),
            Text(
              value,
              style: AppTexts.h2(
                color: isDark ? Colors.white : AppColors.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _buildDashedSections(bool isDark, double filledPercentage) {
    List<PieChartSectionData> sections = [];
    final double unfilledPercentage = 100.0 - filledPercentage;
    final double hiddenPercentage = 38.46;

    final double dashValue = 1.0;
    final double spaceValue = 1.2;

    double currentTotal = 0;

    while (currentTotal < filledPercentage) {
      double currentDash = (filledPercentage - currentTotal < dashValue)
          ? (filledPercentage - currentTotal)
          : dashValue;

      sections.add(
        PieChartSectionData(
          value: currentDash,
          color: AppColors.secondaryColor,
          radius: 25.w,
          showTitle: false,
        ),
      );
      currentTotal += currentDash;

      if (currentTotal < filledPercentage) {
        double currentSpace = (filledPercentage - currentTotal < spaceValue)
            ? (filledPercentage - currentTotal)
            : spaceValue;

        sections.add(
          PieChartSectionData(
            value: currentSpace,
            color: Colors.transparent,
            radius: 25.w,
            showTitle: false,
          ),
        );
        currentTotal += currentSpace;
      }
    }

    double gapBeforeUnfilled = 1.0;
    sections.add(
      PieChartSectionData(
        value: gapBeforeUnfilled,
        color: Colors.transparent,
        radius: 25.w,
        showTitle: false,
      ),
    );

    sections.add(
      PieChartSectionData(
        value: (unfilledPercentage - gapBeforeUnfilled).clamp(0.0, 100.0),
        color: isDark ? Colors.grey[700] : const Color(0xFFEFF1F5),
        radius: 25.w,
        showTitle: false,
      ),
    );

    sections.add(
      PieChartSectionData(
        value: hiddenPercentage,
        color: Colors.transparent,
        radius: 25.w,
        showTitle: false,
      ),
    );

    return sections;
  }
}
