import 'package:blood_synergy_app/helpers/utils.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen();
  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
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
                      'FAQ\'s',
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
                        url: WebUri("https://bloodsynergybackend.trangotech.dev/faqs"),
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
                              'Loading FAQs...',
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
                                'Failed to load FAQs',
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

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    required this.title,
    required this.description,
    this.isHTML,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  final String title;
  final String description;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool? isHTML;
  final Color? textColor;

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Card(
        color: Colors.grey.shade100,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        margin: const EdgeInsets.only(top: 10, left: 6, right: 6),
        child: Theme(
          data: ThemeData(
            dividerColor: Colors.transparent,
            splashFactory: InkRipple.splashFactory,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Stack(
            children: [
              // Add the color overlay for collapsed state
              // if (!_isExpanded)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 50, // Set the height of the colored area
                child: Container(
                  // Set the collapsed color
                  decoration: BoxDecoration(
                      color: widget.backgroundColor ?? Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              ExpansionTile(
                iconColor:
                    widget.iconColor ?? const Color.fromRGBO(191, 30, 46, 1),
                collapsedIconColor:
                    widget.iconColor ?? const Color.fromRGBO(191, 30, 46, 1),
                //minTileHeight: 48,
                title: Text(
                  widget.title,
                  style: appTextTheme.giloryBold12Black.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1,
                    color: widget.textColor ?? Colors.black54,
                  ),
                ),
                children: <Widget>[
                  ListTile(
                    title: widget.isHTML == true
                        ? Html(
                            data: widget.description,
                            // style: {
                            //   "body": Style(
                            //     color: Colors.black, // Change text color here
                            //   ),
                            //   "a": Style(
                            //     color: Colors.black, // Change link color here
                            //   ),
                            // },
                            onAnchorTap: (url, attributes, element) async {
                              if (url?.isEmpty == true) {
                                Util.showToast(
                                    'Link address is not available!');
                              } else {
                                final Uri uri = Uri.parse(url!);
                                if (!await launchUrl(uri)) {
                                  Util.showToast(
                                      'Link address is not available!');
                                }
                              }
                            },
                            onLinkTap: (url, attributes, element) async {
                              if (url?.isEmpty == true) {
                                Util.showToast(
                                    'Link address is not available!');
                              } else {
                                final Uri uri = Uri.parse(url!);
                                if (!await launchUrl(uri)) {
                                  Util.showToast(
                                      'Link address is not available!');
                                }
                              }
                            },
                          )
                        : Text(
                            widget.description,
                            style: appTextTheme.giloryBold12Black.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: widget.textColor ?? Colors.black54,
                              letterSpacing: 0.9,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    // Handle expansion state if needed
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
