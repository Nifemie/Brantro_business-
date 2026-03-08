import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/skeleton_loading.dart';

class WalletSkeleton extends StatelessWidget {
  const WalletSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Card Skeleton
          ShimmerWrapper(
            child: SkeletonBox(
              width: double.infinity,
              height: 180.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          SizedBox(height: 24.h),

          // Quick Actions Skeleton
          SkeletonLine(width: 120.w, height: 20.h),
          SizedBox(height: 12.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.3,
            children: List.generate(
              2,
              (index) => ShimmerWrapper(
                child: SkeletonBox(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // Transactions Title Skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLine(width: 150.w, height: 20.h),
              SkeletonLine(width: 60.w, height: 16.h),
            ],
          ),
          SizedBox(height: 12.h),

          // Transactions List Skeleton
          Column(
            children: List.generate(5, (index) => const SkeletonListItem()),
          ),
        ],
      ),
    );
  }
}
