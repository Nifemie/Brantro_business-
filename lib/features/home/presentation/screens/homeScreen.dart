import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../controllers/re_useable/bottom_nav_bar.dart';
import '../../../../features/artist/logic/artists_notifier.dart';
import '../widgets/category_widget.dart';
import '../widgets/header_promo_widget.dart';
import '../widgets/reusable_card.dart';
import '../widgets/sections/flash_sale_section.dart';
import '../widgets/sections/billboard_section.dart';
import '../widgets/sections/artist_section.dart';
import '../widgets/sections/radio_station_section.dart';
import '../widgets/sections/tv_station_section.dart';
import '../widgets/sections/content_producer_section.dart';
import '../widgets/sections/producer_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  int _currentPromoIndex = 0;
  final PageController _promoController = PageController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Refresh artists list
    await ref.read(artistsProvider.notifier).fetchArtists(page: 1, limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.grey[50],
        child: Stack(
          children: [
            // Scrollable content with blue header
            RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header and Promo Carousel (scrolls with content)
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
                    // Producer Section
                    const ProducerSection(),
                    SizedBox(height: 24.h),
                    // Artist Section
                    const ArtistSection(),
                    SizedBox(height: 24.h), // Standard spacing
                  ],
                ),
              ),
            ),
            // Fixed Search Bar Overlay at top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: _buildSearchBarOverlay(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBarOverlay() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/search'),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.grey[300] ?? Colors.grey,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 20.sp,
                    ),
                  ),
                  Text(
                    'Search Product',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Icon(Icons.mail_outline, color: Colors.white, size: 24.sp),
        SizedBox(width: 12.w),
        _buildNotificationIcon(),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: () => context.push('/notification'),
      child: Stack(
        children: [
          Icon(Icons.notifications_none, color: Colors.white, size: 24.sp),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Color(0xFFE57373),
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(minWidth: 12.w, minHeight: 12.h),
              child: Text(
                '8',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 7.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
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
