import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/network/api_client.dart';

class CreativeCard extends StatelessWidget {
  final String bannerImage;
  final String title;
  final double rating;
  final int favorites;
  final double price;
  final double discount;
  final int ordersCount;
  final bool isActive;
  final VoidCallback onViewDetails;
  final VoidCallback onViewOrders;
  final VoidCallback? onMenuTap;

  const CreativeCard({
    super.key,
    required this.bannerImage,
    required this.title,
    required this.rating,
    required this.favorites,
    required this.price,
    required this.discount,
    required this.ordersCount,
    this.isActive = true,
    required this.onViewDetails,
    required this.onViewOrders,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final imageUrl = bannerImage.isNotEmpty
        ? (bannerImage.startsWith('http')
            ? bannerImage
            : (bannerImage.startsWith('assets/')
                ? bannerImage
                : '${ApiClient.fileBaseUrl}/$bannerImage'))
        : '';
    final isNetwork = imageUrl.startsWith('http');

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image with Active Badge
          GestureDetector(
            onTap: onViewDetails,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: imageUrl.isNotEmpty
                      ? (isNetwork
                          ? Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 180.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(isDark),
                            )
                          : Image.asset(
                              imageUrl,
                              width: double.infinity,
                              height: 180.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(isDark),
                            ))
                      : _buildPlaceholder(isDark),
                ),
                if (isActive)
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF003D82),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                GestureDetector(
                  onTap: onViewDetails,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: 8.h),

                // Rating & Favorite count Row
                Row(
                  children: [
                    // Stars
                    ...List.generate(5, (index) {
                      final starRating = rating;
                      IconData icon = Icons.star_border;
                      if (starRating >= index + 1) {
                        icon = Icons.star;
                      } else if (starRating > index) {
                        icon = Icons.star_half;
                      }
                      return Icon(
                        icon,
                        size: 20.sp,
                        color: Colors.grey[400],
                      );
                    }),
                    SizedBox(width: 8.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.favorite,
                      size: 16.sp,
                      color: const Color(0xFFE57373),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      favorites.toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Price Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    if (discount > 0) ...[
                      Text(
                        NumberFormat.currency(symbol: '₦', decimalDigits: 0).format(price - discount),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0D1B2A),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        NumberFormat.currency(symbol: '₦', decimalDigits: 0).format(price),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE57373),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ] else ...[
                      Text(
                        NumberFormat.currency(symbol: '₦', decimalDigits: 0).format(price),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0D1B2A),
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 16.h),

                // Action Buttons Row
                Row(
                  children: [
                    // Menu Button
                    GestureDetector(
                      onTap: onMenuTap,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : const Color(0xFFFFF5F5),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isDark ? Colors.grey[700]! : const Color(0xFFFFE5E5),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.more_horiz,
                            color: isDark ? Colors.white70 : const Color(0xFFFF6B6B),
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // View Orders Button
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: onViewOrders,
                              icon: Icon(
                                Icons.shopping_bag_outlined,
                                size: 20.sp,
                              ),
                              label: Text(
                                'View Orders',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003D82),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                          // Order Badge
                          Positioned(
                            top: -4.h,
                            right: -4.w,
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B6B),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                ordersCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.3),
            AppColors.secondaryColor.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48.sp,
          color: isDark ? Colors.white38 : Colors.grey[400],
        ),
      ),
    );
  }
}
