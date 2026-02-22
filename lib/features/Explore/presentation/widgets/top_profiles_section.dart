import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../logic/explore_controller.dart';
import '../builders/artist_profile_builder.dart';
import '../builders/billboard_profile_builder.dart';
import '../builders/designer_profile_builder.dart';
import '../builders/digital_screen_profile_builder.dart';
import '../builders/influencer_profile_builder.dart';
import '../builders/media_house_profile_builder.dart';
import '../builders/producer_profile_builder.dart';
import '../builders/radio_station_profile_builder.dart';
import '../builders/tv_station_profile_builder.dart';
import '../builders/ugc_creator_profile_builder.dart';

class TopProfilesSection extends ConsumerWidget {
  final String initialCategory;
  final VoidCallback? onSeeAll;
  final Widget? fallbackWidget;
  final bool showSeeAll;

  const TopProfilesSection({
    super.key,
    required this.initialCategory,
    this.onSeeAll,
    this.fallbackWidget,
    this.showSeeAll = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreState = ref.watch(exploreControllerProvider(initialCategory));
    final category = exploreState.category;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        _buildHeader(category),
        SizedBox(height: 12.h),
        _getProfilesWidget(category, ref, context),
      ],
    );
  }

  Widget _buildHeader(String category) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Top ${_getCategoryDisplayName(category)} Profiles',
            style: AppTexts.h3(),
          ),
          if (showSeeAll)
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                'See All',
                style: AppTexts.bodyMedium(color: AppColors.primaryColor),
              ),
            ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    if (category.contains('influencer')) return 'Influencer';
    if (category.contains('artist')) return 'Artist';
    if (category.contains('radio')) return 'Radio Station';
    if (category.contains('tv')) return 'TV Station';
    if (category.contains('media')) return 'Media House';
    if (category.contains('billboard')) return 'Billboard';
    if (category.contains('digital') || category.contains('screen'))
      return 'Digital Screen';
    if (category.contains('designer') || category.contains('creative'))
      return 'Designer';
    if (category.contains('ugc')) return 'UGC Creator';
    if (category.contains('film') || category.contains('producer'))
      return 'Producer';
    return 'Seller';
  }

  Widget _getProfilesWidget(String category, WidgetRef ref, BuildContext context) {
    if (category.contains('influencer')) {
      return InfluencerProfileBuilder.build(ref, context);
    } else if (category.contains('billboard')) {
      return BillboardProfileBuilder.build(ref, context);
    } else if (category.contains('digital') || category.contains('screen')) {
      return DigitalScreenProfileBuilder.build(ref, context);
    } else if (category.contains('artist')) {
      return ArtistProfileBuilder.build(ref, context);
    } else if (category.contains('radio')) {
      return RadioStationProfileBuilder.build(ref, context);
    } else if (category.contains('tv') || category.contains('television')) {
      return TvStationProfileBuilder.build(ref, context);
    } else if (category.contains('media')) {
      return MediaHouseProfileBuilder.build(ref, context);
    } else if (category.contains('designer') || category.contains('creative')) {
      return DesignerProfileBuilder.build(ref, context);
    } else if (category.contains('ugc')) {
      return UgcCreatorProfileBuilder.build(ref, context);
    } else if (category.contains('film') || category.contains('producer')) {
      return ProducerProfileBuilder.build(ref, context);
    } else {
      return fallbackWidget ?? const SizedBox.shrink();
    }
  }
}
