import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../producer/logic/producers_notifier.dart';
import '../producer_card.dart';

class ProducerSection extends ConsumerStatefulWidget {
  const ProducerSection({super.key});

  @override
  ConsumerState<ProducerSection> createState() => _ProducerSectionState();
}

class _ProducerSectionState extends ConsumerState<ProducerSection> {
  @override
  void initState() {
    super.initState();
    // Fetch producers on init (public endpoint - no auth required)
    Future.microtask(() {
      ref.read(producersProvider.notifier).fetchProducers(page: 1, limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final producersState = ref.watch(producersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: PlatformResponsive.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Film Producers',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {},
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
            if (producersState.isLoading)
              SizedBox(
                height: 320.h,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (producersState.error != null)
              SizedBox(
                height: 320.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 12.h),
                      Text(
                        'Error loading producers',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          producersState.error ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(producersProvider.notifier)
                              .fetchProducers(page: 1, limit: 10);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (producersState.producers.isEmpty)
              SizedBox(
                height: 320.h,
                child: Center(child: Text('No producers found')),
              )
            else
              SizedBox(
                height: 320.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: PlatformResponsive.symmetric(horizontal: 16),
                  children: producersState.producers.map((producer) {
                    return Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: ProducerCard(
                        avatarUrl:
                            producer.avatarUrl ?? 'assets/promotions/Davido1.jpg',
                        name: producer.additionalInfo?.businessName ?? producer.name,
                        location:
                            '${producer.city ?? ''}, ${producer.country ?? ''}',
                        rating: producer.averageRating ?? 0.0,
                        likes: producer.totalLikes ?? 0,
                        productions:
                            producer.additionalInfo?.numberOfProductions ?? 0,
                        onViewAdSlotsTap: () {},
                      ),
                    );
                  }).toList(),
                ),
              ),

        ],
      );
  }
}
