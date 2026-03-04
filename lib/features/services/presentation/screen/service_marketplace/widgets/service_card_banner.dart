import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceCardBanner extends StatelessWidget {
  final String imageUrl;
  final String category;
  final bool isDark;

  const ServiceCardBanner({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
          child: Image.asset(
            imageUrl,
            width: double.infinity,
            height: 180.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 180.h,
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                  size: 40.sp,
                ),
              ),
            ),
          ),
        ),
        // Category Badge overlay
        Positioned(
          top: 16.h,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(
                0xFF003D82,
              ).withOpacity(0.9), // Dark Blue badge
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
