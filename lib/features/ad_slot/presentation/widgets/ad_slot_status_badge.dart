import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdSlotStatusBadge extends StatelessWidget {
  final String status;

  const AdSlotStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'available':
        badgeColor = const Color(0xFF00C853);
        statusText = 'Available';
        break;
      case 'booked':
        badgeColor = const Color(0xFFFF9800);
        statusText = 'Booked';
        break;
      case 'occupied':
        badgeColor = Colors.red;
        statusText = 'Occupied';
        break;
      default:
        badgeColor = Colors.grey;
        statusText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
