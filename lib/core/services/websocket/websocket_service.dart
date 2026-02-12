import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:kipa/core/constants/api_constants.dart';
import 'package:kipa/utils/constant.dart';

enum WebSocketMessageType {
  pong,
  locationUpdate,
  jobStatus,
  chatMessage,
  newJobAvailable,
  nearbyRiders,
  connected,
  error,
  unknown,
}

class WebSocketMessage {
  final WebSocketMessageType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  const WebSocketMessage({
    required this.type,
    required this.data,
    required this.timestamp,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? '';
    final type = _parseMessageType(typeStr);

    final data = Map<String, dynamic>.from(json)..remove('type');

    return WebSocketMessage(type: type, data: data, timestamp: DateTime.now());
  }

  static WebSocketMessageType _parseMessageType(String type) {
    switch (type) {
      case 'pong':
        return WebSocketMessageType.pong;
      case 'location_update':
      case 'rider_location':
        return WebSocketMessageType.locationUpdate;
      case 'job_status':
        return WebSocketMessageType.jobStatus;
      case 'chat_message':
        return WebSocketMessageType.chatMessage;
      case 'new_job_available':
        return WebSocketMessageType.newJobAvailable;
      case 'nearby_riders':
        return WebSocketMessageType.nearbyRiders;
      case 'connected':
        return WebSocketMessageType.connected;
      case 'error':
        return WebSocketMessageType.error;
      default:
        return WebSocketMessageType.unknown;
    }
  }
}

class WebSocketService {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  final _messageController = StreamController<WebSocketMessage>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  bool _isConnected = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  String? _currentToken;
  String? _currentJobId;
  String? _currentRole;

  /// Stream of incoming WebSocket messages
  Stream<WebSocketMessage> get messageStream => _messageController.stream;

  /// Stream of connection status changes
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Current connection status
  bool get isConnected => _isConnected;

  /// Connect to WebSocket server
  Future<void> connect({
    required String token,
    required String jobId,
    String role = 'user',
  }) async {
    _currentToken = token;
    _currentJobId = jobId;
    _currentRole = role;
    _shouldReconnect = true;
    _reconnectAttempts = 0;

    await _establishConnection();
  }

  Future<void> _establishConnection() async {
    if (_currentToken == null || _currentJobId == null) return;

    try {
      // Build WebSocket URL
      final wsBaseUrl = ApiEndpoints.baseUrl
          .replaceFirst('https://', 'wss://')
          .replaceFirst('http://', 'ws://');

      final wsUrl = Uri.parse(
        '$wsBaseUrl/ws?token=$_currentToken&role=$_currentRole&job_id=$_currentJobId',
      );

      logMessage('WebSocketService', 'Connecting to: $wsUrl');

      _channel = WebSocketChannel.connect(wsUrl);

      // Listen to messages
      _channel!.stream.listen(_onMessage, onError: _onError, onDone: _onDone);

      _isConnected = true;
      _connectionController.add(true);
      _reconnectAttempts = 0;

      // Start heartbeat
      _startHeartbeat();

      logMessage('WebSocketService', 'Connected successfully');
    } catch (e) {
      logMessage('WebSocketService', 'Connection failed: $e');
      _isConnected = false;
      _connectionController.add(false);
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic message) {
    try {
      final json = jsonDecode(message as String) as Map<String, dynamic>;
      final wsMessage = WebSocketMessage.fromJson(json);

      logMessage('WebSocketService', 'Received: ${wsMessage.type}');
      _messageController.add(wsMessage);
    } catch (e) {
      logMessage('WebSocketService', 'Failed to parse message: $e');
    }
  }

  void _onError(dynamic error) {
    logMessage('WebSocketService', 'WebSocket error: $error');
    _isConnected = false;
    _connectionController.add(false);
    _messageController.add(
      WebSocketMessage(
        type: WebSocketMessageType.error,
        data: {'error': error.toString()},
        timestamp: DateTime.now(),
      ),
    );
  }

  void _onDone() {
    logMessage('WebSocketService', 'WebSocket closed');
    _isConnected = false;
    _connectionController.add(false);
    _stopHeartbeat();

    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      logMessage('WebSocketService', 'Max reconnect attempts reached');
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(
      seconds: _reconnectAttempts * 2,
    ); // Exponential backoff

    logMessage(
      'WebSocketService',
      'Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)',
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, _establishConnection);
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_isConnected) {
        send({'type': 'ping'});
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Send a message through WebSocket
  void send(Map<String, dynamic> data) {
    if (!_isConnected || _channel == null) {
      logMessage('WebSocketService', 'Cannot send: not connected');
      return;
    }

    try {
      final message = jsonEncode(data);
      _channel!.sink.add(message);
      logMessage('WebSocketService', 'Sent: ${data['type']}');
    } catch (e) {
      logMessage('WebSocketService', 'Send failed: $e');
    }
  }

  /// Send a chat message
  void sendChatMessage(
    String content, {
    String? mediaUrl,
    String mediaType = 'text',
  }) {
    send({
      'type': 'chat_message',
      'job_id': _currentJobId,
      'content': content,
      if (mediaUrl != null) 'media_url': mediaUrl,
      'media_type': mediaType,
    });
  }

  /// Disconnect from WebSocket
  Future<void> disconnect() async {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _stopHeartbeat();

    await _channel?.sink.close();
    _channel = null;

    _isConnected = false;
    _connectionController.add(false);

    logMessage('WebSocketService', 'Disconnected');
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _connectionController.close();
  }
}
