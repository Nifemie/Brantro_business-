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

class ChatScreen extends ConsumerStatefulWidget {
  final List<ChatMessage> messages;

  const ChatScreen({
    super.key,
    this.messages = const [],
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final List<ChatMessage> _messages;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = List<ChatMessage>.from(widget.messages);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(
          text: text.trim(),
          timeAgo: 'Just now',
          sender: MessageSender.me,
          type: MessageType.text,
          isRead: true,
        ),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: _messages.isEmpty
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
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatMessageItem(message: message, isDark: isDark);
                    },
                  ),
          ),
          // Bottom input area
          ChatInputArea(
            isDark: isDark,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
