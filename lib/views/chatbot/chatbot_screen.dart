import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:blood_synergy_app/network_helpers/serverSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  InAppWebViewController? webViewController;
  bool _ready = false;

  static final Uri _chatbotUri = Uri.parse(
    '${ServerSettings.mainBaseURL}/chatbot.php',
  );

  @override
  void initState() {
    super.initState();
    _setAuthCookieAndLoad();
  }

  Future<void> _setAuthCookieAndLoad() async {
    final token = await UserPref.getWebUserToken();
    print("Token: $token");
    if (token != null && token.isNotEmpty) {
      await CookieManager.instance().setCookie(
        url: WebUri('https://web.blood-synergy.com'),
        name: 'auth_token',
        value: token,
        domain: 'web.blood-synergy.com',
        path: '/',
        isSecure: true,
        isHttpOnly: true,
        sameSite: HTTPCookieSameSitePolicy.LAX,
      );
    }
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 2.0,
            ).r,
            child: Text(
              'Enter your lab values manually or upload your image results to access research-based insights and scientific data relevant to your lab patterns.',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          Expanded(
            child: _ready
                ? InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri.uri(_chatbotUri),
                    ),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
