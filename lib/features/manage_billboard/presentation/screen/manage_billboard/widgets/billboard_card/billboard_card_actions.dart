import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BillboardCardActions extends StatelessWidget {
  final bool isDark;
  final String title;

  const BillboardCardActions({
    super.key,
    required this.isDark,
    required this.title,
  });

  // ------- Update confirmation dialog -------
  void _showUpdateDialog(BuildContext context, bool isDark, String name) {
    final bgColor = isDark ? const Color(0xFF22272B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.grey[400] : Colors.grey[600];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Update Billboard',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        content: Text(
          'You are about to update "$name". This will allow you to modify the billboard details.',
          style: TextStyle(fontSize: 14.sp, color: subColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: subColor, fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to update billboard screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003D82),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Update',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------- Delete confirmation dialog -------
  void _showDeleteDialog(BuildContext context, bool isDark, String name) {
    final bgColor = isDark ? const Color(0xFF22272B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.grey[400] : Colors.grey[600];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Billboard',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFE55858),
          ),
        ),
        content: Text(
          'Are you sure you want to delete "$name"? This action cannot be undone.',
          style: TextStyle(fontSize: 14.sp, color: subColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Call delete API
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE55858),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final popupBg = isDark ? const Color(0xFF22272B) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Row(
      children: [
        // Orange 3-dot button — opens popup menu
        PopupMenuButton<String>(
          offset: Offset(0, 60.h),
          color: popupBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          onSelected: (value) {
            switch (value) {
              case 'update':
                _showUpdateDialog(context, isDark, title);
                break;
              case 'overview':
                // TODO: Navigate to overview screen
                break;
              case 'delete':
                _showDeleteDialog(context, isDark, title);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'update',
              child: Text(
                'Update',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'overview',
              child: Text(
                'Overview',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFE55858),
                ),
              ),
            ),
          ],
          child: Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(Icons.more_horiz, color: Colors.white),
          ),
        ),

        SizedBox(width: 16.w),

        // View Slots Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              context.push('/ads-slots', extra: {'billboardTitle': title});
            },
            icon: Icon(Icons.layers_outlined, size: 18.sp),
            label: Text(
              'View Slots',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? const Color(0xFF2D333B)
                  : Colors.grey[100],
              foregroundColor: isDark ? Colors.grey[300] : Colors.black87,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              elevation: 0,
              side: BorderSide(
                color: isDark ? const Color(0xFF3E444C) : Colors.grey[300]!,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
