import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../logic/review_provider.dart';

class ReviewsBottomSheet extends ConsumerWidget {
  final double rating;
  final int reviewsCount;

  const ReviewsBottomSheet({
    super.key,
    required this.rating,
    required this.reviewsCount,
  });

  static void show(BuildContext context, {required double rating, required int reviewsCount}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReviewsBottomSheet(
        rating: rating,
        reviewsCount: reviewsCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reviewsAsync = ref.watch(userReviewsProvider);

    return Container(
      constraints: BoxConstraints(maxHeight: 0.85.sh),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E232B) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reviews & Ratings',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Rating summary banner
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF282F3A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating > 0 ? rating.toStringAsFixed(1) : '5.0',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star_rounded,
                          size: 18.sp,
                          color: const Color(0xFFF59E0B),
                        );
                      }),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$reviewsCount verified ${reviewsCount == 1 ? 'review' : 'reviews'}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        size: 14.sp,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '100% Authentic',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Reviews List
          Expanded(
            child: reviewsAsync.when(
              data: (reviews) {
                if (reviews.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.rate_review_outlined,
                            size: 56.sp,
                            color: isDark ? Colors.white24 : Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No customer reviews yet',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Reviews from your completed service orders, creatives, and billboard campaigns will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark ? Colors.white38 : Colors.grey[500],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 20.h,
                    color: isDark ? Colors.white10 : Colors.grey[200],
                  ),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundColor: AppColors.primaryColor.withOpacity(0.15),
                              backgroundImage: review.reviewerAvatar != null &&
                                      review.reviewerAvatar!.isNotEmpty
                                  ? NetworkImage(review.reviewerAvatar!)
                                  : null,
                              child: (review.reviewerAvatar == null ||
                                      review.reviewerAvatar!.isEmpty)
                                  ? Text(
                                      (review.reviewerName ?? 'C')[0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.reviewerName ?? 'Customer',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : AppColors.textPrimary,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(5, (sIdx) {
                                      final filled = sIdx < review.rating.floor();
                                      return Icon(
                                        filled ? Icons.star_rounded : Icons.star_outline_rounded,
                                        size: 14.sp,
                                        color: const Color(0xFFF59E0B),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            if (review.createdAt != null)
                              Text(
                                '${review.createdAt!.day}/${review.createdAt!.month}/${review.createdAt!.year}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark ? Colors.white38 : Colors.grey[400],
                                ),
                              ),
                          ],
                        ),
                        if (review.reviewText.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Text(
                            review.reviewText,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark ? Colors.white70 : Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: Text(
                  'Failed to load reviews',
                  style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[600]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
