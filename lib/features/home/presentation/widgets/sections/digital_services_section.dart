import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../../../core/widgets/skeleton_loading.dart';
import '../../../../Digital_services/presentation/widgets/service_card.dart';
import '../../../../Digital_services/logic/services_notifier.dart';
import '../../../../Explore/logic/explore_controller.dart';

class DigitalServicesSection extends ConsumerStatefulWidget {
  final String? initialCategory;
  const DigitalServicesSection({super.key, this.initialCategory});

  @override
  ConsumerState<DigitalServicesSection> createState() =>
      _DigitalServicesSectionState();
}

class _DigitalServicesSectionState
    extends ConsumerState<DigitalServicesSection> {
  @override
  Widget build(BuildContext context) {
    final servicesState = ref.watch(servicesProvider);
    final servicesData = servicesState.asData?.value;
    var services = servicesData?.data ?? [];

    // Apply filters and sorting if in explore mode
    if (widget.initialCategory != null) {
      final exploreState = ref.watch(
        exploreControllerProvider(widget.initialCategory!),
      );
      final filters = exploreState.filters;
      final selectedSort = exploreState.selectedSort;

      // 1. Filter by category/role if applicable
      if (filters['category'] != null || filters['role'] != null) {
        final filterValue = (filters['category'] ?? filters['role'])
            .toString()
            .toUpperCase();
        services = services.where((s) {
          final type = s.type.toUpperCase();
          // Match if type contains the filter value or vice versa
          return type.contains(filterValue) || filterValue.contains(type);
        }).toList();
      }

      // 2. Sorting
      if (selectedSort == 'Price: Low to High') {
        services = List.from(services)
          ..sort(
            (a, b) => (double.tryParse(a.price) ?? 0).compareTo(
              double.tryParse(b.price) ?? 0,
            ),
          );
      } else if (selectedSort == 'Price: High to Low') {
        services = List.from(services)
          ..sort(
            (a, b) => (double.tryParse(b.price) ?? 0).compareTo(
              double.tryParse(a.price) ?? 0,
            ),
          );
      } else if (selectedSort == 'Rating') {
        services = List.from(services)
          ..sort((a, b) => b.averageRating.compareTo(a.averageRating));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Digital Services', style: AppTexts.h3()),
              TextButton(
                onPressed: () {
                  context.push('/services');
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
        servicesState.when(
          loading: _buildLoadingState,
          error: (error, _) => _buildErrorState(error.toString(), ref),
          data: (state) {
            if (services.isEmpty) {
              return _buildEmptyState();
            }

            return _buildServicesList(services);
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return SkeletonHorizontalList(
      cardWidth: 320.w,
      cardHeight: 480.h,
      itemCount: 3,
    );
  }

  Widget _buildErrorState(String error, WidgetRef ref) {
    return Container(
      height: 480.h,
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text('Failed to load services', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => ref
                  .read(servicesProvider.notifier)
                  .fetchServices(page: 0, size: 10),
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
      height: 480.h,
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.design_services_outlined,
              size: 48.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16.h),
            Text('Services are not available for now', style: AppTexts.h4()),
            SizedBox(height: 8.h),
            Text(
              'Check back later for new services',
              style: AppTexts.bodySmall(color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList(List services) {
    return SizedBox(
      height: 480.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: ServiceCard(
              service: {
                'id': service.id,
                'imageUrl': service.thumbnailUrl,
                'badge': service.typeBadge,
                'rating': service.averageRating,
                'reviewCount': service.totalLikes,
                'title': service.title,
                'description': service.description.replaceAll(
                  RegExp(r'<[^>]*>'),
                  '',
                ), // Strip HTML tags
                'duration': '${service.deliveryDays} days',
                'tags': service.tags,
                'price': service.formattedPrice,
                'provider': service.createdBy?.name ?? 'Brantro Africa',
              },
              onViewDetails: () {
                // Pass ID and optional initial data for smooth transition
                context.push('/service-details/${service.id}', extra: service);
              },
            ),
          );
        },
      ),
    );
  }
}
