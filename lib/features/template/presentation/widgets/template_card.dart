import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class TemplateCard extends StatelessWidget {
  final String imageUrl;
  final String badge;
  final String title;
  final String description;
  final List<String> tags;
  final String price;
  final String? originalPrice; // For showing strikethrough price
  final String? discount; // Discount percentage (e.g., "-15.00% OFF")
  final String buttonText;
  final VoidCallback onTap;
  final bool isFree;

  const TemplateCard({
    super.key,
    required this.imageUrl,
    required this.badge,
    required this.title,
    required this.description,
    required this.tags,
    required this.price,
    this.originalPrice,
    this.discount,
    required this.buttonText,
    required this.onTap,
    this.isFree = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badges
          _buildImageSection(),
          
          // Content section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: AppTexts.h4(color: AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 8.h),
                
                // Description
                Text(
                  description,
                  style: AppTexts.bodySmall(color: AppColors.grey600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 12.h),
                
                // Tags
                _buildTags(),
                
                SizedBox(height: 16.h),
                
                // Price and Button
                _buildFooter(),
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
        // Image
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.grey200,
          ),
          child: imageUrl.startsWith('http')
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.grey200,
                    );
                  },
                )
              : Container(
                  color: AppColors.grey200,
                ),
        ),
        
        // Badge overlay (left)
        Positioned(
          top: 12.h,
          left: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              badge,
              style: AppTexts.labelSmall(color: Colors.white),
            ),
          ),
        ),
        
        // Discount badge (right) - only show if discount exists
        if (discount != null)
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                discount!,
                style: AppTexts.labelSmall(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.grey200,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48.sp,
          color: AppColors.grey400,
        ),
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: tags.map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            tag,
            style: AppTexts.bodySmall(color: AppColors.grey700),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Price section
        _buildPriceSection(),
        
        // Button
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isFree 
                ? const Color(0xFFFF6B35) // Orange for free items
                : const Color(0xFF003D82), // Dark blue for paid items
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          child: Text(
            buttonText,
            style: AppTexts.buttonSmall(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    if (isFree) {
      // Free items - just show "Free" in green
      return Text(
        price,
        style: AppTexts.h4(color: Colors.green),
      );
    } else {
      // Paid items - show current price and original price with strikethrough
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            price,
            style: AppTexts.h4(color: AppColors.textPrimary),
          ),
          if (originalPrice != null)
            Text(
              originalPrice!,
              style: AppTexts.bodySmall(color: AppColors.grey600).copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            ),
        ],
      );
    }
  }
}
