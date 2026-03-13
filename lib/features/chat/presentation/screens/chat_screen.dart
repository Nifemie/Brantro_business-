import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brantro_business/features/chat/data/models/chat_message.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_message_item.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_input_area.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_profile_panel.dart';
import 'package:brantro_business/features/chat/presentation/widgets/chat_list_drawer.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  // Mock messages
  static const List<ChatMessage> _mockMessages = [
    ChatMessage(
      text: 'Hey 😊',
      timeAgo: '1 hour ago',
      sender: MessageSender.other,
    ),
    ChatMessage(
      text: 'Hii',
      timeAgo: '1 hour ago',
      sender: MessageSender.me,
      isRead: true,
    ),
    ChatMessage(
      text:
          "Hi Gaston, thanks for joining the meeting. Let's dive into our quarterly performance review.",
      timeAgo: '1 hour ago',
      sender: MessageSender.other,
    ),
    ChatMessage(
      text:
          "Hi Gilbert, thanks for having me. I'm ready to discuss how things have been going.",
      timeAgo: '1 hour ago',
      sender: MessageSender.me,
      isRead: true,
    ),
    ChatMessage(
      timeAgo: '1 hour ago',
      sender: MessageSender.other,
      type: MessageType.image,
      imageUrls: [
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=200',
        'https://images.unsplash.com/photo-1509587584298-0f3b3a3a1797?w=200',
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=200',
      ],
    ),

    ChatMessage(
      timeAgo: '20 minutes ago',
      sender: MessageSender.me,
      type: MessageType.file,
      fileName: 'financial-report-2024.zip',
      fileSize: '2.3 MB',
      isRead: true,
    ),
    ChatMessage(
      text:
          "Thanks, Emily. I appreciate your support. Overall, I'm optimistic about our team's performance and looking forward to tackling new challenges in the next quarter.",
      timeAgo: '10 minutes ago',
      sender: MessageSender.other,
    ),
  ];

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
          // Chat messages list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: _mockMessages.length,
              itemBuilder: (context, index) {
                final message = _mockMessages[index];
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
