import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../controllers/re_useable/bottom_nav_bar.dart';
import '../../../../../core/service/session_service.dart';
import '../../../../features/artist/logic/artists_notifier.dart';
import '../../../../features/billboard/logic/billboards_notifier.dart';
import '../../../../features/digital_screen/logic/digital_screens_notifier.dart';
import '../../../../features/tv_station/logic/tv_stations_notifier.dart';
import '../../../../features/radio_station/logic/radio_stations_notifier.dart';
import '../../../../features/producer/logic/producers_notifier.dart';
import '../../../../features/influencer/logic/influencers_notifier.dart';
import '../../../../features/Digital_services/logic/services_notifier.dart';
import '../../../../features/ugc_creator/logic/ugc_creators_notifier.dart';
import '../../../../features/cart/logic/cart_notifier.dart';
import '../../../../features/cart/presentation/widgets/cart_drawer.dart';
import '../widgets/category_widget.dart';
import '../widgets/header_promo_widget.dart';
import '../widgets/reusable_card.dart';
import '../widgets/sections/ugc_section.dart';
import '../widgets/sections/billboard_section.dart';
import '../widgets/sections/digital_screen_section.dart';
import '../widgets/sections/artist_section.dart';
import '../widgets/sections/radio_station_section.dart';
import '../widgets/sections/tv_station_section.dart';
import '../widgets/sections/content_producer_section.dart';
import '../widgets/sections/influencer_section.dart';
import '../widgets/sections/producer_section.dart';
import '../widgets/sections/featured_campaigns_section.dart';
import '../widgets/sections/digital_services_section.dart';
import '../widgets/sections/creatives_section.dart';
import 'package:brantro/features/ad_slot/logic/ad_slot_notifier.dart';
import '../../../../features/KYC/logic/kyc_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _currentPromoIndex = 0;
  final PageController _promoController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Refresh all sections
    await Future.wait<void>([
      // Featured Campaigns
      ref.read(adSlotProvider.notifier).loadAdSlots(refresh: true),
      // Digital Services
      ref.read(servicesProvider.notifier).fetchServices(page: 0, size: 10),
      // UGC Creators
      ref.read(ugcCreatorsProvider.notifier).fetchUgcCreators(page: 0, limit: 10),
      // Artists (page 1 is correct for artists)
      ref.read(artistsProvider.notifier).fetchArtists(page: 1, limit: 10),
      // Billboards
      ref.read(billboardsProvider.notifier).fetchBillboards(page: 0, size: 15),
      // Digital Screens
      ref.read(digitalScreensProvider.notifier).fetchDigitalScreens(page: 0, size: 15),
      // Influencers
      ref.read(influencersProvider.notifier).fetchInfluencers(page: 0, limit: 10),
      // TV Stations (page 0 to match initState)
      ref.read(tvStationsProvider.notifier).fetchTvStations(0, 10),
      // Radio Stations (page 0 to match initState)
      ref.read(radioStationsProvider.notifier).fetchRadioStations(0, 10),
      // Producers (page 1 is correct for producers)
      ref.read(producersProvider.notifier).fetchProducers(page: 1, limit: 10),
    ]);

    // Check if any provider has an error (network issues)
    final hasError = (ref.read(adSlotProvider).message != null && !ref.read(adSlotProvider).isDataAvailable) ||
        (ref.read(servicesProvider).message != null && !ref.read(servicesProvider).isDataAvailable) ||
        (ref.read(ugcCreatorsProvider).message != null && !ref.read(ugcCreatorsProvider).isDataAvailable) ||
        (ref.read(artistsProvider).message != null && !ref.read(artistsProvider).isDataAvailable) ||
        (ref.read(billboardsProvider).message != null && !ref.read(billboardsProvider).isDataAvailable) ||
        (ref.read(digitalScreensProvider).message != null && !ref.read(digitalScreensProvider).isDataAvailable) ||
        (ref.read(influencersProvider).message != null && !ref.read(influencersProvider).isDataAvailable) ||
        (ref.read(tvStationsProvider).message != null && !ref.read(tvStationsProvider).isDataAvailable) ||
        (ref.read(radioStationsProvider).message != null && !ref.read(radioStationsProvider).isDataAvailable) ||
        (ref.read(producersProvider).message != null && !ref.read(producersProvider).isDataAvailable);

    // Show snackbar if there's a network error
    if (hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'No internet connection. Please check your network.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers to determine connection/error state
    final adSlotState = ref.watch(adSlotProvider);
    final artistsState = ref.watch(artistsProvider);

    // Only hide if we are NOT loading AND we have NO data available AND there is an error message
    // This effectively hides sections when the initial/refresh fetch fails due to network
    final bool hideDynamicSections = (!adSlotState.isInitialLoading &&
            !adSlotState.isDataAvailable &&
            adSlotState.message != null) ||
        (!artistsState.isInitialLoading &&
            !artistsState.isDataAvailable &&
            artistsState.message != null);

    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[50],
        endDrawer: const CartDrawer(),
        drawerScrimColor: Colors.black54,
        drawerEdgeDragWidth: 0,
        body: Stack(
          children: [
            // Scrollable content with blue header
            RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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

                    // Dynamic sections - Only show if no critical network error
                    if (!hideDynamicSections) ...[
                      // Featured Campaigns
                      const FeaturedCampaignsSection(),
                      SizedBox(height: 24.h),
                      // Digital Services Section
                      const DigitalServicesSection(),
                      SizedBox(height: 24.h),
                      // Creatives Section
                      const CreativesSection(),
                      SizedBox(height: 24.h),
                      // UGC Creator Section
                      const UGCSection(),
                      SizedBox(height: 24.h),
                      // Billboard Section
                      const BillboardSection(),
                      SizedBox(height: 24.h),
                      // Digital Screen Section
                      const DigitalScreenSection(),
                      SizedBox(height: 24.h),
                      // Influencer Section
                      const InfluencerSection(),
                      SizedBox(height: 24.h),
                      // TV Station Section
                      const TvStationSection(),
                      SizedBox(height: 24.h),
                      // Radio Station Section
                      const RadioStationSection(),
                      SizedBox(height: 24.h),
                      // Producer Section
                      const ProducerSection(),
                      SizedBox(height: 24.h),
                      // Artist Section
                      const ArtistSection(),
                    ] else ...[
                      // Placeholder to ensure refresh indicator is easily accessible
                      SizedBox(
                        height: 400.h,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off,
                                  size: 48.sp, color: Colors.grey[400]),
                              SizedBox(height: 12.h),
                              Text(
                                'No internet connection',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Pull down to refresh',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 80.h), // Extra spacing for FAB
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
        // floatingActionButton: _buildCreateSlotFAB(),
      ),
    );
  }

  Widget _buildCreateSlotFAB() {
    return FutureBuilder(
      future: SessionService.getUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        
        final userJson = snapshot.data;
        if (userJson == null) return const SizedBox.shrink();
        
        // Check if user is a seller or super admin
        final userRole = userJson['role']?.toString().toUpperCase() ?? '';
        final isSuperAdmin = userRole == 'SUPER_ADMIN';
        // USER role is also an Advertiser/Buyer, so exclude it
        final isSeller = userRole != 'ADVERTISER' && userRole != 'USER' && userRole.isNotEmpty;
        
        // Show FAB for sellers and super admin (super admin has seller powers)
        if (!isSeller && !isSuperAdmin) return const SizedBox.shrink();
        
        return FloatingActionButton(
          onPressed: () async {
            // Check KYC status before allowing ad slot creation
            final kycStatus = await ref.read(kycProvider.notifier).getKycStatusString();
            
            if (context.mounted) {
              if (kycStatus == 'APPROVED') {
                context.push('/create-ad-slot');
              } else {
                context.push('/kyc');
              }
            }
          },
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.add, color: Colors.white, size: 28.sp),
        );
      },
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
                    'Search ad slots & users',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        _buildCartIcon(),
        SizedBox(width: 12.w),
        _buildNotificationIcon(),
      ],
    );
  }

  Widget _buildCartIcon() {
    final cartState = ref.watch(cartProvider);
    final itemCount = cartState.itemCount;

    return GestureDetector(
      onTap: () {
        _scaffoldKey.currentState?.openEndDrawer();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Pulsing effect when cart has items
          if (itemCount > 0)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseAnimation.value * 0.15),
                  child: Container(
                    width: 24.sp,
                    height: 24.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF6B35).withOpacity(0.3 * (1 - _pulseAnimation.value)),
                    ),
                  ),
                );
              },
            ),
          Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24.sp),
          if (itemCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B35),
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.h),
                child: Text(
                  itemCount > 9 ? '9+' : '$itemCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.sp,
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
