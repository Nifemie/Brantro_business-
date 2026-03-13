import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/features/chat/data/models/chat_message.dart';

/// Displays a single chat message item with the appropriate bubble type,
/// timestamp, and read receipt indicator.
class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;

  const ChatMessageItem({
    super.key,
    required this.message,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.sender == MessageSender.me;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message content
          if (message.type == MessageType.text)
            _TextBubble(message: message, isMe: isMe, isDark: isDark),
          if (message.type == MessageType.image)
            _ImageBubble(message: message, isMe: isMe, isDark: isDark),
          if (message.type == MessageType.file)
            _FileBubble(message: message, isMe: isMe, isDark: isDark),
          SizedBox(height: 4.h),
          // Timestamp + read receipt
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                message.timeAgo,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isDark ? Colors.white38 : AppColors.grey500,
                ),
              ),
              if (isMe && message.isRead) ...[
                SizedBox(width: 4.w),
                Icon(
                  Icons.done_all,
                  size: 14.sp,
                  color: AppColors.secondaryColor,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Text Bubble ──────────────────────────────────────────────

class _TextBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool isDark;

  const _TextBubble({
    required this.message,
    required this.isMe,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.secondaryColor
            : (isDark ? Colors.white.withOpacity(0.08) : AppColors.grey100),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
          bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(16.r),
        ),
      ),
      child: Text(
        message.text ?? '',
        style: TextStyle(
          fontSize: 14.sp,
          color: isMe
              ? Colors.white
              : (isDark ? Colors.white70 : AppColors.grey800),
          height: 1.4,
        ),
      ),
    );
  }
}

// ─── Image Bubble ─────────────────────────────────────────────

class _ImageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool isDark;

  const _ImageBubble({
    required this.message,
    required this.isMe,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.secondaryColor
            : (isDark ? Colors.white.withOpacity(0.08) : AppColors.grey100),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
          bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(16.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: (message.imageUrls ?? []).map((url) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                url,
                width: 72.w,
                height: 72.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : AppColors.grey300,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.image,
                    color: isDark ? Colors.white38 : AppColors.grey500,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── File Bubble ──────────────────────────────────────────────

class _FileBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool isDark;

  const _FileBubble({
    required this.message,
    required this.isMe,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.secondaryColor
            : (isDark ? Colors.white.withOpacity(0.08) : AppColors.grey100),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
          bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(16.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withOpacity(0.2)
                  : (isDark ? Colors.white12 : AppColors.grey200),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.insert_drive_file_rounded,
              color: isMe
                  ? Colors.white
                  : (isDark ? Colors.white54 : AppColors.grey600),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.fileName ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isMe
                        ? Colors.white
                        : (isDark ? Colors.white70 : AppColors.grey800),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  message.fileSize ?? '',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isMe
                        ? Colors.white70
                        : (isDark ? Colors.white38 : AppColors.grey500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
