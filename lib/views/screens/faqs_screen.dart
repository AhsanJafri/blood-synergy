import 'package:blood_synergy_app/helpers/utils.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen();

  static const _faqs = <Map<String, String>>[
    {
      'title': 'What is Blood Synergy?',
      'description':
          'Blood Synergy helps you track lab markers and explore educational wellness patterns. It is not a medical diagnosis tool and does not replace care from a licensed clinician.',
    },
    {
      'title': 'Is this medical advice?',
      'description':
          'No. Content in the app, including recommendations and the chatbot, is for educational purposes only. Always consult a qualified healthcare professional for medical decisions.',
    },
    {
      'title': 'What data do you collect?',
      'description':
          'We collect account details (such as name, email, and phone) and lab values you choose to enter. Optional profile photos or lab images may be uploaded if you select them. Sex/gender may be used because laboratory reference ranges can differ by sex. If you use the chatbot, you first consent to sharing messages, lab inputs/images, and related session data with Blood Synergy\'s service, which uses Google\'s Gemini API. Identifying details are removed before AI processing. See our Privacy Policy for full details.',
    },
    {
      'title': 'Where are medical Sources & Citations?',
      'description':
          'Open Profile → Sources & Citations. Citations also appear on Recommendations and after Pattern Results on a report. Chatbot → Sources opens the same references. Content is educational only, not medical advice.',
    },
    {
      'title': 'How do I delete my account?',
      'description':
          'Open Profile, then choose Delete account. This permanently removes your account and associated data from our systems, subject to any legal retention requirements.',
    },
    {
      'title': 'Where is the Privacy Policy?',
      'description':
          'Open Profile → Privacy Policy, or visit https://web.blood-synergy.com/privacy-policy.',
    },
    {
      'title': 'Are there in-app purchases?',
      'description':
          'No. Blood Synergy does not sell digital goods, subscriptions, or unlockable features through the iOS app.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0)
                      .r,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
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
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 24.h),
                itemCount: _faqs.length,
                itemBuilder: (context, index) {
                  final faq = _faqs[index];
                  return CustomExpansionTile(
                    title: faq['title']!,
                    description: faq['description']!,
                    backgroundColor: Colors.grey.shade100,
                    iconColor: const Color.fromRGBO(191, 30, 46, 1),
                    textColor: const Color.fromRGBO(50, 50, 50, 1),
                  );
                },
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              ExpansionTile(
                iconColor:
                    widget.iconColor ?? const Color.fromRGBO(191, 30, 46, 1),
                collapsedIconColor:
                    widget.iconColor ?? const Color.fromRGBO(191, 30, 46, 1),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
