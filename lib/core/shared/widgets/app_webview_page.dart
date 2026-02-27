import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebviewPage extends StatefulWidget {
  const AppWebviewPage({
    super.key,
    required this.pageUrl,
    this.pageStartedCallback,
    this.pageFinishedCallback,
    this.callbackUrl,
    this.onPaymentComplete,
  });
  final String pageUrl;
  final void Function(String)? pageStartedCallback;
  final void Function(String)? pageFinishedCallback;
  final String? callbackUrl;
  final VoidCallback? onPaymentComplete;

  @override
  State<AppWebviewPage> createState() => _AppWebviewPageState();
}

class _AppWebviewPageState extends State<AppWebviewPage> {
  late WebViewController _controller;
  bool _hasHandledCompletion = false;
  bool _hasValidUrl = false;

  @override
  void initState() {
    super.initState();
    _hasValidUrl = _isValidUrl(widget.pageUrl);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: widget.pageStartedCallback,
          onPageFinished: (url) {
            widget.pageFinishedCallback?.call(url);
            _checkForPaymentCompletion(url);
          },
          onNavigationRequest: (request) {
            if (_isPaymentComplete(request.url)) {
              _handlePaymentComplete();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    if (_hasValidUrl) {
      _controller.loadRequest(Uri.parse(widget.pageUrl));
    }
  }

  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  void _handlePaymentComplete() {
    if (_hasHandledCompletion) return;
    _hasHandledCompletion = true;
    widget.onPaymentComplete?.call();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _checkForPaymentCompletion(String url) {
    if (_isPaymentComplete(url)) {
      _handlePaymentComplete();
    }
  }

  bool _isPaymentComplete(String url) {
    final lowerUrl = url.toLowerCase();

    // Check for Flutterwave completion patterns
    if (lowerUrl.contains('flutterwave')) {
      // Success patterns
      if (lowerUrl.contains('status=successful') ||
          lowerUrl.contains('status=completed') ||
          lowerUrl.contains('tx_ref=') ||
          lowerUrl.contains('transaction_id=')) {
        return true;
      }
    }

    // Check for app's backend callback URLs
    if (lowerUrl.contains('getkipa.com')) {
      if (lowerUrl.contains('callback') ||
          lowerUrl.contains('verify') ||
          lowerUrl.contains('success') ||
          lowerUrl.contains('complete')) {
        return true;
      }
    }

    if (lowerUrl.contains('payment/callback') ||
        lowerUrl.contains('payment-callback') ||
        lowerUrl.contains('verify-payment') ||
        lowerUrl.contains('payment/verify')) {
      return true;
    }

    if (widget.callbackUrl != null &&
        lowerUrl.contains(widget.callbackUrl!.toLowerCase())) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Complete Payment'),
        elevation: 0,
      ),
      body: SafeArea(
        child: _hasValidUrl
            ? WebViewWidget(controller: _controller)
            : const Center(
                child: Text('Unable to load page. Invalid URL provided.'),
              ),
      ),
    );
  }
}
