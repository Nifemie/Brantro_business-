import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../data/models/announcement_model.dart';
import 'announcement_details_dialog.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final VoidCallback? onDelete;
  final VoidCallback? onView;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    this.onDelete,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(announcement.createdAt);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? (isDark ? Colors.grey[850] : Colors.white),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Audience & Category Badges + Date
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : const Color(0xFFFFEBE3),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : const Color(0xFFFFC5B0),
                    width: 1,
                  ),
                ),
                child: Text(
                  announcement.audience.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF6B35),
                  ),
                ),
              ),
              if (announcement.category != null && announcement.category!.isNotEmpty) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    announcement.category!,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Title (Orange color matching FAQ design)
          Text(
            announcement.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF6B35),
            ),
          ),
          SizedBox(height: 10.h),

          // Description (Grey text matching FAQ design)
          Text(
            announcement.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 20.h),

          // Bottom Action Row matching FAQ design
          Row(
            children: [
              // pinkish/orange '...' menu button matching FAQ design
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : const Color(0xFFFFEBE3),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : const Color(0xFFFFC5B0),
                    width: 1.2,
                  ),
                ),
                child: IconButton(
                  onPressed: () => _showAnnouncementOptions(context),
                  icon: Icon(
                    Icons.more_horiz,
                    color: const Color(0xFFFF6B35),
                    size: 20.sp,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              SizedBox(width: 12.w),

              // View Button matching FAQ design
              Expanded(
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      width: 1.2,
                    ),
                  ),
                  child: InkWell(
                    onTap: onView ?? () => _showAnnouncementDetails(context),
                    borderRadius: BorderRadius.circular(10.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 18.sp,
                          color: isDark ? Colors.white70 : const Color(0xFF1A2B4B),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'View',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : const Color(0xFF1A2B4B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAnnouncementDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AnnouncementDetailsDialog(announcement: announcement),
    );
  }

  void _showAnnouncementOptions(BuildContext context) {
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
                        Icons.visibility_outlined,
                        color: isDark ? Colors.white70 : const Color(0xFF1A2B4B),
                      ),
                      title: Text(
                        'View Announcement',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showAnnouncementDetails(context);
                      },
                    ),
                    if (onDelete != null)
                      ListTile(
                        leading: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        title: const Text(
                          'Delete Announcement',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          onDelete!();
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
}
