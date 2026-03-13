/// Represents a single chat message
enum MessageType { text, image, file }

enum MessageSender { me, other }

class ChatMessage {
  final String? text;
  final String timeAgo;
  final MessageSender sender;
  final MessageType type;
  final List<String>? imageUrls;
  final String? fileName;
  final String? fileSize;
  final bool isRead;

  const ChatMessage({
    this.text,
    required this.timeAgo,
    required this.sender,
    this.type = MessageType.text,
    this.imageUrls,
    this.fileName,
    this.fileSize,
    this.isRead = false,
  });
}
