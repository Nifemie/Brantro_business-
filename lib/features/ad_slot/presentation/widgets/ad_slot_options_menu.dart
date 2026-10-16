import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showAdSlotOptionsMenu(
  BuildContext context, {
  required VoidCallback onDelete,
  required VoidCallback onEdit,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? Colors.grey[850] : Colors.white),
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
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: isDark ? Colors.white70 : Colors.grey[700],
                    ),
                    title: Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : Colors.grey[900],
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to slot details
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.share_outlined,
                      color: isDark ? Colors.white70 : Colors.grey[700],
                    ),
                    title: Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : Colors.grey[900],
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Share slot
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
