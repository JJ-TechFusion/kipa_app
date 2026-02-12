import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/shared/widgets/widgets.dart';
import '../../../../theme/app_colors.dart';
import '../../../../utils/constant.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../domain/entities/delivery_entities.dart';
import '../providers/delivery_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/services/network/api_services.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String jobId;
  final String participantName;
  final String? participantPhotoUrl;

  const ChatScreen({
    super.key,
    required this.jobId,
    required this.participantName,
    this.participantPhotoUrl,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final ChatRemoteDatasource _chatDatasource;
  List<ChatMessageEntity> _history = [];
  bool _isLoadingHistory = true;
  StreamSubscription? _messageSub;

  @override
  void initState() {
    super.initState();
    _chatDatasource = ChatRemoteDatasource(getIt<ApiService>());
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final messages = await _chatDatasource.getChatHistory(widget.jobId);
    if (mounted) {
      setState(() {
        _history = messages;
        _isLoadingHistory = false;
      });
      _scrollToBottom();
      _chatDatasource.markAsRead(widget.jobId);
    }
  }

  void _scrollToBottom() {
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

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    final notifier = ref.read(deliveryTrackingProvider.notifier);
    notifier.sendChatMessage(text);
    _scrollToBottom();
  }

  List<ChatMessageEntity> get _allMessages {
    final trackingState = ref.watch(deliveryTrackingProvider);
    final realTimeIds = trackingState.messages.map((m) => m.id).toSet();
    final combined = <ChatMessageEntity>[
      ..._history.where((m) => !realTimeIds.contains(m.id)),
      ...trackingState.messages,
    ];
    combined.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return combined;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _allMessages;

    // Auto-scroll when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        // Only auto-scroll if user is near bottom
        if (maxScroll - currentScroll < 150) {
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
              _buildBackButton(),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                backgroundImage: widget.participantPhotoUrl != null
                    ? NetworkImage(widget.participantPhotoUrl!)
                    : null,
                child: widget.participantPhotoUrl == null
                    ? BodyText(
                        widget.participantName.isNotEmpty
                            ? widget.participantName[0].toUpperCase()
                            : '?',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      widget.participantName,
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
      body: Stack(
        children: [
          Column(
            children: [
              // Messages list
              Expanded(
                child: _isLoadingHistory
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primary,
                        ),
                      )
                    : messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final currentUserId = ref
                              .read(authNotifierProvider)
                              .currentUser
                              ?.id;
                          final showDate =
                              index == 0 ||
                              !_isSameDay(
                                messages[index - 1].timestamp,
                                message.timestamp,
                              );
                          return Column(
                            children: [
                              if (showDate)
                                _buildDateSeparator(message.timestamp),
                              _ChatBubble(
                                message: message,
                                isMe:
                                    message.isMe ||
                                    message.senderId == currentUserId,
                              ),
                            ],
                          );
                        },
                      ),
              ),
              // Input bar
              _buildInputBar(),
            ],
          ),

          // Floating back button
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.kipaGrey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextInputField(
                controller: _messageController,
                hintText: 'Type a message...',
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;

  const _ChatBubble({required this.message, required this.isMe});

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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.isImage && message.mediaUrl != null)
              ClipRRect(
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
            if (message.message.isNotEmpty)
              Text(
                message.message,
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
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isMe ? Colors.white60 : Colors.grey[500],
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 3),
                  Icon(
                    message.status == 'read'
                        ? Icons.done_all
                        : message.status == 'delivered'
                        ? Icons.done_all
                        : Icons.done,
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
