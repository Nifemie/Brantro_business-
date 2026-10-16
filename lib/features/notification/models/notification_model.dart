enum NotificationType {
  order,
  payment,
  message,
  system,
  revision,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String status;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.status = 'UNSEEN',
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status']?.toString().toUpperCase() ?? '';
    final isReadVal = json['isRead'] == true ||
        rawStatus == 'SEEN' ||
        rawStatus == 'READ' ||
        rawStatus == 'OPENED';

    final rawType = json['type']?.toString().toUpperCase() ?? '';
    final titleStr = (json['title'] ?? json['subject'] ?? '').toString().toUpperCase();
    final bodyStr = (json['body'] ?? json['message'] ?? json['content'] ?? '').toString().toUpperCase();
    final combinedContext = '$rawType $titleStr $bodyStr';

    NotificationType notifType = NotificationType.system;

    if (combinedContext.contains('ORDER') || combinedContext.contains('BOOKING')) {
      notifType = NotificationType.order;
    } else if (combinedContext.contains('PAYMENT') ||
        combinedContext.contains('WALLET') ||
        combinedContext.contains('WITHDRAWAL') ||
        combinedContext.contains('CREDITED')) {
      notifType = NotificationType.payment;
    } else if (combinedContext.contains('MESSAGE') || combinedContext.contains('CHAT')) {
      notifType = NotificationType.message;
    } else if (combinedContext.contains('REVISION')) {
      notifType = NotificationType.revision;
    }

    DateTime parsedDate;
    final dateStr = json['createdAt'] ?? json['timestamp'] ?? json['updatedAt'];
    if (dateStr != null) {
      parsedDate = DateTime.tryParse(dateStr.toString()) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    final rawMeta = json['meta'] ?? json['metadata'];

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: notifType,
      title: json['title']?.toString() ?? json['subject']?.toString() ?? 'Notification',
      message: json['body']?.toString() ?? json['message']?.toString() ?? json['content']?.toString() ?? '',
      status: rawStatus.isNotEmpty ? rawStatus : (isReadVal ? 'SEEN' : 'UNSEEN'),
      timestamp: parsedDate,
      isRead: isReadVal,
      actionUrl: json['actionUrl']?.toString(),
      metadata: rawMeta is Map<String, dynamic> ? rawMeta : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name.toUpperCase(),
      'title': title,
      'message': message,
      'status': status,
      'createdAt': timestamp.toIso8601String(),
      'isRead': isRead,
      if (actionUrl != null) 'actionUrl': actionUrl,
      if (metadata != null) 'metadata': metadata,
    };
  }

  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    String? status,
    DateTime? timestamp,
    bool? isRead,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}
