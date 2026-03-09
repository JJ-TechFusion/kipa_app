import '../../domain/entities/support_message_entity.dart';

class SupportMessageModel {
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

  const SupportMessageModel({
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

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      senderName: json['sender_name']?.toString() ?? '',
      isAdmin: json['is_admin'] as bool? ?? false,
      content: json['content']?.toString() ?? '',
      mediaUrl: json['media_url']?.toString(),
      mediaType: json['media_type']?.toString() ?? 'text',
      status: json['status']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'].toString())
          : null,
    );
  }

  SupportMessageEntity toEntity() {
    return SupportMessageEntity(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      isAdmin: isAdmin,
      content: content,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      status: status,
      createdAt: createdAt,
      readAt: readAt,
    );
  }
}

class SupportMessageListModel {
  final List<SupportMessageModel> messages;

  const SupportMessageListModel({required this.messages});

  factory SupportMessageListModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageListModel(
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map(
                (e) => SupportMessageModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  SupportMessageListEntity toEntity() {
    return SupportMessageListEntity(
      messages: messages.map((e) => e.toEntity()).toList(),
    );
  }
}
