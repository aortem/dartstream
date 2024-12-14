// lib/screens/apple_sign_in_screen/apple_webview_auth.dart

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppleWebViewAuth extends StatefulWidget {
  const AppleWebViewAuth({super.key});

  @override
  State<AppleWebViewAuth> createState() => _AppleWebViewAuthState();
}

class _AppleWebViewAuthState extends State<AppleWebViewAuth> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Check for the callback URL with the token
            if (url.contains('id_token=')) {
              final uri = Uri.parse(url);
              final idToken = uri.queryParameters['id_token'];
              if (idToken != null) {
                Navigator.pop(context, idToken);
              }
            }
          },
          onPageFinished: (String url) {
            setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://appleid.apple.com/auth/authorize?'
            'response_type=id_token&'
            'client_id=YOUR_SERVICES_ID&' // Replace with your Apple Services ID
            'redirect_uri=${Uri.encodeComponent("https://your-firebase-project.firebaseapp.com/__/auth/handler")}&'
            'scope=email%20name&'
            'response_mode=fragment'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in with Apple'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
