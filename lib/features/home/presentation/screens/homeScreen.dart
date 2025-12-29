import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../controllers/re_useable/bottom_nav_bar.dart';
import '../widgets/category_widget.dart';
import '../widgets/header_promo_widget.dart';
import '../widgets/reusable_card.dart';
import '../widgets/sections/flash_sale_section.dart';
import '../widgets/sections/billboard_section.dart';
import '../widgets/sections/artist_section.dart';
import '../widgets/sections/radio_station_section.dart';
import '../widgets/sections/tv_station_section.dart';
import '../widgets/sections/content_producer_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _currentPromoIndex = 0;
  final PageController _promoController = PageController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header and Promo Carousel
              const HeaderPromoWidget(),
              SizedBox(height: 16.h),
              // Coupon Banner
              _buildCouponBanner(),
              SizedBox(height: 24.h),
              // Categories
              const CategoryWidget(),
              SizedBox(height: 24.h),
              // Flash Sale Section
              const FlashSaleSection(),
              SizedBox(height: 24.h),
              // Billboard Section
              const BillboardSection(),
              SizedBox(height: 24.h),
              // TV Station Section
              const TvStationSection(),
              SizedBox(height: 24.h),
              // Radio Station Section
              const RadioStationSection(),
              SizedBox(height: 24.h),
              // Content Producer Section
              const ContentProducerSection(),
              SizedBox(height: 24.h),
              // Artist Section
              const ArtistSection(),
              SizedBox(height: 24.h), // Standard spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponBanner() {
    return Container(
      margin: PlatformResponsive.symmetric(horizontal: 16),
      padding: PlatformResponsive.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer_outlined, color: Colors.white, size: 18),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'There are 10 coupon waiting',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}
