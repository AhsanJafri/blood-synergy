import 'package:blood_synergy_app/helpers/env_config.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Termscondition extends StatefulWidget {
  final bool fromSignup;

  const Termscondition({Key? key, this.fromSignup = false}) : super(key: key);

  //  String? givenUrl;
  //  PrivacyPolicyScreen({super.key, required this.givenUrl});

  @override
  State<Termscondition> createState() => _PrivacyPolicyScreenState();
// _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<Termscondition> {
  late InAppWebViewController webViewController;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String? _htmlContent;
  String? _termsChoice; // 'accepted' | 'rejected' | null
  bool _prefsLoaded = false;
  bool _showWebViewAfterAccept = false;

  String get _termsUrl => '${EnvConfig.uploadBaseUrl}term-condition';

  @override
  void initState() {
    super.initState();
    _loadChoice();
    _loadTermsContent();
  }

  Future<void> _loadTermsContent() async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
      final response = await dio.get<String>(
        _termsUrl,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      if (!mounted) return;
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data!.trim().isNotEmpty) {
        setState(() {
          _htmlContent = response.data;
          isLoading = false;
          hasError = false;
          errorMessage = '';
        });
        return;
      }
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage =
            'Unable to load terms (HTTP ${response.statusCode ?? 'unknown'}).';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e is DioException
            ? (e.message ?? 'Network error')
            : e.toString();
      });
    }
  }

  Future<void> _loadChoice() async {
    final prefs = await SharedPreferences.getInstance();
    final choice = prefs.getString('terms_choice');
    setState(() {
      _termsChoice = choice;
      _prefsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0).r,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/images/backImgRed.png',
                      height: 46.h,
                      width: 46.w,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0).r,
                    child: Text(
                      'Terms & Conditions',
                      style: appTextTheme.gilorySemiBold16Black.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            
            // WebView Content
            Expanded(
              child: Stack(
                children: [
                  // If prefs haven't loaded yet, show loader
                  if (!_prefsLoaded)
                    Container(
                      color: Colors.white,
                      child: const Center(child: CircularProgressIndicator()),
                    ),

                  // If already accepted, show an informational screen
             

                  // If not accepted, show the webview (this covers null and 'rejected')
                  // if (_prefsLoaded && (_termsChoice != 'accepted' || _showWebViewAfterAccept))
                  if (_htmlContent != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: InAppWebView(
                        key: ValueKey(_htmlContent.hashCode),
                        initialData: InAppWebViewInitialData(
                          data: _htmlContent!,
                          mimeType: 'text/html',
                          encoding: 'utf-8',
                          baseUrl: WebUri(_termsUrl),
                        ),
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        initialSettings: InAppWebViewSettings(
                          javaScriptEnabled: true,
                          supportZoom: false,
                          displayZoomControls: false,
                          builtInZoomControls: false,
                          allowsInlineMediaPlayback: true,
                          mediaPlaybackRequiresUserGesture: false,
                          transparentBackground: true,
                        ),
                        onLoadStart: (controller, url) {
                          setState(() {
                            isLoading = true;
                            hasError = false;
                          });
                        },
                        onLoadStop: (controller, url) async {
                          setState(() {
                            isLoading = false;
                          });

                          // Inject CSS to hide headers, footers, and other unwanted elements
                          await controller.evaluateJavascript(source: '''
                            // Hide common header and footer elements
                            var style = document.createElement('style');
                            style.innerHTML = `
                              header, 
                              footer, 
                              nav, 
                              .header,
                              .footer,
                              .navigation,
                              .nav,
                              .navbar,
                              .site-header,
                              .site-footer,
                              .page-header,
                              .page-footer,
                              .top-bar,
                              .bottom-bar,
                              .menu,
                              .breadcrumb,
                              .sidebar,
                              .ads,
                              .advertisement,
                              .banner,
                              .social-media,
                              .share-buttons,
                              .related-posts,
                              .comments,
                              .comment-section,
                              [role="navigation"],
                              [role="banner"],
                              [role="contentinfo"],
                              [class*="header"],
                              [class*="footer"],
                              [class*="nav"],
                              [class*="menu"],
                              [id*="header"],
                              [id*="footer"],
                              [id*="nav"],
                              [id*="menu"] {
                                display: none !important;
                                visibility: hidden !important;
                                height: 0 !important;
                                margin: 0 !important;
                                padding: 0 !important;
                              }
                              
                              body {
                                margin: 0 !important;
                                padding: 10px !important;
                                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif !important;
                              }
                              
                              main, 
                              .main, 
                              .content, 
                              .post-content,
                              .entry-content,
                              .article-content,
                              [role="main"] {
                                margin: 0 !important;
                                padding: 0 !important;
                                max-width: 100% !important;
                              }
                              
                              h1, h2, h3, h4, h5, h6 {
                                color: #333 !important;
                                margin-top: 20px !important;
                                margin-bottom: 10px !important;
                              }
                              
                              p, li, div {
                                color: #555 !important;
                                line-height: 1.6 !important;
                                margin-bottom: 15px !important;
                              }
                              
                              a {
                                color: #007bff !important;
                                text-decoration: none !important;
                              }
                              
                              a:hover {
                                text-decoration: underline !important;
                              }
                            `;
                            document.head.appendChild(style);
                            
                            // Additional cleanup for any remaining unwanted elements
                            setTimeout(function() {
                              var unwantedElements = document.querySelectorAll('iframe, script, .ad, .ads, .advertisement, [class*="social"], [class*="share"]');
                              unwantedElements.forEach(function(element) {
                                if (element && element.parentNode) {
                                  element.parentNode.removeChild(element);
                                }
                              });
                            }, 1000);
                          ''');
                        },
                        onLoadError: (controller, url, code, message) {
                          setState(() {
                            isLoading = false;
                            hasError = true;
                            errorMessage = message;
                          });
                        },
                        onLoadHttpError: (controller, url, statusCode, description) {
                          setState(() {
                            isLoading = false;
                            hasError = true;
                            errorMessage = 'HTTP Error $statusCode: $description';
                          });
                        },
                      ),
                    ),

                  // If the user is viewing the webview after accepting, show a small Done button to return
                  if (_showWebViewAfterAccept)
                    Positioned(
                      top: 12,
                      right: 20,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () {
                          setState(() {
                            _showWebViewAfterAccept = false;
                          });
                        },
                        child: const Text('Done', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  
                  // Loading Indicator
                  if (isLoading)
                    Container(
                      color: Colors.white,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(207, 27, 33, 1),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading Terms & Conditions...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  // Error State
                  if (hasError && !isLoading)
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load Terms & Conditions',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                errorMessage.isNotEmpty 
                                    ? errorMessage 
                                    : 'Please check your internet connection and try again.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                    hasError = false;
                                    errorMessage = '';
                                    _htmlContent = null;
                                  });
                                  await _loadTermsContent();
                                },
                                icon: const Icon(Icons.refresh, color: Colors.white),
                                label: const Text(
                                  'Try Again',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(207, 27, 33, 1),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        

      ),
      bottomNavigationBar: 
      
            (_prefsLoaded &&
                    _termsChoice == 'accepted' &&
                    !_showWebViewAfterAccept &&
                    !widget.fromSignup) ==
                true
                    ? Container(
                      color: Colors.white,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline, size: 64, color: Colors.green[600]),
                              const SizedBox(height: 16),
                              Text(
                                "You've already accepted the Terms & Conditions",
                                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Thank you. You can close this screen.',
                                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                          
                                    child: const Text('Close', style: TextStyle(color: Colors.black)),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    onPressed: () {
                                      // Show the webview while keeping the accepted state
                                      setState(() {
                                        _showWebViewAfterAccept = true;
                                      });
                                    },
                                    child: const Text('View Terms', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ):
       SafeArea(
                  minimum: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 38.h,
                          child: OutlinedButton(
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('terms_choice', 'rejected');
                              Navigator.of(context).pop(false);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color.fromRGBO(207, 27, 33, 1),
                              side: const BorderSide(color: Color.fromRGBO(207, 27, 33, 1)),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            ),
                            child: Text('Reject', style: TextStyle(fontSize: 16.sp, color: const Color.fromRGBO(207, 27, 33, 1))),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: SizedBox(
                          height: 38.h,
                          child: ElevatedButton(
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('terms_choice', 'accepted');
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            ),
                            child: Text('Accept', style: TextStyle(fontSize: 16.sp)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
