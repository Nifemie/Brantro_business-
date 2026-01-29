import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../cart/presentation/widgets/add_to_campaign_sheet.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../data/models/creative_model.dart';
import '../../data/creative_repository.dart';
import '../../../../core/network/api_client.dart';

final _apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final creativeDetailProvider = FutureProvider.family<CreativeModel, int>((ref, id) async {
  final apiClient = ref.watch(_apiClientProvider);
  final repository = CreativeRepository(apiClient);
  return repository.getCreativeById(id);
});

class CreativeDetailScreen extends ConsumerWidget {
  final int creativeId;

  const CreativeDetailScreen({
    super.key,
    required this.creativeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creativeAsync = ref.watch(creativeDetailProvider(creativeId));

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: creativeAsync.when(
        data: (creative) => _buildContent(context, creative),
        loading: () => _buildLoading(),
        error: (error, stack) => _buildError(context, error.toString()),
      ),
    );
  }

  Widget _buildContent(BuildContext context, CreativeModel creative) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            _buildAppBar(context, creative),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(creative),
                  _buildDetailsSection(creative),
                  _buildSpecsSection(creative),
                  _buildOwnerSection(creative),
                  SizedBox(height: 120.h), // Increased padding for bottom bar
                ],
              ),
            ),
          ],
        ),
        _buildBottomBar(context, creative),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, CreativeModel creative) {
    return SliverAppBar(
      expandedHeight: 60.h,
      floating: true,
      pinned: true,
      backgroundColor: AppColors.primaryColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Creative Details',
        style: AppTexts.h3(color: Colors.white),
      ),
    );
  }

  Widget _buildImageSection(CreativeModel creative) {
    return Container(
      height: 400.h,
      width: double.infinity,
      color: AppColors.grey100,
      child: Stack(
        children: [
          if (creative.thumbnail != null && creative.thumbnail!.isNotEmpty)
            Image.network(
              creative.thumbnail!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
            )
          else
            _buildImagePlaceholder(),
          // Tags overlay
          Positioned(
            top: 16.h,
            left: 16.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTag(creative.type),
                SizedBox(height: 8.h),
                _buildTag(creative.format),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 64.sp, color: AppColors.grey400),
          SizedBox(height: 16.h),
          Text('No preview available', style: AppTexts.bodyMedium(color: AppColors.grey500)),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        tag.toUpperCase(),
        style: AppTexts.labelSmall(color: Colors.white),
      ),
    );
  }

  Widget _buildDetailsSection(CreativeModel creative) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(creative.title, style: AppTexts.h2()),
          SizedBox(height: 12.h),
          Text(
            creative.description,
            style: AppTexts.bodyMedium(color: AppColors.grey600),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Icon(Icons.download_outlined, size: 18.sp, color: AppColors.grey500),
              SizedBox(width: 6.w),
              Text(
                '${creative.downloads} downloads',
                style: AppTexts.bodySmall(color: AppColors.grey600),
              ),
              SizedBox(width: 20.w),
              Icon(Icons.star, size: 18.sp, color: Colors.amber),
              SizedBox(width: 6.w),
              Text(
                creative.averageRating.toStringAsFixed(1),
                style: AppTexts.bodySmall(color: AppColors.grey600),
              ),
              SizedBox(width: 20.w),
              Icon(Icons.favorite_border, size: 18.sp, color: AppColors.grey500),
              SizedBox(width: 6.w),
              Text(
                '${creative.totalLikes} likes',
                style: AppTexts.bodySmall(color: AppColors.grey600),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            creative.formattedPrice,
            style: AppTexts.h1(color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsSection(CreativeModel creative) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      color: Colors.white,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Specifications', style: AppTexts.h3()),
          SizedBox(height: 16.h),
          _buildSpecCard('File Size', creative.fileSizeFormatted, Icons.insert_drive_file_outlined),
          SizedBox(height: 12.h),
          _buildSpecCard('Dimensions', creative.dimensionsFormatted, Icons.aspect_ratio),
          SizedBox(height: 12.h),
          _buildSpecCard('Format', creative.format, Icons.image_outlined),
          SizedBox(height: 12.h),
          _buildSpecCard('Type', creative.type, Icons.category_outlined),
          SizedBox(height: 20.h),
          Text('Available Formats', style: AppTexts.h4()),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: creative.fileFormat.map((format) => _buildFormatChip(format)).toList(),
          ),
          if (creative.tagsList.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Text('Tags', style: AppTexts.h4()),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: creative.tagsList.map((tag) => _buildTagChip(tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 20.sp, color: AppColors.primaryColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTexts.labelSmall(color: AppColors.grey600)),
                SizedBox(height: 4.h),
                Text(value, style: AppTexts.bodyMedium(color: AppColors.grey900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTexts.bodyMedium(color: AppColors.grey600)),
          Text(value, style: AppTexts.bodyMedium(color: AppColors.grey900)),
        ],
      ),
    );
  }

  Widget _buildFormatChip(String format) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Text(
        format.toUpperCase(),
        style: AppTexts.labelSmall(color: AppColors.grey700),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        tag,
        style: AppTexts.labelSmall(color: AppColors.secondaryColor),
      ),
    );
  }

  Widget _buildOwnerSection(CreativeModel creative) {
    // Always show the section, even if owner is null
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      color: Colors.white,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Created By', style: AppTexts.h3()),
          SizedBox(height: 16.h),
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.primaryColor,
                backgroundImage: creative.owner?.avatarUrl != null
                    ? NetworkImage(creative.owner!.avatarUrl!)
                    : null,
                child: creative.owner?.avatarUrl == null
                    ? Text(
                        creative.owner?.name[0].toUpperCase() ?? 'B',
                        style: AppTexts.h3(color: Colors.white),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creative.owner?.name ?? 'Brantro Africa',
                      style: AppTexts.h4(),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Creative Owner',
                      style: AppTexts.bodySmall(color: AppColors.grey600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text('Creative Details', style: AppTexts.h3(color: Colors.white)),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ShimmerWrapper(
                  child: SkeletonBox(
                    width: double.infinity,
                    height: 400.h,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20.w),
                  child: ShimmerWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: 250.w, height: 28.h, borderRadius: BorderRadius.circular(8.r)),
                        SizedBox(height: 12.h),
                        SkeletonBox(width: double.infinity, height: 60.h, borderRadius: BorderRadius.circular(8.r)),
                        SizedBox(height: 20.h),
                        SkeletonBox(width: 200.w, height: 20.h, borderRadius: BorderRadius.circular(8.r)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Column(
      children: [
        AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text('Creative Details', style: AppTexts.h3(color: Colors.white)),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'Error Loading Creative',
                    style: AppTexts.h3(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    error,
                    style: AppTexts.bodyMedium(color: AppColors.grey600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                    ),
                    child: Text('Go Back', style: AppTexts.buttonMedium(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, CreativeModel creative) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Price', style: AppTexts.labelSmall(color: AppColors.grey600)),
                    SizedBox(height: 4.h),
                    Text(
                      creative.formattedPrice,
                      style: AppTexts.h3(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    final cartItem = CartItem(
                      id: creative.id.toString(),
                      type: 'creative',
                      title: creative.title,
                      description: creative.description,
                      price: creative.formattedPrice,
                      imageUrl: creative.thumbnail,
                      sellerName: creative.owner?.name ?? 'Brantro Africa',
                      sellerType: creative.type,
                      metadata: {
                        'fileSize': creative.fileSizeFormatted,
                        'dimensions': creative.dimensionsFormatted,
                        'formats': creative.fileFormat,
                        'downloads': creative.downloads,
                        'rating': creative.averageRating,
                        'tags': creative.tagsList,
                      },
                    );
                    AddToCampaignSheet.show(context, cartItem);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Buy Now',
                    style: AppTexts.buttonMedium(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
