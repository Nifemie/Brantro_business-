import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// Digital screen card widget for home section
class DigitalScreenCard extends StatelessWidget {
  final String imageUrl;
  final String screenName;
  final String location;
  final String description;
  final List<String> features; // e.g., "12*6 meters LED display", "Digital LED Screen"
  final String specifications; // e.g., "4K LED, high brightness"
  final String priceStarting;
  final String priceUnit;
  final int likes;
  final String provider; // e.g., "by Branto Africa"
  final VoidCallback? onLikeTap;
  final VoidCallback? onBookScreen;

  const DigitalScreenCard({
    super.key,
    required this.imageUrl,
    required this.screenName,
    required this.location,
    this.description = '',
    this.features = const [],
    this.specifications = '',
    this.priceStarting = '',
    this.priceUnit = '/day',
    this.likes = 0,
    this.provider = '',
    this.onLikeTap,
    this.onBookScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screen image with badges
          _buildImageSection(),
          
          // Content section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScreenName(),
                SizedBox(height: 6.h),
                _buildLocation(),
                if (description.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _buildDescription(),
                ],
                SizedBox(height: 12.h),
                _buildFeatures(),
                if (specifications.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _buildSpecifications(),
                ],
                SizedBox(height: 16.h),
                _buildPriceAndProvider(),
                SizedBox(height: 16.h),
                _buildBookButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Screen image
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Digital Screen badge (top-left)
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF5B9BD5), // Blue color
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              'Digital Screen',
              style: AppTexts.bodySmall(
                color: Colors.white,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        
        // Like button (top-right)
        Positioned(
          top: 12.h,
          right: 12.w,
          child: GestureDetector(
            onTap: onLikeTap,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                likes > 0 ? Icons.favorite : Icons.favorite_border,
                color: likes > 0 ? Colors.red : AppColors.grey600,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScreenName() {
    return Text(
      screenName,
      style: AppTexts.h3(
        color: AppColors.textPrimary,
      ).copyWith(fontWeight: FontWeight.w700),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 14.sp,
          color: AppColors.grey600,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            location,
            style: AppTexts.bodySmall(
              color: AppColors.grey600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      description,
      style: AppTexts.bodySmall(
        color: AppColors.grey700,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFeatures() {
    if (features.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: features.map((feature) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F4F8), // Light blue background
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            feature,
            style: AppTexts.bodySmall(
              color: const Color(0xFF2E7D9A), // Blue text
            ).copyWith(fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpecifications() {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: 14.sp,
          color: AppColors.grey600,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            specifications,
            style: AppTexts.bodySmall(
              color: AppColors.grey600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndProvider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Provider
        if (provider.isNotEmpty)
          Row(
            children: [
              Icon(
                Icons.business,
                size: 14.sp,
                color: AppColors.grey600,
              ),
              SizedBox(width: 4.w),
              Text(
                provider,
                style: AppTexts.bodySmall(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        
        // Price
        if (priceStarting.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    'Starting from',
                    style: AppTexts.bodySmall(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
              Text(
                '$priceStarting$priceUnit',
                style: AppTexts.h4(
                  color: AppColors.textPrimary,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onBookScreen,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        child: Text(
          'Book This Screen',
          style: AppTexts.bodyLarge(
            color: Colors.white,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
