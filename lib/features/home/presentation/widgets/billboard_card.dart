import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

/// Billboard/Screen profile card widget for explore section
class BillboardCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String location;
  final String title;
  final String subtitle;
  final List<String> tags;
  final String additionalInfo;
  final double rating;
  final String ratedBy;
  final String price;
  final String priceUnit;
  final int likes;
  final VoidCallback? onLikeTap;
  final VoidCallback? onBookTap;

  const BillboardCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.title,
    required this.subtitle,
    this.tags = const [],
    this.additionalInfo = '',
    this.rating = 0.0,
    this.ratedBy = '',
    this.price = '',
    this.priceUnit = 'per day',
    this.likes = 0,
    this.onLikeTap,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Billboard image with badges
          _buildImageSection(),
          
          // Content section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLocation(),
                SizedBox(height: 8.h),
                _buildTitle(),
                SizedBox(height: 6.h),
                _buildSubtitle(),
                SizedBox(height: 12.h),
                _buildTags(),
                if (additionalInfo.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  _buildAdditionalInfo(),
                ],
                SizedBox(height: 12.h),
                _buildRatingAndPrice(),
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
        // Billboard image
        Container(
          height: 200.h,
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
        
        // Category badge (top-left)
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              category,
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    likes.toString(),
                    style: AppTexts.bodySmall(
                      color: AppColors.textPrimary,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16.sp,
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

  Widget _buildTitle() {
    return Text(
      title,
      style: AppTexts.h3(
        color: AppColors.textPrimary,
      ).copyWith(fontWeight: FontWeight.w700),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      subtitle,
      style: AppTexts.bodySmall(
        color: AppColors.grey600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTags() {
    if (tags.isEmpty) return const SizedBox.shrink();
    
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: tags.map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E3F3), // Light purple background
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            tag,
            style: AppTexts.bodySmall(
              color: const Color(0xFF6B4FA0), // Purple text
            ).copyWith(fontWeight: FontWeight.w500),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdditionalInfo() {
    return Row(
      children: [
        Icon(
          Icons.stars_outlined,
          size: 14.sp,
          color: AppColors.warning,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            additionalInfo,
            style: AppTexts.bodySmall(
              color: AppColors.warning,
            ).copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Rating
        Row(
          children: [
            Icon(
              Icons.star,
              size: 16.sp,
              color: AppColors.warning,
            ),
            SizedBox(width: 4.w),
            Text(
              rating.toString(),
              style: AppTexts.bodyMedium(
                color: AppColors.textPrimary,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            if (ratedBy.isNotEmpty) ...[
              SizedBox(width: 4.w),
              Text(
                'by $ratedBy',
                style: AppTexts.bodySmall(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ],
        ),
        
        // Price
        if (price.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: AppTexts.h3(
                  color: AppColors.textPrimary,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                priceUnit,
                style: AppTexts.bodySmall(
                  color: AppColors.grey600,
                ),
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
        onPressed: onBookTap,
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
          'Book This Billboard',
          style: AppTexts.bodyLarge(
            color: Colors.white,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
