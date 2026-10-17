import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/features/chat/data/models/chat_message.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_message_item.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_input_area.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_profile_panel.dart';
import 'package:brantro_business/controllers/re_useable/app_color.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_list_drawer.dart';

class ChatScreen extends ConsumerWidget {
  final List<ChatMessage> messages;

  const ChatScreen({
    super.key,
    this.messages = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const ChatAppBar(),
      drawer: const ChatListDrawer(),
      endDrawer: const ChatProfilePanel(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Chat messages list or Empty State (BRT-021)
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : AppColors.primaryColor.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 40.sp,
                              color: isDark ? Colors.white70 : AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No Messages Yet',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Your direct conversations with clients and buyers will appear here once an inquiry is started.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatMessageItem(message: message, isDark: isDark);
                    },
                  ),
          ),
          // Bottom input area
          ChatInputArea(isDark: isDark),
        ],
      ),
    );
  }
}
