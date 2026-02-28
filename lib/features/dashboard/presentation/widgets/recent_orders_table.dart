import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/recent_orders_header.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/recent_orders_list.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/recent_orders_pagination.dart';

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RecentOrdersHeader(),
          RecentOrdersList(),
          RecentOrdersPagination(),
        ],
      ),
    );
  }
}
