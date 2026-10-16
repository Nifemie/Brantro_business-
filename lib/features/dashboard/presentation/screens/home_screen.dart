import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/wallet_balance_card.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/quick_actions_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/analytics_filter_tabs.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/analytics_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_orders_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_billboards_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_screens_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_walls_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_vehicles_section.dart';
import 'package:brantro_business/features/dashboard/presentation/widgets/home/recent_ad_slots_section.dart';
import 'package:brantro_business/features/account/logic/profile_provider.dart';
import 'package:brantro_business/features/account/logic/persona_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(profileHeaderProvider).value;
    final activePersona = ref.watch(activePersonaProvider);

    bool isInfluencer;
    bool isCreator;
    bool isHost;

    if (activePersona == null) {
      // Unified view of all active roles
      isInfluencer = profileData?.isInfluencer ?? true;
      isCreator = profileData?.isCreator ?? false;
      isHost = profileData?.isHost ?? false;
    } else {
      // Focused view based on selected persona
      final p = activePersona.toUpperCase();
      isInfluencer = ['INFLUENCER', 'ARTIST', 'PRODUCER', 'TV_STATION', 'RADIO_STATION', 'UGC_CREATOR', 'MEDIA_HOUSE'].contains(p);
      isCreator = ['CREATOR', 'CREATIVE', 'DESIGNER'].contains(p);
      isHost = p == 'HOST';
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(profileHeaderProvider);
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WalletBalanceCard(),
            SizedBox(height: 24.h),
            const QuickActionsSection(),
            SizedBox(height: 24.h),
            const AnalyticsFilterTabs(),
            const AnalyticsSection(),
            SizedBox(height: 24.h),
            // Show recent orders for Influencers, Creators, Designers
            if (isInfluencer || isCreator) ...[
              const RecentOrdersSection(),
              SizedBox(height: 24.h),
            ],
            // Show Host inventory for Host persona or when explicitly having Host role
            if (isHost || (!isInfluencer && !isCreator)) ...[
              const RecentBillboardsSection(),
              SizedBox(height: 24.h),
              const RecentScreensSection(),
              SizedBox(height: 24.h),
              const RecentWallsSection(),
              SizedBox(height: 24.h),
              const RecentVehiclesSection(),
              SizedBox(height: 24.h),
              const RecentAdSlotsSection(),
            ],
            SizedBox(height: 80.h), // Extra padding for bottom nav
          ],
        ),
      ),
    );
  }
}
