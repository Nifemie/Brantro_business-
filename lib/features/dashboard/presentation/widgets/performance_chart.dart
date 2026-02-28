import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';

class PerformanceChart extends StatefulWidget {
  const PerformanceChart({super.key});

  @override
  State<PerformanceChart> createState() => _PerformanceChartState();
}

class _PerformanceChartState extends State<PerformanceChart> {
  String selectedFilter = '1M';
  final List<String> filters = ['ALL', '1M', '6M', '1Y'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
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
                style: AppTexts.h3(color: AppColors.primaryColor),
              ),
              Expanded(
                child: Row(
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
                              ? (isDark ? Colors.grey[800] : const Color(0xFFEFF1F5))
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
                                  color: AppColors.primaryColor,
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
              ),
            ],
          ),
          SizedBox(height: 30.h),
          SizedBox(height: 250.h, child: _buildChart()),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.orange, 'Page Views'),
              SizedBox(width: 24.w),
              _buildLegendItem(Colors.green, 'Clicks'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
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
          style: TextStyle(fontSize: 14.sp, color: Colors.blueGrey),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return Stack(
      children: [
        // Bar Chart (Page Views)
        BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            maxY: 80,
            minY: 0,
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const titles = [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec',
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
            barGroups: [
              _generateGroupData(0, 34),
              _generateGroupData(1, 65),
              _generateGroupData(2, 46),
              _generateGroupData(3, 68),
              _generateGroupData(4, 49),
              _generateGroupData(5, 61),
              _generateGroupData(6, 42),
              _generateGroupData(7, 44),
              _generateGroupData(8, 78),
              _generateGroupData(9, 52),
              _generateGroupData(10, 63),
              _generateGroupData(11, 67),
            ],
          ),
        ),

        // Line Chart Overlay (Clicks)
        LineChart(
          LineChartData(
            maxY: 80,
            minY: 0,
            titlesData: FlTitlesData(show: false),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 8),
                  FlSpot(1, 13),
                  FlSpot(2, 7),
                  FlSpot(3, 18),
                  FlSpot(4, 22),
                  FlSpot(5, 11),
                  FlSpot(6, 5),
                  FlSpot(7, 10),
                  FlSpot(8, 7),
                  FlSpot(9, 29),
                  FlSpot(10, 12),
                  FlSpot(11, 35),
                ],
                isCurved: true,
                color: const Color(0xFF2ECA7F), // Green
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
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
          color: AppColors.secondaryColor,
          width: 8.w,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ],
    );
  }
}
