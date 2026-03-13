import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

class ProfileSharedPhotos extends StatelessWidget {
  final Color textColor;
  final Color subtextColor;
  final bool isDark;

  const ProfileSharedPhotos({
    super.key,
    required this.textColor,
    required this.subtextColor,
    required this.isDark,
  });

  static const List<String> _photoUrls = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200',
    'https://images.unsplash.com/photo-1509587584298-0f3b3a3a1797?w=200',
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=200',
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=200',
    'https://images.unsplash.com/photo-1497436072909-60f360e1d4b1?w=200',
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=200',
  ];

  @override
  Widget build(BuildContext context) {
    // Show first 3 images; the 3rd has the "+N" overlay
    const visibleCount = 3;
    final remaining = _photoUrls.length - visibleCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shared Photoes',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: subtextColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Photo grid
        Row(
          children: List.generate(visibleCount, (i) {
            final isLast = i == visibleCount - 1 && remaining > 0;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < visibleCount - 1 ? 8.w : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _photoUrls[i],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: isDark ? Colors.white12 : AppColors.grey300,
                            child: Icon(
                              Icons.image,
                              color:
                                  isDark ? Colors.white38 : AppColors.grey500,
                            ),
                          ),
                        ),
                        if (isLast)
                          Container(
                            color: Colors.black.withOpacity(0.55),
                            alignment: Alignment.center,
                            child: Text(
                              '+$remaining',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
