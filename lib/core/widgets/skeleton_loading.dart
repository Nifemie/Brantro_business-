import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Base shimmer widget that provides the shimmer effect
/// Used as a wrapper for skeleton loading placeholders
class ShimmerWrapper extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerWrapper({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: child,
    );
  }
}

/// Skeleton box - basic building block for skeleton loading
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(4.r),
      ),
    );
  }
}

/// Skeleton circle - for avatars and profile pictures
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Skeleton text line - for text placeholders
class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4.r),
    );
  }
}

/// Skeleton card - for card-based layouts (artist, influencer, etc.)
class SkeletonCard extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonCard({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            SkeletonBox(
              width: width,
              height: height * 0.6,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  SkeletonLine(width: width * 0.7, height: 14.h),
                  SizedBox(height: 8.h),
                  // Subtitle
                  SkeletonLine(width: width * 0.5, height: 12.h),
                  SizedBox(height: 8.h),
                  // Additional info
                  SkeletonLine(width: width * 0.4, height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton profile card - for user profile cards with avatar
class SkeletonProfileCard extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonProfileCard({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            SkeletonCircle(size: 60.w),
            SizedBox(height: 12.h),
            // Name
            SkeletonLine(width: width * 0.6, height: 14.h),
            SizedBox(height: 8.h),
            // Role/Category
            SkeletonLine(width: width * 0.4, height: 12.h),
            SizedBox(height: 12.h),
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SkeletonLine(width: width * 0.25, height: 10.h),
                SkeletonLine(width: width * 0.25, height: 10.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton list item - for list-based layouts
class SkeletonListItem extends StatelessWidget {
  final double? height;

  const SkeletonListItem({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        height: height ?? 80.h,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            // Avatar/Image
            SkeletonCircle(size: 50.w),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonLine(width: double.infinity, height: 14.h),
                  SizedBox(height: 8.h),
                  SkeletonLine(width: 200.w, height: 12.h),
                ],
              ),
            ),
            // Trailing icon/button
            SkeletonBox(width: 24.w, height: 24.h),
          ],
        ),
      ),
    );
  }
}

/// Skeleton horizontal list - for horizontal scrolling sections
class SkeletonHorizontalList extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final int itemCount;
  final bool isProfileCard;

  const SkeletonHorizontalList({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    this.itemCount = 3,
    this.isProfileCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (isProfileCard) {
            return SkeletonProfileCard(
              width: cardWidth,
              height: cardHeight,
            );
          }
          return SkeletonCard(
            width: cardWidth,
            height: cardHeight,
          );
        },
      ),
    );
  }
}

/// Skeleton grid - for grid-based layouts
class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const SkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.75,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return SkeletonBox(
            borderRadius: BorderRadius.circular(12.r),
          );
        },
      ),
    );
  }
}

/// Skeleton image - for image placeholders
class SkeletonImage extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonImage({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: SkeletonBox(
        width: width,
        height: height,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// Skeleton for campaign/ad slot cards with detailed structure
class SkeletonCampaignCard extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonCampaignCard({
    super.key,
    this.width = 340,
    this.height = 420,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Seller info header (avatar + name)
                Row(
                  children: [
                    SkeletonCircle(size: 40.w),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLine(width: 120.w, height: 14.h),
                          SizedBox(height: 4.h),
                          SkeletonLine(width: 80.w, height: 10.h),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12.h),
                
                // Campaign title (2 lines)
                SkeletonLine(width: double.infinity, height: 16.h),
                SizedBox(height: 4.h),
                SkeletonLine(width: 180.w, height: 16.h),
                
                SizedBox(height: 10.h),
                
                // Category tags
                Row(
                  children: [
                    SkeletonBox(width: 70.w, height: 20.h, borderRadius: BorderRadius.circular(4.r)),
                    SizedBox(width: 6.w),
                    SkeletonBox(width: 90.w, height: 20.h, borderRadius: BorderRadius.circular(4.r)),
                  ],
                ),
                
                SizedBox(height: 10.h),
                
                // Features list (3 items instead of 4)
                ...List.generate(3, (index) => Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Row(
                    children: [
                      SkeletonCircle(size: 14.w),
                      SizedBox(width: 6.w),
                      SkeletonLine(width: 150.w, height: 10.h),
                    ],
                  ),
                )),
                
                SizedBox(height: 10.h),
                
                // Reach/impressions
                Row(
                  children: [
                    SkeletonCircle(size: 14.w),
                    SizedBox(width: 6.w),
                    SkeletonLine(width: 100.w, height: 10.h),
                  ],
                ),
                
                SizedBox(height: 12.h),
                
                // Price
                SkeletonLine(width: 90.w, height: 20.h),
                
                SizedBox(height: 12.h),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: SkeletonBox(width: double.infinity, height: 40.h, borderRadius: BorderRadius.circular(8.r)),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SkeletonBox(width: double.infinity, height: 40.h, borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
