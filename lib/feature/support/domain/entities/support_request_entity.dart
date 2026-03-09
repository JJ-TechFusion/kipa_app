class SendSupportMessageRequest {
  final String content;
  final String? mediaUrl;
  final String mediaType;

  const SendSupportMessageRequest({
    required this.content,
    this.mediaUrl,
    this.mediaType = 'text',
  });

  Map<String, dynamic> toJson() {
    return {'content': content, 'media_url': mediaUrl, 'media_type': mediaType};
  }
}
