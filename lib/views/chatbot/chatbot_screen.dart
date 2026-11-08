import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:blood_synergy_app/helpers/ai_consent.dart';
import 'package:blood_synergy_app/network_helpers/serverSettings.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:blood_synergy_app/views/screens/sources_citations_screen.dart';
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
  bool _consentChecked = false;
  bool _loadingConsent = true;

  static final Uri _chatbotUri = Uri.parse(
    '${ServerSettings.mainBaseURL}/chatbot.php',
  );

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final consented = AiConsent.hasConsented;
    if (!mounted) return;
    setState(() {
      _loadingConsent = false;
      _consentChecked = consented;
    });
    if (consented) {
      await _setAuthCookieAndLoad();
    }
  }

  Future<void> _setAuthCookieAndLoad() async {
    final token =
        await UserPref.getUserToken() ?? await UserPref.getWebUserToken();
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

  Future<void> _acceptConsent() async {
    await AiConsent.setConsented(true);
    if (!mounted) return;
    setState(() {
      _consentChecked = true;
      _ready = false;
    });
    await _setAuthCookieAndLoad();
  }

  Future<void> _declineConsent() async {
    await AiConsent.setConsented(false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot', style: appTextTheme.gilorySemiBold16Black),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(50, 50, 50, 1),
        elevation: 0.5,
        actions: _consentChecked
            ? [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SourcesCitationsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Sources',
                    style: appTextTheme.gilorySemiBold16Black
                        .copyWith(fontSize: 13.sp, color: Colors.blue),
                  ),
                ),
              ]
            : null,
      ),
      backgroundColor: Colors.white,
      body: _loadingConsent
          ? const Center(child: CircularProgressIndicator())
          : (!_consentChecked ? _buildConsentGate() : _buildChatbotBody()),
    );
  }

  Widget _buildConsentGate() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share data with Google Gemini?',
              style: appTextTheme.giloryBold16Black.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              'To generate educational analysis, Blood Synergy sends the information below to Google\'s Gemini AI service. Identifying details are removed before AI processing. You can enter values manually instead of uploading images. This is not medical advice.',
              style: appTextTheme.giloryMedium12Black.copyWith(height: 1.4),
            ),
            SizedBox(height: 16.h),
            _infoCard(
              title: 'What data may be sent',
              body:
                  'Messages you type; lab values you enter; images of lab reports you choose to upload; sex/gender if set on your profile (used because reference ranges can differ by sex); and your account authentication token to keep your session secure.',
            ),
            SizedBox(height: 10.h),
            _infoCard(
              title: 'Who receives the data',
              body:
                  'Blood Synergy\'s chatbot service at web.blood-synergy.com, which uses Google\'s Gemini API to generate educational responses. Data is not sold. Google processes this data under its Gemini API terms to provide the service and is required to protect it with safeguards appropriate to that service.',
            ),
            SizedBox(height: 10.h),
            _infoCard(
              title: 'How it is used',
              body:
                  'To authenticate your session and generate educational insights about lab patterns. Session chat/lab content is not retained by Blood Synergy after the session ends, except de-identified aggregates described in the Privacy Policy. Output can be wrong — always confirm with a clinician.',
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () => AppNavigator.navigateToPrivacyPolicy(context),
              child: Text(
                'Read Privacy Policy',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Medical sources used for educational content are also in Profile → Sources & Citations.',
              style: appTextTheme.giloryRegular12lightGrey,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _acceptConsent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(92, 174, 65, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Allow',
                  textAlign: TextAlign.center,
                  style: appTextTheme.gilorySemiBold16White
                      .copyWith(fontSize: 15.sp),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: _declineConsent,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromRGBO(50, 50, 50, 1),
                  side: const BorderSide(
                      color: Color.fromRGBO(180, 180, 180, 1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Don\'t Allow',
                  style: appTextTheme.gilorySemiBold16Black
                      .copyWith(fontSize: 15.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(245, 245, 245, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: appTextTheme.giloryBold12Black),
          SizedBox(height: 6.h),
          Text(
            body,
            style: appTextTheme.giloryMedium12Black.copyWith(height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildChatbotBody() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFFFFF8E7),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            'Educational only — not medical advice. Tap Sources for medical references. Chat answers may not list every citation inline.',
            style: appTextTheme.giloryMedium12Black.copyWith(
              fontSize: 11.sp,
              height: 1.3,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 6.0,
          ).r,
          child: Text(
            'Enter lab values manually or upload image results for research-style insights relevant to your patterns.',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12.sp,
            ),
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
    );
  }
}
