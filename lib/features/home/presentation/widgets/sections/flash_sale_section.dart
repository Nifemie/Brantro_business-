import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../reusable_card.dart';

class FlashSaleSection extends StatelessWidget {
  const FlashSaleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Flash Sale',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Timer
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Flash sale end in ',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              _buildTimerBadge('02'),
              _buildTimerSeparator(),
              _buildTimerBadge('12'),
              _buildTimerSeparator(),
              _buildTimerBadge('24'),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Products
        SizedBox(
          height: 260.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: PlatformResponsive.symmetric(horizontal: 16),
            children: [
              ReusableCard(
                imageUrl: 'assets/promotions/billboard1.jpg',
                title: 'BARDI Smart IP',
                rating: 4.5,
                amount: 'Rp 299.000',
                discount: '35%',
                onTap: () {},
              ),
              SizedBox(width: 12.w),
              ReusableCard(
                imageUrl: 'assets/promotions/billboard2.jpg',
                title: 'TEROPONG MINI 30',
                rating: 4.5,
                amount: 'Rp 299.000',
                discount: '20%',
                onTap: () {},
              ),
              SizedBox(width: 12.w),
              ReusableCard(
                imageUrl: 'assets/promotions/billboard3.jpg',
                title: 'CAFELE Premium',
                rating: 4.5,
                amount: 'Rp 299.000',
                discount: '15%',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimerBadge(String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        time,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTimerSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }
}
