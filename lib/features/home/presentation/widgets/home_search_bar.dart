import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import 'cart_icon_widget.dart';

/// Home screen search bar with cart and profile icons
class HomeSearchBar extends StatelessWidget {
  final VoidCallback onCartTap;
  final VoidCallback onProfileTap;
  final LayerLink layerLink;

  const HomeSearchBar({
    super.key,
    required this.onCartTap,
    required this.onProfileTap,
    required this.layerLink,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/search'),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.grey[300] ?? Colors.grey,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 20.sp,
                    ),
                  ),
                  Text(
                    'Search ad slots & users',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        CartIconWidget(onTap: onCartTap),
        SizedBox(width: 12.w),
        _buildProfileIcon(),
      ],
    );
  }

  Widget _buildProfileIcon() {
    return CompositedTransformTarget(
      link: layerLink,
      child: GestureDetector(
        onTap: onProfileTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.grey[300] ?? Colors.grey,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 12.r,
                backgroundColor: AppColors.primaryColor,
                child: Icon(
                  Icons.person,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
