import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../data/models/billboard_model.dart';
import '../../../ad_slot/presentation/screens/seller_ad_slots_screen.dart';

class AssetDetailsScreen extends StatelessWidget {
  final dynamic asset;

  const AssetDetailsScreen({
    super.key,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    // Both BillboardModel and DigitalScreenModel have these identical fields
    final type = asset.type.toString().toUpperCase();
    final isDigital = type == 'DIGITAL_SCREEN' || type == 'SCREEN';
    final location = [
      asset.city,
      asset.state,
      asset.country,
    ].where((e) => e.isNotEmpty).join(', ');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, isDigital),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroImage(),
                _buildTitleSection(isDigital, location),
                _buildDescription(),
                _buildSpecifications(),
                _buildTechnicalSpecs(isDigital),
                _buildLocationSection(location),
                _buildOwnerSection(),
                SizedBox(height: 100.h), // Space for bottom action bar
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(context),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDigital) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => context.pop(),
      ),
      title: Text(
        '${isDigital ? 'Digital Screen' : 'Billboard'} Details',
        style: AppTexts.h4(color: AppColors.textPrimary),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    final thumbnailUrl = asset.thumbnailUrl; // Use the helper method
    final hasThumbnail = thumbnailUrl.isNotEmpty && !thumbnailUrl.contains('assets/');
    
    return Container(
      height: 250.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.grey200,
      ),
      child: hasThumbnail
          ? Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 64.sp,
                    color: AppColors.grey400,
                  ),
                );
              },
            )
          : Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 64.sp,
                color: AppColors.grey400,
              ),
            ),
    );
  }

  Widget _buildTitleSection(bool isDigital, String location) {
    return Container(
      padding: EdgeInsets.all(20.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: (isDigital ? Colors.cyan : Colors.blue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  isDigital ? 'DIGITAL SCREEN' : 'BILLBOARD',
                  style: AppTexts.labelSmall(
                    color: isDigital ? Colors.cyan : Colors.blue,
                  ),
                ),
              ),
              const Spacer(),
              _buildRating(),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            asset.title,
            style: AppTexts.h2(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.location_on, size: 16.sp, color: AppColors.grey600),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  location.isEmpty ? asset.address : location,
                  style: AppTexts.bodyMedium(color: AppColors.grey600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Icon(Icons.star, size: 18.sp, color: AppColors.warning),
        SizedBox(width: 4.w),
        Text(
          asset.averageRating.toStringAsFixed(1),
          style: AppTexts.bodyLarge(color: AppColors.textPrimary)
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 4.w),
        Text(
          '(${asset.totalLikes} likes)',
          style: AppTexts.bodySmall(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(20.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: AppTexts.h4()),
          SizedBox(height: 12.h),
          Text(
            asset.cleanDescription, // Use the helper method to strip HTML
            style: AppTexts.bodyMedium(color: AppColors.grey700),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications() {
    if (asset.features == null || asset.features!.isEmpty) return const SizedBox.shrink();
    
    final features = asset.features!.split(',').map((e) => e.trim()).toList();

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(20.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Features & Highlights', style: AppTexts.h4()),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: features.map((feature) => _buildFeatureItem(feature)).toList().cast<Widget>(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, size: 16.sp, color: AppColors.success),
        SizedBox(width: 8.w),
        Text(feature, style: AppTexts.bodyMedium(color: AppColors.grey700)),
      ],
    );
  }

  Widget _buildTechnicalSpecs(bool isDigital) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(20.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Technical Specifications', style: AppTexts.h4()),
          SizedBox(height: 16.h),
          _buildSpecRow('Type', asset.type),
          _buildSpecRow('Base Rate', '₦${asset.baseRateAmount.toStringAsFixed(0)} / ${asset.baseRateUnit}'),
          if (asset.specifications != null && asset.specifications!.isNotEmpty)
            _buildSpecRow('Technical Info', asset.specifications!),
          if (isDigital) ...[
            _buildSpecRow('Operating Hours', '24/7 (Interactive)'),
            _buildSpecRow('Resolution', '4K LED Optimized'),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: AppTexts.bodyMedium(color: AppColors.grey600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTexts.bodyMedium(color: AppColors.textPrimary)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(String location) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(20.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: AppTexts.h4()),
          SizedBox(height: 12.h),
          Text(asset.address, style: AppTexts.bodyMedium(color: AppColors.grey700)),
          SizedBox(height: 4.h),
          Text(location, style: AppTexts.bodySmall(color: AppColors.grey600)),
          SizedBox(height: 16.h),
          // Placeholder for Map View
          Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_outlined, size: 40.sp, color: AppColors.grey400),
                SizedBox(height: 8.h),
                Text('Map view coming soon', style: AppTexts.bodySmall(color: AppColors.grey500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerSection() {
    if (asset.owner == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(20.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Managed By', style: AppTexts.h4()),
          SizedBox(height: 16.h),
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundImage: asset.owner!.avatarUrl != null
                    ? NetworkImage(asset.owner!.avatarUrl!)
                    : null,
                backgroundColor: AppColors.grey200,
                child: asset.owner!.avatarUrl == null
                    ? Icon(Icons.business, color: AppColors.grey600)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.owner!.name,
                      style: AppTexts.bodyLarge(color: AppColors.textPrimary)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Trusted Branto Partner',
                      style: AppTexts.bodySmall(color: AppColors.grey600),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: Text('Contact', style: TextStyle(color: AppColors.primaryColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting from',
                    style: AppTexts.bodySmall(color: AppColors.grey600),
                  ),
                  Text(
                    asset.formattedPrice, // Use the helper method
                    style: AppTexts.h3(color: AppColors.textPrimary)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to specific slots for this asset
                  context.push(
                    '/seller-ad-slots/${asset.ownerId}',
                    extra: {
                      'sellerName': asset.owner?.name ?? '${asset.type.toString().replaceAll('_', ' ')} Partner',
                      'sellerAvatar': asset.owner?.avatarUrl,
                      'sellerType': asset.type,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  'View Available Slots',
                  style: AppTexts.buttonMedium(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
