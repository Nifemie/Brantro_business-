import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/url_helper.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../influencer/logic/influencers_notifier.dart';
import '../influencer_card.dart';

class InfluencerSection extends ConsumerStatefulWidget {
  const InfluencerSection({super.key});

  @override
  ConsumerState<InfluencerSection> createState() => _InfluencerSectionState();
}

class _InfluencerSectionState extends ConsumerState<InfluencerSection> {
  @override
  void initState() {
    super.initState();
    // Fetch influencers on load
    Future.microtask(() {
      ref.read(influencersProvider.notifier).fetchInfluencers(page: 0, limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final influencersState = ref.watch(influencersProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Influencers',
                style: AppTexts.h4(color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/explore?category=Influencers');
                },
                child: Text(
                  'View All',
                  style: AppTexts.linkLarge(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        influencersState.isInitialLoading
            ? SkeletonHorizontalList(
                cardWidth: 320.w,
                cardHeight: 340.h,
                itemCount: 3,
                isProfileCard: true,
              )
            : SizedBox(
          height: 340.h,
          child: influencersState.message != null && !influencersState.isDataAvailable
              ? Center(
                  child: Text(
                    'Error loading influencers',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                )
              : (influencersState.data ?? []).isEmpty
              ? Center(
                  child: Text(
                    'No influencers available',
                    style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: PlatformResponsive.symmetric(horizontal: 16),
                  itemCount: (influencersState.data ?? []).length,
                  itemBuilder: (context, index) {
                    final influencer = (influencersState.data ?? [])[index];
                    final location = [
                      influencer.city,
                      influencer.state,
                      influencer.country,
                    ].where((e) => e != null && e.isNotEmpty).join(', ');

                    return Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: SizedBox(
                        width: 320.w,
                        child: InfluencerCard(
                          profileImage: influencer.avatarUrl ?? '',
                          name: influencer.additionalInfo?.displayName ?? influencer.name,
                          username: influencer.name.toLowerCase().replaceAll(' ', ''),
                          location: location.isEmpty ? 'Unknown' : location,
                          platform: influencer.additionalInfo?.primaryPlatform ?? 'Instagram',
                          rating: influencer.averageRating ?? 0.0,
                          likes: influencer.totalLikes ?? 0,
                          followers: int.tryParse(
                            influencer.additionalInfo?.audienceSizeRange?.split('-').first.trim() ?? '0'
                          ) ?? 0,
                          onPortfolioTap: () async {
                            await UrlHelper.openPortfolioLink(
                              context,
                              influencer.additionalInfo?.portfolioLink,
                            );
                          },
                          onViewSlotsTap: () {
                            context.push(
                              '/artist-ad-slots/${influencer.id}',
                              extra: {
                                'sellerName': influencer.name,
                                'sellerAvatar': influencer.avatarUrl,
                                'sellerType': 'Influencer',
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
