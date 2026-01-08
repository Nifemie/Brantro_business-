import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_texts.dart';

class AccountMenuSection extends StatelessWidget {
  const AccountMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'My Brantro Account',
              style: AppTexts.labelMedium(color: AppColors.grey600),
            ),
          ),
          _buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Orders',
            onTap: () {
              // TODO: Navigate to Orders
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.inbox_outlined,
            title: 'Inbox',
            onTap: () {
              // TODO: Navigate to Inbox
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.star_outline,
            title: 'Ratings & Reviews',
            onTap: () {
              // TODO: Navigate to Ratings & Reviews
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.local_offer_outlined,
            title: 'Vouchers',
            onTap: () {
              // TODO: Navigate to Vouchers
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.favorite_outline,
            title: 'Wishlist',
            onTap: () {
              // TODO: Navigate to Wishlist
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.store_outlined,
            title: 'Follow Artist',
            onTap: () {
              // TODO: Navigate to Follow Seller
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: AppColors.grey700, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: AppTexts.bodyMedium(color: AppColors.grey700),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.grey400, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.grey200,
      ),
    );
  }
}
