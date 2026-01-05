import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../billboard_card.dart';
import '../tv_station_card.dart';
import '../film_producer_card.dart';
import '../artist_profile_card.dart';

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
        // Products - Mixed Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Billboard Card
              SizedBox(
                width: 300.w,
                child: BillboardCard(
                  imageUrl: 'assets/promotions/billboard1.jpg',
                  category: 'Flash Deal',
                  location: 'Lekki, Lagos',
                  title: 'Premium Billboard',
                  subtitle: 'High-traffic location',
                  tags: const ['Prime', 'Limited Time'],
                  additionalInfo: 'Limited time offer - 40% off',
                  rating: 4.8,
                  ratedBy: '120 reviews',
                  price: '₦150,000',
                  priceUnit: 'per month',
                  likes: 156,
                  onLikeTap: () {},
                  onBookTap: () {},
                ),
              ),
              SizedBox(width: 16.w),
              // TV Station Card
              SizedBox(
                width: 320.w,
                child: TvStationCard(
                  stationName: 'Peak Time TV',
                  location: 'Lagos, Nigeria',
                  stationType: 'Satellite',
                  isFree: false,
                  isLive: true,
                  rating: 4.7,
                  favorites: 890,
                  yearsOnAir: 12,
                  categories: ['News', 'Business', 'Sports'],
                  broadcastArea: 'Nationwide',
                  onViewRates: () {},
                  onViewProfile: () {},
                ),
              ),
              SizedBox(width: 16.w),
              // Film Producer Card
              SizedBox(
                width: 280.w,
                child: FilmProducerCard(
                  profileImage: 'assets/promotions/billboard2.jpg',
                  name: 'Alex Productions',
                  location: 'Victoria Island, Lagos',
                  rating: 4.6,
                  likes: 123,
                  productions: 15,
                  onViewAdSlots: () {},
                ),
              ),
              SizedBox(width: 16.w),
              // Artist Profile Card
              SizedBox(
                width: 280.w,
                child: ArtistProfileCard(
                  profileImage: 'assets/promotions/billboard3.jpg',
                  name: 'Creative Studios',
                  location: 'Abuja, Nigeria',
                  tags: const ['Video Production', 'Advertising', 'Promo'],
                  rating: 4.9,
                  likes: 234,
                  works: 28,
                  isFavorite: false,
                  onFavoriteTap: () {},
                  onViewSlotsTap: () {},
                ),
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
