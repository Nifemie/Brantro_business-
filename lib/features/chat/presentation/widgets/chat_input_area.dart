import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';

/// Bottom input area for the chat screen with emoji, text field,
/// attachment icons, and send button.
class ChatInputArea extends StatelessWidget {
  final bool isDark;

  const ChatInputArea({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Message input row
          Row(
            children: [
              // Emoji button
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.emoji_emotions_outlined,
                  color: isDark ? Colors.white38 : AppColors.grey500,
                  size: 24.sp,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 36.w),
              ),
              SizedBox(width: 4.w),
              // Text field
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : AppColors.grey100,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Text(
                    'Enter your message',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white30 : AppColors.grey400,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Bottom action buttons row
          Row(
            children: [
              SizedBox(width: 8.w),
              // Attachment icon
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.link_rounded,
                  color: isDark ? Colors.white38 : AppColors.grey500,
                  size: 24.sp,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 40.w),
              ),
              SizedBox(width: 12.w),
              // Video icon
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.videocam_outlined,
                  color: isDark ? Colors.white38 : AppColors.grey500,
                  size: 24.sp,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 40.w),
              ),
              const Spacer(),
              // Send button
              Container(
                height: 42.h,
                width: 140.w,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
