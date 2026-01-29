import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../home/presentation/widgets/artist_profile_card.dart';
import '../../../home/presentation/widgets/billboard_card.dart';
import '../../../home/presentation/widgets/designer_card.dart';
import '../../../home/presentation/widgets/digital_screen_card.dart';
import '../../../home/presentation/widgets/influencer_card.dart';
import '../../../home/presentation/widgets/media_house_card.dart';
import '../../../home/presentation/widgets/producer_card.dart';
import '../../../home/presentation/widgets/radio_station_card.dart';
import '../../../home/presentation/widgets/tv_station_card.dart';
import '../../../home/presentation/widgets/ugc_creator_card.dart';
import '../../../artist/logic/artists_notifier.dart';
import '../../../influencer/logic/influencers_notifier.dart';
import '../../../radio_station/logic/radio_stations_notifier.dart';
import '../../../tv_station/logic/tv_stations_notifier.dart';
import '../../../media_house/logic/media_houses_notifier.dart';
import '../../../creative/logic/creatives_notifier.dart';
import '../../../ugc_creator/logic/ugc_creators_notifier.dart';
import '../../../producer/logic/producers_notifier.dart';
import '../../../billboard/logic/billboards_notifier.dart';
import '../../../digital_screen/logic/digital_screens_notifier.dart';
import '../../../artist/data/models/artist_model.dart';
import '../../../influencer/data/models/influencer_model.dart';
import '../../../radio_station/data/models/radio_station_model.dart';
import '../../../tv_station/data/models/tv_station_model.dart';
import '../../../media_house/data/models/media_house_model.dart';
import '../../../creative/data/models/creative_model.dart';
import '../../../ugc_creator/data/models/ugc_creator_model.dart';
import '../../../producer/data/models/producer_model.dart';
import '../../../billboard/data/models/billboard_model.dart';
import '../../../digital_screen/data/models/digital_screen_model.dart';
import '../../logic/explore_controller.dart';
import 'category_profile_list.dart';

class TopProfilesSection extends ConsumerWidget {
  final String initialCategory;
  final VoidCallback? onSeeAll;
  final Widget? fallbackWidget;

