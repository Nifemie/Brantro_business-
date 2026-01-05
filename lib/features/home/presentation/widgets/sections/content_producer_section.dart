import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../film_producer_card.dart';

class ContentProducerSection extends StatelessWidget {
  const ContentProducerSection({super.key});

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
                'Content Producers',
                style: AppTexts.h4(color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: AppTexts.linkLarge(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 350.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: PlatformResponsive.symmetric(horizontal: 16),
            children: [
              SizedBox(
                width: 280.w,
                child: FilmProducerCard(
                  profileImage: 'assets/promotions/billboard1.jpg',
                  name: 'Murphy Franco',
                  location: 'Kebbi North, Nigeria',
                  rating: 4.8,
                  likes: 245,
                  productions: 18,
                  onViewAdSlots: () {},
                ),
              ),
              SizedBox(width: 16.w),
              SizedBox(
                width: 280.w,
                child: FilmProducerCard(
                  profileImage: 'assets/promotions/billboard2.jpg',
                  name: 'Sarah Johnson',
                  location: 'Lagos, Nigeria',
                  rating: 4.9,
                  likes: 512,
                  productions: 32,
                  onViewAdSlots: () {},
                ),
              ),
              SizedBox(width: 16.w),
              SizedBox(
                width: 280.w,
                child: FilmProducerCard(
                  profileImage: 'assets/promotions/billboard3.jpg',
                  name: 'David Chen',
                  location: 'Abuja, Nigeria',
                  rating: 4.7,
                  likes: 389,
                  productions: 25,
                  onViewAdSlots: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
