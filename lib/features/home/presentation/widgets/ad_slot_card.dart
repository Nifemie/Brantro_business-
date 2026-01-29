import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../controllers/re_useable/app_texts.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../cart/presentation/widgets/add_to_campaign_sheet.dart';

class AdSlotCard extends StatelessWidget {
  final String sellerName;
  final String sellerType;
  final String campaignTitle;
  final String category;
  final String subcategory;
  final List<String> features;
  final String location;
  final String reach;
  final String price;
  final String? sellerImage;
  final String? adSlotId;
  final VoidCallback onViewSlot;

  const AdSlotCard({
    super.key,
    required this.sellerName,
    required this.sellerType,
    required this.campaignTitle,
    required this.category,
    required this.subcategory,
    required this.features,
    required this.location,
    required this.reach,
    required this.price,
    this.sellerImage,
    this.adSlotId,
    required this.onViewSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seller info header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Seller avatar
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: sellerImage != null
                        ? NetworkImage(sellerImage!)
                        : null,
                    backgroundColor: AppColors.grey200,
                    child: sellerImage == null
                        ? Icon(
                            Icons.store,
                            color: AppColors.grey600,
                            size: 20.sp,
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sellerName,
                          style: AppTexts.h4(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          sellerType.toUpperCase(),
                          style: AppTexts.bodySmall(color: AppColors.grey600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Campaign title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                campaignTitle,
                style: AppTexts.h3(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: 12.h),

            // Category tags
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Wrap(
                spacing: 8.w,
                children: [
                  _buildTag(category, AppColors.secondaryColor),
                  _buildTag(subcategory, AppColors.grey600),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Features list
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  _buildFeatureItem(Icons.location_on_outlined, location),
                  SizedBox(height: 6.h),

                  // Features
                  ...features
                      .take(4)
                      .map(
                        (feature) => Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: _buildFeatureItem(
                            Icons.check_circle_outline,
                            feature,
                          ),
                        ),
                      ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Reach/Impressions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    size: 16.sp,
                    color: AppColors.secondaryColor,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    reach,
                    style: AppTexts.bodySmall(color: AppColors.secondaryColor),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(price, style: AppTexts.h2()),
            ),

            SizedBox(height: 16.h),

            // Action buttons
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Builder(
                builder: (context) => Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onViewSlot,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.secondaryColor,
                            width: 1.5,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'View Slot',
                          style: AppTexts.buttonSmall(
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Create cart item from ad slot data
                          final cartItem = CartItem.fromAdSlot({
                            'id': adSlotId ?? '',
                            'title': campaignTitle,
                            'description': features.join(', '),
                            'price': price,
                            'imageUrl': sellerImage,
                            'sellerName': sellerName,
                            'sellerType': sellerType,
                            'reach': reach,
                            'location': location,
                          });
                          
                          // Show add to campaign dialog
                          AddToCampaignSheet.show(context, cartItem);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text('Book Slot', style: AppTexts.buttonSmall()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(label, style: AppTexts.bodySmall(color: color)),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.grey600),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: AppTexts.bodySmall(color: AppColors.grey700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
