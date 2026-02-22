import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../features/artist/logic/artists_notifier.dart';
import '../../../../features/cart/presentation/widgets/cart_drawer.dart';
import '../widgets/category_widget.dart';
import '../widgets/header_promo_widget.dart';
import '../widgets/sections/ugc_section.dart';
import '../widgets/sections/billboard_section.dart';
import '../widgets/sections/digital_screen_section.dart';
import '../widgets/sections/artist_section.dart';
import '../widgets/sections/radio_station_section.dart';
import '../widgets/sections/tv_station_section.dart';
import '../widgets/sections/influencer_section.dart';
import '../widgets/sections/producer_section.dart';
import '../widgets/sections/featured_campaigns_section.dart';
import '../widgets/sections/digital_services_section.dart';
import '../widgets/sections/creatives_section.dart';
import '../../logic/home_refresh_handler.dart';
import '../../logic/profile_badge_manager.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/profile_menu_overlay.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    
    // Preload badge counts for profile menu
    Future.microtask(() {
      final badgeManager = ProfileBadgeManager(ref);
      badgeManager.preloadBadgeCounts();
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleProfileMenu() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showProfileMenu();
    }
  }

  void _showProfileMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              right: 16.w,
              top: 60.h,
              child: Material(
                color: Colors.transparent,
                child: ProfileMenuOverlay(onClose: _removeOverlay),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    final refreshHandler = HomeRefreshHandler(ref);
    await refreshHandler.refreshAllSections();

    // Show snackbar if there's a network error
    if (refreshHandler.hasNetworkError() && mounted) {
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
    final artistsAsync = ref.watch(artistsProvider);
    final artistsHasError = artistsAsync.hasError;
    final bool hideDynamicSections = artistsHasError;

    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[50],
        endDrawer: const CartDrawer(),
        drawerScrimColor: Colors.black54,
        drawerEdgeDragWidth: 0,
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header and Promo Carousel (scrolls with content)
                const HeaderPromoWidget(),
                SizedBox(height: 16.h),
                
                // Search Bar with Cart and Profile icons (scrolls with content)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: HomeSearchBar(
                    onCartTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                    onProfileTap: _toggleProfileMenu,
                    layerLink: _layerLink,
                  ),
                ),
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
                          Icon(
                            Icons.wifi_off,
                            size: 48.sp,
                            color: Colors.grey[400],
                          ),
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
                SizedBox(height: 80.h), // Extra spacing for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }
}
