import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../features/ad_slot/data/models/ad_placement_model.dart';
import '../../features/ad_slot/logic/ad_placement_provider.dart';

import '../widgets/ad_placement_details/placement_info_card.dart';
import '../widgets/ad_placement_details/campaign_proofs_card.dart';
import '../widgets/ad_placement_details/advertiser_info_card.dart';
import '../widgets/ad_placement_details/creative_attachments_card.dart';
import '../widgets/ad_placement_details/ad_slot_info_card.dart';
import '../widgets/ad_placement_details/placement_details_card.dart';

class AdPlacementDetailsScreen extends ConsumerWidget {
  final AdPlacementModel placement;

  const AdPlacementDetailsScreen({
    super.key,
    required this.placement,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(
              title: 'AD PLACEMENT DETAILS',
              showBackButton: true,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth > 800;

                  if (isWideScreen) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(adProofsProvider(placement.id));
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(24.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: _buildLeftColumn(isDark),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            flex: 4,
                            child: _buildRightColumn(context, isDark),
                          ),
                        ],
                      ),
                    ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(adProofsProvider(placement.id));
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                      children: [
                        _buildLeftColumn(isDark),
                        SizedBox(height: 16.h),
                        _buildRightColumn(context, isDark),
                      ],
                    ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlacementInfoCard(placement: placement, isDark: isDark),
        SizedBox(height: 24.h),
        CampaignProofsCard(placement: placement, isDark: isDark),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdvertiserInfoCard(placement: placement, isDark: isDark),
        SizedBox(height: 24.h),
        CreativeAttachmentsCard(placement: placement, isDark: isDark),
        SizedBox(height: 24.h),
        AdSlotInfoCard(placement: placement, isDark: isDark),
        SizedBox(height: 24.h),
        PlacementDetailsCard(placement: placement, isDark: isDark),
      ],
    );
  }
}
