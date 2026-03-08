import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../dashboard/presentation/widgets/dashboard_app_bar.dart';

class AddressBookScreen extends StatelessWidget {
  const AddressBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E2329)
          : AppColors.backgroundSecondary,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'ADDRESS BOOK', showBackButton: true),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                children: [
                  _buildAddressCard(
                    context,
                    label: 'BUSINESS HQ',
                    address:
                        'Plot 12, Admiralty Way, Lekki Phase 1, Lagos, Nigeria',
                    category: 'OFFICE',
                    isPrimary: true,
                  ),
                  SizedBox(height: 16.h),
                  _buildAddressCard(
                    context,
                    label: 'BILLBOARD SITE 01',
                    address: 'KM 14, Ikorodu Road, Ketu, Lagos State',
                    category: 'SITE',
                  ),
                  SizedBox(height: 16.h),
                  _buildAddressCard(
                    context,
                    label: 'WAREHOUSE',
                    address:
                        'Warehouse B3, Industrial Estate, Ogba, Ikeja, Lagos',
                    category: 'STORAGE',
                  ),
                  SizedBox(height: 32.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.primaryColor
                          : Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 54.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'ADD NEW ADDRESS',
                      style: AppTexts.buttonLarge().copyWith(letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context, {
    required String label,
    required String address,
    required String category,
    bool isPrimary = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2F36) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isPrimary
            ? Border.all(color: AppColors.primaryColor, width: 1.5)
            : null,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: AppTexts.labelMedium(
                      color: isDark ? Colors.white70 : AppColors.grey600,
                    ).copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                  ),
                  if (isPrimary) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'PRIMARY',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 20.sp,
                  color: AppColors.grey500,
                ),
                itemBuilder: (ctx) => [
                  const PopupMenuItem(child: Text('Edit')),
                  const PopupMenuItem(child: Text('Set as Primary')),
                  const PopupMenuItem(
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            address,
            style: AppTexts.bodyMedium(
              color: isDark ? Colors.white : AppColors.textPrimary,
            ).copyWith(height: 1.4),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.grey100,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.grey600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
