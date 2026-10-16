import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/faq_model.dart';

class FaqItemCard extends StatelessWidget {
  final FaqModel faq;
  final VoidCallback onDelete;
  final VoidCallback onView;

  const FaqItemCard({
    super.key,
    required this.faq,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
          // Title (Orange color matching mockup)
          Text(
            faq.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF6B35),
            ),
          ),
          SizedBox(height: 12.h),

          // Answer (Grey text)
          Text(
            faq.answer,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),

          // Bottom Action Row
          Row(
            children: [
              // pinkish/orange '...' menu button matching mockup
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
                  onPressed: () => _showFaqOptions(context),
                  icon: Icon(
                    Icons.more_horiz,
                    color: const Color(0xFFFF6B35),
                    size: 20.sp,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              SizedBox(width: 12.w),

              // View Button matching mockup
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
                    onTap: onView,
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

  void _showFaqOptions(BuildContext context) {
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
                      leading: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Delete FAQ',
                        style: TextStyle(color: Colors.red),
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
}
