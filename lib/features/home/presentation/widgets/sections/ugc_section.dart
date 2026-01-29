import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../ugc_creator/logic/ugc_creators_notifier.dart';
import '../ugc_creator_card.dart';

class UGCSection extends ConsumerStatefulWidget {
  const UGCSection({super.key});

  @override
  ConsumerState<UGCSection> createState() => _UGCSectionState();
}

class _UGCSectionState extends ConsumerState<UGCSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ugcCreatorsProvider.notifier).fetchUgcCreators(page: 0, limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ugcState = ref.watch(ugcCreatorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'UGC Creators',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/explore?category=UGC\\nCreator');
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
        if (ugcState.isInitialLoading)
          SkeletonHorizontalList(
            cardWidth: 300.w,
            cardHeight: 400.h,
            itemCount: 3,
          )
        else if (ugcState.message != null && !ugcState.isDataAvailable)
          SizedBox(
            height: 400.h,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 12.h),
                  Text(
                    'Error loading UGC creators',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      ugcState.message ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(ugcCreatorsProvider.notifier)
                          .fetchUgcCreators(page: 0, limit: 10);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else if ((ugcState.data ?? []).isEmpty)
          SizedBox(
            height: 400.h,
            child: Center(child: Text('No UGC creators found')),
          )
        else
          SizedBox(
            height: 400.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: PlatformResponsive.symmetric(horizontal: 16),
              children: (ugcState.data ?? []).map((creator) {
                final location = [
                  creator.city,
                  creator.state,
                  creator.country,
                ].where((e) => e != null && e.isNotEmpty).join(', ');

                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: UgcCreatorCard(
                    profileImage: creator.avatarUrl ?? '',
                    name: creator.name,
                    location: location.isEmpty ? 'Unknown' : location,
                    workType: creator.additionalInfo?.availabilityType ?? '',
                    categories: creator.additionalInfo?.niches ?? [],
                    skills: creator.additionalInfo?.contentStyle ?? [],
                    contentType: creator.additionalInfo?.contentFormats?.join(', ') ?? '',
                    rating: creator.averageRating,
                    likes: creator.totalLikes,
                    onViewServices: () {
                      context.push(
                        '/seller-ad-slots/${creator.id}',
                        extra: {
                          'sellerName': creator.name,
                          'sellerAvatar': creator.avatarUrl,
                          'sellerType': 'UGC Creator',
                        },
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
