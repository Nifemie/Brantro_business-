import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../billboard_card.dart';

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
          height: 500.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: PlatformResponsive.symmetric(horizontal: 16),
            children: [
              SizedBox(
                width: 300.w,
                child: BillboardCard(
                  imageUrl: 'assets/promotions/billboard1.jpg',
                  category: 'Prime Location',
                  location: 'Lekki, Lagos',
                  title: 'High-Traffic Billboard',
                  subtitle: 'Perfect for brand visibility',
                  tags: const ['Prime', 'High Traffic', 'Day & Night'],
                  additionalInfo: '50,000+ daily impressions',
                  rating: 4.8,
                  ratedBy: '245 reviews',
                  price: '₦250,000',
                  priceUnit: 'per month',
                  likes: 324,
                  onLikeTap: () {},
                  onBookTap: () {},
                ),
              ),
              SizedBox(width: 16.w),
              SizedBox(
                width: 300.w,
                child: BillboardCard(
                  imageUrl: 'assets/promotions/billboard2.jpg',
                  category: 'Business Area',
                  location: 'Victoria Island, Lagos',
                  title: 'Corporate District Billboard',
                  subtitle: 'B2B audience targeting',
                  tags: const ['Corporate', 'CBD', 'High Visibility'],
                  additionalInfo: '75,000+ daily impressions',
                  rating: 4.6,
                  ratedBy: '189 reviews',
                  price: '₦300,000',
                  priceUnit: 'per month',
                  likes: 287,
                  onLikeTap: () {},
                  onBookTap: () {},
                ),
              ),
              SizedBox(width: 16.w),
              SizedBox(
                width: 300.w,
                child: BillboardCard(
                  imageUrl: 'assets/promotions/billboard3.jpg',
                  category: 'Highway',
                  location: 'Ikorodu Road, Lagos',
                  title: 'Expressway Billboard',
                  subtitle: 'Maximum reach and coverage',
                  tags: const ['Highway', 'High Speed Traffic', '24/7'],
                  additionalInfo: '100,000+ daily impressions',
                  rating: 4.7,
                  ratedBy: '312 reviews',
                  price: '₦350,000',
                  priceUnit: 'per month',
                  likes: 451,
                  onLikeTap: () {},
                  onBookTap: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
