import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  //  String? givenUrl;
  //  PrivacyPolicyScreen({super.key, required this.givenUrl});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
// _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late InAppWebViewController webViewController;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

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
                      'Privacy Policy',
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: WebUri("https://bloodsynergybackend.trangotech.dev/privacy-policy"),
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
                              'Loading Privacy Policy...',
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
                                'Failed to load Privacy Policy',
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
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                    hasError = false;
                                    errorMessage = '';
                                  });
                                  webViewController.reload();
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
    );
  }
}
