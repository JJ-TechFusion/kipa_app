class SupportMessageEntity {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final bool isAdmin;
  final String content;
  final String? mediaUrl;
  final String mediaType;
  final String status;
  final DateTime createdAt;
  final DateTime? readAt;

  const SupportMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.isAdmin,
    required this.content,
    required this.mediaUrl,
    required this.mediaType,
    required this.status,
    required this.createdAt,
    required this.readAt,
  });
}

class SupportMessageListEntity {
  final List<SupportMessageEntity> messages;

  const SupportMessageListEntity({required this.messages});
}
