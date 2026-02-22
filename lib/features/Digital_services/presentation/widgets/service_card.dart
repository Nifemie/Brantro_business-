import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/presentation/widgets/add_to_campaign_sheet.dart';

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final VoidCallback onViewDetails;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image with badge
          _buildImageSection(),

          Divider(height: 1, color: AppColors.grey400),

          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Rating
                _buildRating(),
                SizedBox(height: 4.h),

                // Title
                Text(
                  service['title'] ?? 'Service Title',
                  style: AppTexts.h4(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),

                // Description
                Text(
                  service['description'] ?? 'Service description',
                  style: AppTexts.bodySmall(color: AppColors.grey600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),

                // Duration
                _buildDuration(),
                SizedBox(height: 6.h),

                // Tags
                _buildTags(),
                SizedBox(height: 8.h),

                // Price
                Text(
                  service['price'] ?? '₦0.00',
                  style: AppTexts.h3(),
                ),
                SizedBox(height: 3.h),

                // Provider
                Text(
                  'By ${service['provider'] ?? 'Brantro Africa'}',
                  style: AppTexts.bodySmall(color: AppColors.grey600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),

                // Action buttons
                _buildActionButtons(),
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
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: service['imageUrl'] != null && service['imageUrl'].toString().isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: Image.network(
                    service['imageUrl'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                  ),
                )
              : _buildPlaceholder(),
        ),

        // Badge
        if (service['badge'] != null)
          Positioned(
            top: 12.h,
            left: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                service['badge'].toString().toUpperCase(),
                style: AppTexts.labelSmall(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 48.sp,
        color: AppColors.grey400,
      ),
    );
  }

  Widget _buildRating() {
    final rating = service['rating'] ?? 0.0;
    final reviewCount = service['reviewCount'] ?? 0;

    return Row(
      children: [
        Text(
          rating.toStringAsFixed(1),
          style: AppTexts.bodyMedium(),
        ),
        SizedBox(width: 4.w),
        Icon(
          Icons.star,
          size: 16.sp,
          color: const Color(0xFFFFA726),
        ),
        SizedBox(width: 4.w),
        Text(
          '($reviewCount)',
          style: AppTexts.bodySmall(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildDuration() {
    return Row(
      children: [
        Icon(
          Icons.access_time_outlined,
          size: 16.sp,
          color: AppColors.grey600,
        ),
        SizedBox(width: 4.w),
        Text(
          service['duration'] ?? '6 days',
          style: AppTexts.bodySmall(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildTags() {
    final tags = service['tags'] as List<String>? ?? [];
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: tags.take(3).map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '#$tag',
            style: AppTexts.labelSmall(color: AppColors.grey700),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Builder(
      builder: (context) => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onViewDetails,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.secondaryColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'View Details',
                style: AppTexts.buttonSmall(color: AppColors.secondaryColor),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Show add to campaign dialog
                final cartItem = CartItem.fromService(service);
                AddToCampaignSheet.show(context, cartItem);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'Order Service',
                style: AppTexts.buttonSmall(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
