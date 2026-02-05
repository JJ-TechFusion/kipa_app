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

  @override
  void initState() {
    super.initState();
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
              widget.onPaymentComplete?.call();
              Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.pageUrl));
  }

  void _checkForPaymentCompletion(String url) {
    if (_isPaymentComplete(url)) {
      widget.onPaymentComplete?.call();
      Navigator.of(context).pop();
    }
  }

  bool _isPaymentComplete(String url) {
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('paystack') &&
        (lowerUrl.contains('success') ||
            lowerUrl.contains('callback') ||
            lowerUrl.contains('trxref=') ||
            lowerUrl.contains('reference='))) {
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
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
