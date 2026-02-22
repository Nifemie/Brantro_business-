import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../core/utils/avatar_helper.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../artist/logic/artists_notifier.dart';
import '../artist_profile_card.dart';

class ArtistSection extends ConsumerStatefulWidget {
  const ArtistSection({super.key});

  @override
  ConsumerState<ArtistSection> createState() => _ArtistSectionState();
}

class _ArtistSectionState extends ConsumerState<ArtistSection> {
  @override
  Widget build(BuildContext context) {
    final artistsState = ref.watch(artistsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Artists',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/explore?category=Artists');
                },
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
        artistsState.when(
          loading: () => SkeletonHorizontalList(
            cardWidth: 320.w,
            cardHeight: 380.h,
            itemCount: 3,
            isProfileCard: true,
          ),
          error: (error, _) => SizedBox(
            height: 380.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 12.h),
                  Text(
                    'Error loading artists',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(artistsProvider.notifier)
                          .fetchArtists(page: 1, limit: 10);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (state) {
            final artists = state.data ?? [];

            if (artists.isEmpty) {
              return SizedBox(
                height: 380.h,
                child: Center(child: Text('No artists found')),
              );
            }

            return SizedBox(
              height: 380.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: PlatformResponsive.symmetric(horizontal: 16),
                children: artists.map((artist) {
                  return Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: SizedBox(
                      width: 320.w,
                      child: ArtistProfileCard(
                        userId: artist.id,
                        profileImage: AvatarHelper.getAvatar(
                          avatarUrl: artist.avatarUrl,
                          userId: artist.id,
                        ),
                        name: artist.additionalInfo?.stageName ?? artist.name,
                        location:
                            '${artist.city ?? ''}, ${artist.country ?? ''}',
                        tags: artist.additionalInfo?.genres ?? [],
                        rating: artist.averageRating ?? 0.0,
                        likes: artist.totalLikes ?? 0,
                        works: artist.additionalInfo?.numberOfProductions ?? 0,
                        isFavorite: false,
                        onFavoriteTap: () {},
                        onViewSlotsTap: () {},
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