  const TopProfilesSection({
    super.key,
    required this.initialCategory,
    this.onSeeAll,
    this.fallbackWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreState = ref.watch(exploreControllerProvider(initialCategory));
    final category = exploreState.category;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top ${_getCategoryDisplayName(category)} Profiles',
                style: AppTexts.h3(),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  'See All',
                  style: AppTexts.bodyMedium(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        _getProfilesWidget(category, ref),
      ],
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

  Widget _getProfilesWidget(String category, WidgetRef ref) {
    if (category.contains('influencer')) {
      final state = ref.watch(influencersProvider);
      return CategoryProfileList<InfluencerModel>(
        items: state.data ?? [],
        isLoading: state.isInitialLoading,
        errorMessage: state.isDataAvailable ? null : state.message,
        emptyMessage: 'No influencers available',
        itemBuilder: (context, influencer) {
          final location = [
            influencer.city,
            influencer.state,
            influencer.country,
          ].where((e) => e != null).join(', ');

          return InfluencerCard(
            profileImage: influencer.avatarUrl ?? 'assets/promotions/Davido1.jpg',
            name: influencer.additionalInfo?.displayName ?? influencer.name,
            username: '@${influencer.name.toLowerCase().replaceAll(' ', '_')}',
            location: location.isEmpty ? 'Unknown' : location,
            platform: influencer.additionalInfo?.primaryPlatform ?? 'Social Media',
            rating: influencer.averageRating ?? 0.0,
            likes: influencer.totalLikes ?? 0,
            followers: 0,
            onPortfolioTap: () async {
              await UrlHelper.openPortfolioLink(
                context,
                influencer.additionalInfo?.portfolioLink,
              );
            },
            onViewSlotsTap: () {},
          );
        },
      );
    } else if (category.contains('billboard')) {
      final state = ref.watch(billboardsProvider);
      return CategoryProfileList<BillboardModel>(
        items: state.data ?? [],
        isLoading: state.isInitialLoading,
        errorMessage: state.isDataAvailable ? null : state.message,
        emptyMessage: 'No billboards available',
        itemBuilder: (context, billboard) {
          final location = [
            billboard.city,
            billboard.state,
            billboard.country,
          ].where((e) => e.isNotEmpty).join(', ');

          final featuresList = billboard.features?.split(',').map((e) => e.trim()).toList() ?? [];

          return BillboardCard(
            imageUrl: billboard.thumbnail ?? 'assets/promotions/billboard1.jpg',
            category: billboard.category?.name ?? 'Billboard',
            location: location.isEmpty ? billboard.address : location,
            title: billboard.title,
            subtitle: billboard.description,
            tags: featuresList,
            additionalInfo: billboard.specifications ?? '',
            rating: billboard.averageRating,
            ratedBy: billboard.totalLikes > 0 ? '${billboard.totalLikes} likes' : '',
            price: '₦${billboard.baseRateAmount.toStringAsFixed(0)}',
            priceUnit: 'per ${billboard.baseRateUnit.toLowerCase()}',
            likes: billboard.totalLikes,
            onLikeTap: () {},
            onBookTap: () {
              context.push(
                '/seller-ad-slots/${billboard.ownerId}',
                extra: {
                  'sellerName': billboard.owner?.name ?? 'Billboard',
                  'sellerAvatar': billboard.owner?.avatarUrl,
                  'sellerType': 'Billboard',
                },
              );
            },
            onViewDetailsTap: () {
              context.push('/asset-details', extra: billboard);
            },
          );
        },
      );
    } else if (category.contains('digital') || category.contains('screen')) {
      final state = ref.watch(digitalScreensProvider);
      return CategoryProfileList<DigitalScreenModel>(
        items: state.data ?? [],
        isLoading: state.isInitialLoading,
        errorMessage: state.isDataAvailable ? null : state.message,
        emptyMessage: 'No digital screens available',
        itemBuilder: (context, screen) {
          final location = [
            screen.city,
            screen.state,
            screen.country,
          ].where((e) => e.isNotEmpty).join(', ');

          final featuresList = screen.features?.split(',').map((e) => e.trim()).toList() ?? [];

          return DigitalScreenCard(
            imageUrl: screen.thumbnail ?? 'assets/promotions/digital_screen1.jpg',
            screenName: screen.title,
            location: location.isEmpty ? screen.address : location,
            description: screen.description,
            features: featuresList,
            specifications: screen.specifications ?? '',
            priceStarting: '₦${screen.baseRateAmount.toStringAsFixed(0)}',
            priceUnit: '/${screen.baseRateUnit.toLowerCase()}',
            likes: screen.totalLikes,
            provider: screen.owner?.name ?? '',
            onLikeTap: () {},
            onBookScreen: () {
              context.push(
                '/seller-ad-slots/${screen.ownerId}',
                extra: {
                  'sellerName': screen.owner?.name ?? 'Digital Screen',
                  'sellerAvatar': screen.owner?.avatarUrl,
                  'sellerType': 'Digital Screen',
                },
              );
            },
            onViewDetailsTap: () {
              context.push('/asset-details', extra: screen);
            },
          );
        },
      );
    } else if (category.contains('artist')) {
      final state = ref.watch(artistsProvider);
      return CategoryProfileList<ArtistModel>(
        items: state.data ?? [],
        isLoading: state.isInitialLoading,
        errorMessage: state.isDataAvailable ? null : state.message,
        emptyMessage: 'No artists available',
        itemBuilder: (context, artist) {
          final location = [
            artist.city,
            artist.state,
            artist.country,
          ].where((e) => e != null).join(', ');

          return ArtistProfileCard(
            userId: artist.id,
            profileImage: artist.avatarUrl ?? 'assets/promotions/Davido1.jpg',
            name: artist.additionalInfo?.stageName ?? artist.name,
            location: location.isEmpty ? 'Unknown' : location,
            tags: artist.additionalInfo?.genres ?? [],
            rating: artist.averageRating,
            likes: artist.totalLikes ?? 0,
            works: artist.additionalInfo?.numberOfProductions ?? 0,
            isFavorite: false,
            onFavoriteTap: () {},
            onViewSlotsTap: () {},
          );
        },
      );
    } else if (category.contains('radio')) {
      final state = ref.watch(radioStationsProvider);
      return CategoryProfileList<RadioStationModel>(
        items: state.data ?? [],
        isLoading: state.isInitialLoading,
        errorMessage: state.isDataAvailable ? null : state.message,
        emptyMessage: 'No radio stations available',
        itemBuilder: (context, station) {
          final location = [
            station.city,
            station.state,
            station.country,
          ].where((e) => e != null).join(', ');

          return RadioStationCard(
            stationName: station.additionalInfo?.businessName ?? station.name,
            location: location.isEmpty ? 'Unknown' : location,
            stationType: station.additionalInfo?.broadcastBand ?? 'FM',
            rating: station.averageRating,
            favorites: station.totalLikes,
            yearsOnAir: station.additionalInfo?.yearsOfOperation ?? 0,
            categories: station.additionalInfo?.contentFocus ?? [],
            onBookAdSlot: () {
              context.push('/seller-ad-slots/${station.id}', extra: {
                'sellerName': station.additionalInfo?.businessName ?? station.name,
                'sellerAvatar': station.avatarUrl,
                'sellerType': 'Radio Station',
              });
            },
            onViewProfile: () {
              context.push('/view-profile', extra: {
                'userId': station.id,
                'name': station.additionalInfo?.businessName ?? station.name,
                'avatar': station.avatarUrl,
                'location': location,
                'about': 'Professional Radio Station available for verified advertising, partnerships, and brand collaborations on Brantro.',
                'genres': station.additionalInfo?.contentFocus ?? [],
                'experience': '${station.additionalInfo?.yearsOfOperation ?? 0} yrs',
                'projects': '0',
                'specialization': station.additionalInfo?.broadcastBand ?? 'FM',
                'profession': 'Radio Station',
                'rating': station.averageRating.toString(),
                'likes': station.totalLikes.toString(),
                'productions': '0',
                'socialMedia': {},
                'features': [
                  'Verified media partners',
                  'Transparent pricing',
                  'Campaign performance tracking',
                ],
              });
            },
          );
        },
      );
    } else if (category.contains('tv') || category.contains('television')) {
      final state = ref.watch(tvStationsProvider);
      return CategoryProfileList<TvStationModel>(
        items: state.data ?? [],
        isLoading: state.isInitialLoading,
        errorMessage: state.isDataAvailable ? null : state.message,
        emptyMessage: 'No TV stations available',
        itemBuilder: (context, station) {
          final location = [
            station.city,
            station.state,
            station.country,
          ].where((e) => e != null).join(', ');

          return TvStationCard(
            stationName: station.additionalInfo?.businessName ?? station.name,
            location: location.isEmpty ? 'Unknown' : location,
            stationType: station.additionalInfo?.broadcastType ?? 'Cable',
            isFree: station.additionalInfo?.channelType == 'Free',
            isLive: true,
            rating: station.averageRating,
            favorites: station.totalLikes,
            yearsOnAir: station.additionalInfo?.yearsOfOperation ?? 0,
            categories: station.additionalInfo?.contentFocus ?? [],
            broadcastArea: (station.additionalInfo?.operatingRegions ?? []).join(', '),
            onViewRates: () {
              context.push('/seller-ad-slots/${station.id}', extra: {
                'sellerName': station.additionalInfo?.businessName ?? station.name,
                'sellerAvatar': station.avatarUrl,
                'sellerType': 'TV Station',
              });
            },
            onViewProfile: () {
              context.push('/view-profile', extra: {
                'userId': station.id,
                'name': station.additionalInfo?.businessName ?? station.name,
                'avatar': station.avatarUrl,
                'location': location,
                'about': 'Professional TV Station available for verified advertising, partnerships, and brand collaborations on Brantro.',
                'genres': station.additionalInfo?.contentFocus ?? [],
                'experience': '${station.additionalInfo?.yearsOfOperation ?? 0} yrs',
                'projects': '0',
                'specialization': station.additionalInfo?.broadcastType ?? 'Cable',
                'profession': 'TV Station',
                'rating': station.averageRating.toString(),
                'likes': station.totalLikes.toString(),
                'productions': '0',
                'socialMedia': {},
                'features': [
                  'Verified media partners',
                  'Transparent pricing',
                  'Campaign performance tracking',
                ],
              });
            },
          );
        },
      );
    } else if (category.contains('media')) {
      final state = ref.watch(mediaHousesProvider);
      return CategoryProfileList<MediaHouseModel>(
        items: state.mediaHouses,
        isLoading: state.isLoading,
        errorMessage: state.error,
        emptyMessage: 'No media houses available',
        itemBuilder: (context, mediaHouse) {
          final location = [
            mediaHouse.city,
            mediaHouse.state,
            mediaHouse.country,
          ].where((e) => e != null).join(', ');

          return MediaHouseCard(
            mediaHouseName: mediaHouse.additionalInfo?.businessName ?? mediaHouse.name,
            location: location.isEmpty ? 'Unknown' : location,
            mediaTypes: mediaHouse.additionalInfo?.mediaTypes ?? [],
            rating: mediaHouse.averageRating,
            favorites: mediaHouse.totalLikes,
            yearsActive: mediaHouse.additionalInfo?.yearsOfOperation ?? 0,
            categories: mediaHouse.additionalInfo?.contentFocus ?? [],
            coverageArea: (mediaHouse.additionalInfo?.operatingRegions ?? []).join(', '),
            reach: '${(mediaHouse.additionalInfo?.estimatedMonthlyReach ?? 0) / 1000000}M /month',
            onPlatformTap: () {},
            onViewAdSlots: () {},
          );
        },
      );
    } else if (category.contains('designer') || category.contains('creative')) {
      final state = ref.watch(creativesProvider);
      return CategoryProfileList<CreativeModel>(
        items: state.data ?? [],
        isLoading: state.isInitialLoading,
        errorMessage: state.isDataAvailable ? null : state.message,
        emptyMessage: 'No designers available',
        itemBuilder: (context, creative) {
          final location = [
            creative.city,
            creative.state,
            creative.country,
          ].where((e) => e != null).join(', ');

          return DesignerCard(
            profileImage: creative.avatarUrl ?? 'assets/promotions/Davido1.jpg',
            name: creative.additionalInfo?.displayName ?? creative.name,
            location: location.isEmpty ? 'Unknown' : location,
            specialization: creative.additionalInfo?.specialization ?? '',
            yearsExperience: creative.additionalInfo?.yearsOfExperience ?? 0,
            likes: creative.totalLikes,
            followers: creative.additionalInfo?.numberOfProjects ?? 0,
            onViewPortfolio: () {},
            onViewServices: () {},
          );
        },
      );
    } else if (category.contains('ugc')) {
      final state = ref.watch(ugcCreatorsProvider);
      return CategoryProfileList<UgcCreatorModel>(
        items: state.data ?? [],
        isLoading: state.isInitialLoading,
        errorMessage: state.isDataAvailable ? null : state.message,
        emptyMessage: 'No UGC creators available',
        itemBuilder: (context, creator) {
          final location = [
            creator.city,
            creator.state,
            creator.country,
          ].where((e) => e != null).join(', ');

          return UgcCreatorCard(
            profileImage: creator.avatarUrl ?? 'assets/promotions/Davido1.jpg',
            name: creator.additionalInfo?.displayName ?? creator.name,
            location: location.isEmpty ? 'Unknown' : location,
            workType: creator.additionalInfo?.availabilityType ?? 'Campaign Based',
            categories: creator.additionalInfo?.niches ?? [],
            skills: creator.additionalInfo?.contentStyle ?? [],
            contentType: (creator.additionalInfo?.contentFormats ?? []).join(', '),
            rating: creator.averageRating,
            likes: creator.totalLikes,
            onViewServices: () {},
          );
        },
      );
    } else if (category.contains('film') || category.contains('producer')) {
      final state = ref.watch(producersProvider);
      return CategoryProfileList<ProducerModel>(
        items: state.data ?? [],
        isLoading: state.isInitialLoading,
        errorMessage: state.isDataAvailable ? null : state.message,
        emptyMessage: 'No producers available',
        itemBuilder: (context, producer) {
          final location = [
            producer.city,
            producer.state,
            producer.country,
          ].where((e) => e != null).join(', ');

          return ProducerCard(
            avatarUrl: producer.avatarUrl ?? 'assets/promotions/Davido1.jpg',
            name: producer.additionalInfo?.businessName ?? producer.name,
            location: location.isEmpty ? 'Unknown' : location,
            rating: producer.averageRating,
            likes: producer.totalLikes ?? 0,
            productions: producer.additionalInfo?.numberOfProductions ?? 0,
            onViewAdSlotsTap: () {},
          );
        },
      );
    } else {
      return fallbackWidget ?? const SizedBox.shrink();
    }
  }
}
