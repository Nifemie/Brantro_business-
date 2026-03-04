import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillboardCardImage extends StatelessWidget {
  final String imageAsset;
  final bool isDark;

  const BillboardCardImage({
    super.key,
    required this.imageAsset,
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
            imageAsset,
            width: double.infinity,
            height: 200.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200.h,
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                  size: 48.sp,
                ),
              ),
            ),
          ),
        ),
        // "BILLBOARD" badge in top-right
        Positioned(
          top: 16.h,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF003D82), // Dark Blue
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              'BILLBOARD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
