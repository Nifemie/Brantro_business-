import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/utils/platform_responsive.dart';
import '../widgets/vetting_card.dart';
import '../../logic/vetting_notifier.dart';

class VettingScreen extends ConsumerStatefulWidget {
  const VettingScreen({super.key});

  @override
  ConsumerState<VettingScreen> createState() => _VettingScreenState();
}

class _VettingScreenState extends ConsumerState<VettingScreen> {
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

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: Text(
          'Vetting Options',
          style: AppTexts.h3(color: Colors.white),
        ),
      ),
      body: vettingState.isInitialLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          : vettingState.message != null && !vettingState.isDataAvailable
              ? _buildErrorState(vettingState.message!)
              : (vettingState.data ?? []).isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: PlatformResponsive.all(16),
                      itemCount: vettingState.data!.length,
                      itemBuilder: (context, index) {
                        final option = vettingState.data![index];
                        return VettingCard(
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
                        );
                      },
                    ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
    );
  }
}
