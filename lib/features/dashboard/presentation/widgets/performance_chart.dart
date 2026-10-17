import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';
import 'package:brantro_business/features/account/logic/analytics_provider.dart';

class PerformanceChart extends ConsumerStatefulWidget {
  const PerformanceChart({super.key});

  @override
  ConsumerState<PerformanceChart> createState() => _PerformanceChartState();
}

class _PerformanceChartState extends ConsumerState<PerformanceChart> {
  String selectedFilter = '1M';
  final List<String> filters = ['ALL', '1M', '6M', '1Y'];

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final analytics = ref.watch(userAnalyticsProvider).value;

    final impressions = analytics?.impressions ?? 0;
    final reach = analytics?.reach ?? 0;
    final profileViews = analytics?.profileViews ?? 0;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance',
                style: AppTexts.h3(
                  color: isDark ? Colors.white : AppColors.primaryColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: filters.map((filter) {
                  final isSelected = filter == selectedFilter;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 6.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? Colors.grey[800]
                                  : const Color(0xFFEFF1F5))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        filter,
                        style: isSelected
                            ? AppTexts.labelSmall(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.primaryColor,
                              ).copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                              )
                            : AppTexts.labelSmall(
                                color: AppColors.grey600,
                              ).copyWith(fontSize: 11.sp),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Live Quick Metrics Row directly above the chart
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withOpacity(0.25) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricSnippet('Impressions', _formatNumber(impressions), const Color(0xFFFF7A00), isDark),
                Container(height: 24.h, width: 1, color: isDark ? Colors.white12 : Colors.black12),
                _buildMetricSnippet('Reach', _formatNumber(reach), const Color(0xFF2ECA7F), isDark),
                Container(height: 24.h, width: 1, color: isDark ? Colors.white12 : Colors.black12),
                _buildMetricSnippet('Views', _formatNumber(profileViews), const Color(0xFF3B82F6), isDark),
              ],
            ),
          ),

          SizedBox(height: 24.h),
          SizedBox(height: 220.h, child: _buildChart(impressions, reach)),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(const Color(0xFFFF7A00), 'Impressions', isDark),
              SizedBox(width: 24.w),
              _buildLegendItem(const Color(0xFF2ECA7F), 'Reach', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricSnippet(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Container(width: 6.w, height: 6.w, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: isDark ? Colors.white60 : AppColors.grey600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text, bool isDark) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            color: isDark ? Colors.white60 : Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(int totalImpressions, int totalReach) {
    final hasData = totalImpressions > 0 || totalReach > 0;
    final maxVal = hasData
        ? ([totalImpressions, totalReach].reduce((a, b) => a > b ? a : b).toDouble() * 1.25).clamp(10.0, 10000000.0)
        : 10.0;

    final barGroups = hasData
        ? [
            _generateGroupData(0, totalImpressions * 0.05),
            _generateGroupData(1, totalImpressions * 0.08),
            _generateGroupData(2, totalImpressions * 0.06),
            _generateGroupData(3, totalImpressions * 0.10),
            _generateGroupData(4, totalImpressions * 0.07),
            _generateGroupData(5, totalImpressions * 0.09),
            _generateGroupData(6, totalImpressions * 0.06),
            _generateGroupData(7, totalImpressions * 0.08),
            _generateGroupData(8, totalImpressions * 0.12),
            _generateGroupData(9, totalImpressions * 0.09),
            _generateGroupData(10, totalImpressions * 0.10),
            _generateGroupData(11, totalImpressions * 0.10),
          ]
        : List.generate(12, (i) => _generateGroupData(i, 0.0));

    final lineSpots = hasData
        ? [
            FlSpot(0, totalReach * 0.04),
            FlSpot(1, totalReach * 0.07),
            FlSpot(2, totalReach * 0.05),
            FlSpot(3, totalReach * 0.09),
            FlSpot(4, totalReach * 0.08),
            FlSpot(5, totalReach * 0.06),
            FlSpot(6, totalReach * 0.04),
            FlSpot(7, totalReach * 0.07),
            FlSpot(8, totalReach * 0.11),
            FlSpot(9, totalReach * 0.14),
            FlSpot(10, totalReach * 0.12),
            FlSpot(11, totalReach * 0.13),
          ]
        : List.generate(12, (i) => FlSpot(i.toDouble(), 0.0));

    return Stack(
      children: [
        // Bar Chart (Impressions)
        BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            maxY: maxVal,
            minY: 0,
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const titles = [
                      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                    ];
                    if (value >= 0 && value < titles.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          titles[value.toInt()],
                          style: AppTexts.labelSmall(color: AppColors.grey500),
                        ),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    if (value % 20 == 0) {
                      return Text(
                        value.toInt().toString(),
                        style: AppTexts.labelSmall(color: AppColors.grey500),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 20,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
            ),
            borderData: FlBorderData(show: false),
            barGroups: barGroups,
          ),
        ),

        // Line Chart Overlay (Reach)
        LineChart(
          LineChartData(
            maxY: maxVal,
            minY: 0,
            titlesData: const FlTitlesData(show: false),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: lineSpots,
                isCurved: true,
                color: const Color(0xFF2ECA7F),
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2ECA7F).withOpacity(0.2),
                      const Color(0xFF2ECA7F).withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  BarChartGroupData _generateGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFFFF7A00),
          width: 8.w,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ],
    );
  }
}
