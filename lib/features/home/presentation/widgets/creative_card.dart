import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class CreativeCard extends StatelessWidget {
  final String title;
  final String description;
  final String fileSize;
  final String dimensions;
  final List<String> formats;
  final int downloads;
  final double rating;
  final String price;
  final String? imageUrl;
  final List<String> tags;
  final VoidCallback? onViewDetails;
  final VoidCallback? onBuy;

  const CreativeCard({
    super.key,
    required this.title,
    required this.description,
    required this.fileSize,
    required this.dimensions,
    required this.formats,
    required this.downloads,
    required this.rating,
    required this.price,
    this.imageUrl,
    this.tags = const [],
    this.onViewDetails,
    this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Preview with Tags
          Stack(
            children: [
              Container(
                height: 200.h,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Center(
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                ),
              ),
              // Tags overlay
              if (tags.isNotEmpty)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tags.map((tag) => _buildTag(tag)).toList(),
                  ),
                ),
            ],
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: AppTexts.h4(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),

                // Description
                Text(
                  description,
                  style: AppTexts.bodySmall(color: AppColors.grey600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),

                // File Info
                Row(
                  children: [
                    Icon(Icons.insert_drive_file_outlined, size: 14.sp, color: AppColors.grey500),
                    SizedBox(width: 4.w),
                    Text(fileSize, style: AppTexts.labelSmall(color: AppColors.grey600)),
                    SizedBox(width: 12.w),
                    Icon(Icons.aspect_ratio, size: 14.sp, color: AppColors.grey500),
                    SizedBox(width: 4.w),
                    Text(dimensions, style: AppTexts.labelSmall(color: AppColors.grey600)),
                  ],
                ),
                SizedBox(height: 10.h),

                // Available Formats
                Text(
                  'Available formats',
                  style: AppTexts.labelSmall(color: AppColors.grey500),
                ),
                SizedBox(height: 6.h),
                Wrap(
                  spacing: 8.w,
                  children: formats.map((format) => _buildFormatChip(format)).toList(),
                ),
                SizedBox(height: 10.h),

                // Downloads and Rating
                Row(
                  children: [
                    Icon(Icons.download_outlined, size: 14.sp, color: AppColors.grey500),
                    SizedBox(width: 4.w),
                    Text(
                      '$downloads downloads',
                      style: AppTexts.labelSmall(color: AppColors.grey600),
                    ),
                    Spacer(),
                    Icon(Icons.star, size: 14.sp, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: AppTexts.labelSmall(color: AppColors.grey600),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Price
                Text(
                  price,
                  style: AppTexts.h3(color: const Color(0xFF003D82)),
                ),
                SizedBox(height: 12.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onViewDetails,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF6B35),
                          side: const BorderSide(color: Color(0xFFFF6B35)),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: AppTexts.buttonSmall(color: const Color(0xFFFF6B35)),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onBuy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003D82),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(
                          'Buy',
                          style: AppTexts.buttonSmall(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.grey100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 48.sp, color: AppColors.grey400),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF003D82),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'PORTRAIT',
              style: AppTexts.labelSmall(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF003D82),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        tag.toUpperCase(),
        style: AppTexts.labelSmall(color: Colors.white),
      ),
    );
  }

  Widget _buildFormatChip(String format) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Text(
        format.toUpperCase(),
        style: AppTexts.labelSmall(color: AppColors.grey700),
      ),
    );
  }
}
