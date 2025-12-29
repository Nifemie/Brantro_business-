import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../reusable_card.dart';

class BillboardSection extends StatelessWidget {
  const BillboardSection({super.key});

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
                'Billboards',
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
                title: 'Billboard Space 1',
                rating: 4.8,
                amount: 'Rp 5.000.000',
                onTap: () {},
              ),
              SizedBox(width: 12.w),
              ReusableCard(
                imageUrl: 'assets/promotions/billboard2.jpg',
                title: 'Billboard Space 2',
                rating: 4.6,
                amount: 'Rp 4.500.000',
                onTap: () {},
              ),
              SizedBox(width: 12.w),
              ReusableCard(
                imageUrl: 'assets/promotions/billboard3.jpg',
                title: 'Billboard Space 3',
                rating: 4.7,
                amount: 'Rp 4.800.000',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
