import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../vetting/presentation/widgets/vetting_card.dart';
import '../../../../vetting/logic/vetting_notifier.dart';

class VettingServicesSection extends ConsumerStatefulWidget {
  const VettingServicesSection({super.key});

  @override
  ConsumerState<VettingServicesSection> createState() => _VettingServicesSectionState();
}

class _VettingServicesSectionState extends ConsumerState<VettingServicesSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(vettingProvider.notifier).fetchVettingOptions(page: 0, size: 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vettingState = ref.watch(vettingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vetting Services', style: AppTexts.h3()),
                  SizedBox(height: 4.h),
                  Text(
                    'Fast-track your campaign approvals',
                    style: AppTexts.bodySmall(color: AppColors.grey600),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.push('/vetting');
                },
                child: Text(
                  'See All',
                  style: AppTexts.bodyMedium(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Content based on state
        if (vettingState.isInitialLoading)
          _buildLoadingState()
        else if (vettingState.message != null && !vettingState.isDataAvailable)
          _buildErrorState(vettingState.message!, ref)
        else if ((vettingState.data ?? []).isEmpty)
          _buildEmptyState()
        else
          _buildVettingList(vettingState.data!),
      ],
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 420.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: SkeletonCard(width: 340.w, height: 420.h),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, WidgetRef ref) {
    return Container(
      height: 420.h,
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text('Failed to load vetting options', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => ref
                  .read(vettingProvider.notifier)
                  .fetchVettingOptions(page: 0, size: 20),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 420.h,
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_outlined,
              size: 48.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16.h),
            Text('No vetting options available', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              'Check back later for vetting services',
              style: AppTexts.bodySmall(color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVettingList(List vettingOptions) {
    return SizedBox(
      height: 420.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: vettingOptions.length,
        itemBuilder: (context, index) {
          final option = vettingOptions[index];
          return Container(
            width: 340.w,
            margin: EdgeInsets.only(right: 16.w),
            child: VettingCard(
              title: option.title,
              description: option.description,
              duration: option.durationDisplay,
              useCase: option.note,
              price: option.formattedPrice,
              status: option.status,
              onSelectTap: () {
                context.pushNamed(
                  'vetting-details',
                  pathParameters: {'vettingId': option.id.toString()},
                  extra: option,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
