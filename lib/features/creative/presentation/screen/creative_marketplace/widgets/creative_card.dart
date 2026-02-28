import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';

class CreativeCard extends StatelessWidget {
  final String bannerImage;
  final String title;
  final String category;
  final String type;
  final String duration;
  final String size;
  final bool isActive;
  final VoidCallback onViewOrders;
  final VoidCallback? onMenuTap;

  const CreativeCard({
    super.key,
    required this.bannerImage,
    required this.title,
    required this.category,
    required this.type,
    required this.duration,
    required this.size,
    this.isActive = true,
    required this.onViewOrders,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                child: Image.asset(
                  bannerImage,
                  width: double.infinity,
                  height: 180.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
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
                  },
                ),
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

          // Content Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 12.h),

                // Tags Row
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _buildTag(category, AppColors.secondaryColor.withOpacity(0.1), 
                        AppColors.secondaryColor, isDark),
                    _buildTag(type, isDark ? Colors.grey[800]! : Colors.grey[200]!, 
                        isDark ? Colors.white70 : Colors.grey[700]!, isDark),
                    _buildTag(duration, isDark ? Colors.grey[800]! : Colors.grey[200]!, 
                        isDark ? Colors.white70 : Colors.grey[700]!, isDark),
                    _buildTag(size, isDark ? Colors.grey[800]! : Colors.grey[200]!, 
                        isDark ? Colors.white70 : Colors.grey[700]!, isDark),
                  ],
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

                    // View Orders Button
                    Expanded(
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color bgColor, Color textColor, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
