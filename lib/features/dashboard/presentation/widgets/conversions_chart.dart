import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/controllers/re_useable/app_texts.dart';

class ConversionsChart extends StatelessWidget {
  const ConversionsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
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
            'Conversions',
            style: AppTexts.h3(color: AppColors.primaryColor),
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
                    sections: _buildDashedSections(),
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '65.2%',
                        style: AppTexts.displayMedium(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Returning Customer',
                        style: AppTexts.labelMedium(
                          color: AppColors.primaryColor,
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
              _buildStatItem('This Week', '23.5k'),
              _buildStatItem('Last Week', '41.05k'),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: TextButton(
              onPressed: () {
                // TODO: Navigate to conversions details
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEFF1F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'View Details',
                style: AppTexts.buttonMedium(color: AppColors.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTexts.labelMedium(color: AppColors.grey500)),
        SizedBox(height: 8.h),
        Text(value, style: AppTexts.h2(color: AppColors.primaryColor)),
      ],
    );
  }

  List<PieChartSectionData> _buildDashedSections() {
    List<PieChartSectionData> sections = [];
    final double filledPercentage = 65.2;
    final double unfilledPercentage = 34.8;

    // The chart is a partial circle (approx 260 degrees).
    // Sum of visible parts = 100.
    // Hidden part to make 100 units = 260 degrees is 38.46 units.
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
        value: unfilledPercentage - gapBeforeUnfilled,
        color: const Color(0xFFEFF1F5),
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
