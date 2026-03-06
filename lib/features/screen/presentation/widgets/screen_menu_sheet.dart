import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenMenuSheet extends StatelessWidget {
  final String screenName;
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScreenMenuSheet({
    super.key,
    required this.screenName,
    required this.onViewDetails,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    screenName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 20.h),
                  _buildMenuItem(context, icon: Icons.visibility_outlined, label: 'View Details', onTap: onViewDetails, isDark: isDark),
                  _buildMenuItem(context, icon: Icons.edit_outlined, label: 'Edit Screen', onTap: onEdit, isDark: isDark),
                  _buildMenuItem(context, icon: Icons.share_outlined, label: 'Share', onTap: () => Navigator.pop(context), isDark: isDark),
                  _buildMenuItem(context, icon: Icons.delete_outline, label: 'Delete', onTap: onDelete, isDark: isDark, isDestructive: true),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap, required bool isDark, bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: isDestructive ? Colors.red.withOpacity(0.1) : (isDark ? Colors.grey[800] : Colors.grey[100]),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 22.sp, color: isDestructive ? Colors.red : (isDark ? Colors.white70 : Colors.grey[700])),
            ),
            SizedBox(width: 16.w),
            Expanded(child: Text(label, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: isDestructive ? Colors.red : (isDark ? Colors.white : Colors.grey[900])))),
            Icon(Icons.chevron_right, size: 20.sp, color: isDark ? Colors.grey[600] : Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
