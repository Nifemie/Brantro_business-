import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/network/api_client.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../data/models/vehicle_model.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback onViewSlots;
  final VoidCallback? onMenuTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onViewSlots,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final image = vehicle.thumbnail;
    final bool isNetwork = image.isNotEmpty && (image.startsWith('http') || image.startsWith('https') || (image.contains('.') && !image.startsWith('assets/')));
    final String imageUrl = isNetwork && !image.startsWith('http') && !image.startsWith('https')
        ? '${ApiClient.fileBaseUrl}/$image'
        : image;

    return GestureDetector(
      onTap: () {
        context.push('/vehicle-details', extra: {'vehicle': vehicle});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? (isDark ? Colors.grey[900]! : Colors.white),
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
            // Vehicle Image with Active Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: isNetwork
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
                        ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003D82),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'VEHICLE',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
  
            // Content Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Active State Chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          vehicle.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: vehicle.isActive ? const Color(0xFFE6F7F0) : const Color(0xFFFDE8E8),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          vehicle.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: vehicle.isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ],
                  ),
  
                  SizedBox(height: 8.h),
  
                  // Location / Address
                  Text(
                    vehicle.address,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white60 : Colors.grey[500],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
  
                  // Estimated Reach Badge
                  if (vehicle.estimatedReach != null) ...[
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFECE5),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_pin_outlined,
                            size: 14.sp,
                            color: const Color(0xFFFF6B35),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Reach: ${NumberFormat('#,###').format(vehicle.estimatedReach)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF6B35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
  
                  // Ratings and Likes
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      ...List.generate(5, (index) => Icon(
                        Icons.star_outline,
                        size: 18.sp,
                        color: isDark ? Colors.white38 : Colors.grey[400],
                      )),
                      SizedBox(width: 6.w),
                      Text(
                        '${vehicle.averageRating ?? 0.0}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.favorite_border,
                        size: 16.sp,
                        color: const Color(0xFFEF4444),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${vehicle.totalLikes ?? 0}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
  
                  // Price Section
                  SizedBox(height: 12.h),
                  RichText(
                    text: TextSpan(
                      text: '₦${NumberFormat('#,###').format(vehicle.price)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      children: [
                        TextSpan(
                          text: ' / day',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
  
                  SizedBox(height: 16.h),
  
                  // Action Buttons Row
                  Row(
                    children: [
                      // Menu Button
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[850] : const Color(0xFFFFF5F5),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isDark ? Colors.grey[700]! : const Color(0xFFFFE5E5),
                          ),
                        ),
                        child: IconButton(
                          onPressed: onMenuTap,
                          icon: Icon(
                            Icons.more_horiz,
                            color: isDark ? Colors.white70 : const Color(0xFFFF6B6B),
                            size: 24.sp,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
  
                      SizedBox(width: 12.w),
  
                      // View Slots Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onViewSlots,
                          icon: Icon(
                            Icons.layers_outlined,
                            size: 20.sp,
                          ),
                          label: Text(
                            'View Slots',
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
          Icons.directions_car_filled_outlined,
          size: 48.sp,
          color: isDark ? Colors.white38 : Colors.grey[400],
        ),
      ),
    );
  }
}
