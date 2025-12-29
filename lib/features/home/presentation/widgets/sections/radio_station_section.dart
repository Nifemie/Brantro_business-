import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../reusable_card.dart';

class RadioStationSection extends StatelessWidget {
  const RadioStationSection({super.key});

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
                'Available Radio Stations',
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
        SizedBox(
          height: 220.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: PlatformResponsive.symmetric(horizontal: 16),
            children: [
              ReusableCard(
                imageUrl: 'assets/promotions/billboard1.jpg',
                title: 'Radio Station 1',
                rating: 4.5,
                amount: 'Premium',
                onTap: () {},
              ),
              SizedBox(width: 12.w),
              ReusableCard(
                imageUrl: 'assets/promotions/billboard2.jpg',
                title: 'Radio Station 2',
                rating: 4.3,
                amount: 'Standard',
                onTap: () {},
              ),
              SizedBox(width: 12.w),
              ReusableCard(
                imageUrl: 'assets/promotions/billboard3.jpg',
                title: 'Radio Station 3',
                rating: 4.6,
                amount: 'Premium',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
