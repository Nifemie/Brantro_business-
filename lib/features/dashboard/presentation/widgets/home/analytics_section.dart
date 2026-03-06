import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/performance_chart.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/conversions_chart.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/top_pages_table.dart';

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        const PerformanceChart(),
        SizedBox(height: 20.h),
        const ConversionsChart(),
        SizedBox(height: 20.h),
      ],
    );
  }
}
