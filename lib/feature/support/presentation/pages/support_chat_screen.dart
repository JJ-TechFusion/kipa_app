import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/shared/widgets/custom_snackbar.dart';
import '../../../../core/shared/widgets/widgets.dart';
import '../../../../theme/app_colors.dart';
import '../../domain/entities/support_conversation_entity.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_request_entity.dart';
import '../providers/support_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SupportChatScreen extends ConsumerStatefulWidget {
  final SupportConversationEntity conversation;
  final List<SupportActiveDisputeEntity> activeDisputes;

  const SupportChatScreen({
    super.key,
    required this.conversation,
    required this.activeDisputes,
  });

  @override
  ConsumerState<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends ConsumerState<SupportChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  List<SupportMessageEntity> _messages = [];
  bool _isLoadingHistory = true;
  bool _isSendingMessage = false;
  bool _isUploadingImage = false;
  bool _isFetchingMessages = false;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _pollingTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      _loadMessages(showLoader: false, scrollToBottom: false);
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages({
    bool showLoader = true,
    bool scrollToBottom = true,
  }) async {
    if (_isFetchingMessages) return;

    _isFetchingMessages = true;
    if (showLoader && mounted) {
      setState(() {
        _isLoadingHistory = true;
      });
    }

    final response = await ref
        .read(getSupportMessagesUseCaseProvider)
        .call(limit: 50);

    if (!mounted) return;

    if (response.success && response.data is SupportMessageListEntity) {
      final data = response.data as SupportMessageListEntity;
      final sortedMessages = [...data.messages]
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      setState(() {
        _messages = sortedMessages;
      });
      await ref.read(markSupportMessagesReadUseCaseProvider).call();
      if (scrollToBottom) {
        _scrollToBottom();
      }
    } else if (showLoader) {
      CustomSnackBar.show(
        context,
        message: response.message.isEmpty
            ? 'Failed to load support messages'
            : response.message,
        type: SnackBarType.error,
      );
    }

    if (mounted) {
      setState(() {
        _isLoadingHistory = false;
      });
    }
    _isFetchingMessages = false;
  }

  Future<void> _sendTextMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSendingMessage) return;

    setState(() {
      _isSendingMessage = true;
    });

    _messageController.clear();
    final response = await ref
        .read(sendSupportMessageUseCaseProvider)
        .call(SendSupportMessageRequest(content: text, mediaType: 'text'));

    if (!mounted) return;

    setState(() {
      _isSendingMessage = false;
    });

    if (response.success && response.data is SupportMessageEntity) {
      setState(() {
        _messages = [..._messages, response.data as SupportMessageEntity]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      });
      _scrollToBottom();
      return;
    }

    _messageController.text = text;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
    CustomSnackBar.show(
      context,
      message: response.message.isEmpty
          ? 'Failed to send message'
          : response.message,
      type: SnackBarType.error,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 85,
    );
    if (image == null || !mounted) return;

    await _sendImageMessage(image);
  }

  Future<void> _sendImageMessage(XFile image) async {
    setState(() {
      _isUploadingImage = true;
    });

    final bytes = await image.readAsBytes();
    final uploadResponse = await ref
        .read(uploadSupportMediaUseCaseProvider)
        .call(fileName: image.name, fileBytes: bytes.toList());

    if (!mounted) return;

    if (!uploadResponse.success ||
        (uploadResponse.data as String?)?.isEmpty != false) {
      setState(() {
        _isUploadingImage = false;
      });
      CustomSnackBar.show(
        context,
        message: uploadResponse.message.isEmpty
            ? 'Failed to upload image'
            : uploadResponse.message,
        type: SnackBarType.error,
      );
      return;
    }

    final mediaUrl = uploadResponse.data as String;
    final sendResponse = await ref
        .read(sendSupportMessageUseCaseProvider)
        .call(
          SendSupportMessageRequest(
            content: 'Image attachment',
            mediaUrl: mediaUrl,
            mediaType: 'image',
          ),
        );

    if (!mounted) return;

    setState(() {
      _isUploadingImage = false;
    });

    if (sendResponse.success && sendResponse.data is SupportMessageEntity) {
      setState(() {
        _messages = [..._messages, sendResponse.data as SupportMessageEntity]
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      });
      _scrollToBottom();
      return;
    }

    CustomSnackBar.show(
      context,
      message: sendResponse.message.isEmpty
          ? 'Failed to send image message'
          : sendResponse.message,
      type: SnackBarType.error,
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BodyText('Send Image', fontWeight: FontWeight.w600),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColor.primary,
                ),
                title: const BodyText('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColor.primary),
                title: const BodyText('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(authNotifierProvider).currentUser?.id;
    final disputes = _uniqueDisputes(widget.activeDisputes);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        if (maxScroll - currentScroll < 120) {
          _scrollToBottom();
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leadingWidth: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8, right: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                child: Icon(Icons.support_agent, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      'Support',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    Caption(
                      'Online',
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (disputes.isNotEmpty) _buildDisputesSection(disputes),
          Expanded(
            child: _isLoadingHistory
                ? const Center(
                    child: CircularProgressIndicator(color: AppColor.primary),
                  )
                : _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isMe =
                          message.senderId == currentUserId || !message.isAdmin;
                      final showDate =
                          index == 0 ||
                          !_isSameDay(
                            _messages[index - 1].createdAt,
                            message.createdAt,
                          );

                      return Column(
                        children: [
                          if (showDate) _buildDateSeparator(message.createdAt),
                          _SupportChatBubble(
                            message: message,
                            isMe: isMe,
                            showSenderName: true,
                          ),
                        ],
                      );
                    },
                  ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  List<SupportActiveDisputeEntity> _uniqueDisputes(
    List<SupportActiveDisputeEntity> disputes,
  ) {
    final seen = <String>{};
    final result = <SupportActiveDisputeEntity>[];
    for (final item in disputes) {
      if (item.dispute.id.isEmpty) continue;
      if (seen.add(item.dispute.id)) {
        result.add(item);
      }
    }
    return result;
  }

  Widget _buildDisputesSection(List<SupportActiveDisputeEntity> disputes) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BodyText(
            'Active Disputes',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppColor.primaryText,
          ),
          const SizedBox(height: 8),
          ...disputes.map((item) {
            final evidence = item.dispute.evidence;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodySmall(
                    item.paymentRequest.itemName,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryText,
                  ),
                  const SizedBox(height: 4),
                  Overline(item.dispute.reason, color: AppColor.primaryText),
                  if (evidence.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 74,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: evidence.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              evidence[index],
                              width: 74,
                              height: 74,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 74,
                                height: 74,
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: Colors.grey[350],
          ),
          const SizedBox(height: 12),
          BodyText(
            'No messages yet',
            fontWeight: FontWeight.w500,
            color: Colors.grey[500],
          ),
          const SizedBox(height: 4),
          BodyText(
            'Send a message to start the conversation',
            fontWeight: FontWeight.w500,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    String label;
    if (messageDate == today) {
      label = 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      label = 'Yesterday';
    } else {
      label = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _isUploadingImage ? null : _showImageSourceDialog,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.kipaGrey.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: _isUploadingImage
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primary,
                      ),
                    )
                  : const Icon(Icons.image_outlined, color: AppColor.primary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.kipaGrey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextInputField(
                controller: _messageController,
                hintText: 'Type a message...',
                onEditingDone: _sendTextMessage,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isSendingMessage ? null : _sendTextMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isSendingMessage
                    ? AppColor.lightText
                    : AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: _isSendingMessage
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportChatBubble extends StatelessWidget {
  final SupportMessageEntity message;
  final bool isMe;
  final bool showSenderName;

  const _SupportChatBubble({
    required this.message,
    required this.isMe,
    this.showSenderName = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: isMe ? 48 : 0,
          right: isMe ? 0 : 48,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isMe ? AppColor.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isMe && showSenderName)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ),
            if (message.mediaType == 'image' && message.mediaUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    message.mediaUrl!,
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            if (message.content.isNotEmpty)
              Text(
                message.content,
                style: TextStyle(
                  color: isMe ? Colors.white : AppColor.primaryText,
                  fontSize: 14.5,
                  height: 1.35,
                ),
              ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isMe ? Colors.white60 : Colors.grey[500],
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 3),
                  Icon(
                    message.status == 'read' ? Icons.done_all : Icons.done,
                    size: 14,
                    color: message.status == 'read'
                        ? const Color(0xFF53BDEB)
                        : Colors.white60,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
