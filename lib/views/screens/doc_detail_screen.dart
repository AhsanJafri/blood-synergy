import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocDetailScreen extends StatefulWidget {
  const DocDetailScreen({Key? key}) : super(key: key);

  //  String? givenUrl;
  //  PrivacyPolicyScreen({super.key, required this.givenUrl});

  @override
  State<DocDetailScreen> createState() => _DocDetailScreenState();
// _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _DocDetailScreenState extends State<DocDetailScreen> {
  // WebViewController controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setBackgroundColor(const Color(0x00000000))
  //   ..setNavigationDelegate(
  //     NavigationDelegate(
  //       onProgress: (int progress) {
  //         // AppLoader.showLoader('');
  //       },
  //       onPageStarted: (String url) {},
  //       onPageFinished: (String url) {},
  //       onWebResourceError: (WebResourceError error) {},
  //       onNavigationRequest: (NavigationRequest request) {
  //         if (request.url.startsWith(
  //             'https://www.termsfeed.com/live/1cf48a33-c5a4-4565-85fe-393d80aee7d3')) {
  //           return NavigationDecision.prevent;
  //         }
  //         return NavigationDecision.navigate;
  //       },
  //     ),
  //   )
  //   ..loadRequest(Uri.parse(
  //       'https://www.termsfeed.com/live/1cf48a33-c5a4-4565-85fe-393d80aee7d3'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: CustomAppBar(
      //   backgroundColor: secondaryDarkColor,
      //   centerTitle: true,
      //   title: Text(
      //     'Privacy Policy',
      //     style: AppTheme.bottomsheetTitleText,
      //     textAlign: TextAlign.center,
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
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
                        'Details',
                        style: appTextTheme.gilorySemiBold16Black.copyWith(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                        height: MediaQuery.of(context).size.width / 4,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                            color: Colors.transparent
                            // borderRadius:
                            //     BorderRadius.all(const Radius.circular(30).w),
                            ),
                        child: Container(
                          width: 60.0, // Set the width of the circle
                          height: 60.0, // Set the height of the circle
                          decoration: const BoxDecoration(
                            shape:
                                BoxShape.circle, // Make the container circular
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/dummy_doc_image.png'),
                              fit: BoxFit
                                  .contain, // Ensure the image covers the circle
                            ),
                          ),
                        )
                        // AppNetworkImage(
                        //   // isProfile: true,
                        //   path: item.image,
                        //   isCircular: true,
                        // ),
                        ),
                    Padding(
                      padding: const EdgeInsets.only(
                              top: 5, left: 5, right: 5, bottom: 0)
                          .r,
                      child: Text(
                        'Dr. Brandon Brock',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: appTextTheme.giloryBold12Black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                              top: 2.5, left: 5, right: 5, bottom: 0)
                          .r,
                      child: Text(
                        'Texas',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: appTextTheme.giloryRegular14lightGrey
                            .copyWith(fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Dr. Brandon Brock is a clinician in Dallas Texas who holds a Doctorate in Family Nursing Practice from Duke University and is currently doing Ph.D. studies. He has also completed a specialization in orthopedics From Duke University and also has specialized fellowship training in regenerative medicine.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontFamily: 'Gilroy-Regular',
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        letterSpacing: 0.41,
                      ),
                    ),

                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: const [
                          TextSpan(
                            text: 'Education:\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          TextSpan(
                            text:
                                '• Ph.D Graduate: Texas Woman\'s University\n',
                          ),
                          TextSpan(
                            text:
                                '• Doctorate in Nursing Practice: Duke University\n',
                          ),
                          TextSpan(
                            text:
                                '• Doctorate in Chiropractic: Parker University\n',
                          ),
                          TextSpan(
                            text:
                                '• Advanced Practice Registered Nurse: Texas\n',
                          ),
                          TextSpan(
                            text:
                                '• Family Nurse Practitioner: Samford University\n',
                          ),
                          TextSpan(
                            text:
                                '• Orthopedic Nurse Practitioner: Duke University\n',
                          ),
                          TextSpan(
                            text: '• Masters in Science: Nursing Practice\n',
                          ),
                          TextSpan(
                            text:
                                '• Bachelor of Science in Nursing: Hardin Simmons University\n',
                          ),
                          TextSpan(
                            text:
                                '• Bachelor of Science in Anatomy: Parker University\n',
                          ),
                          TextSpan(
                            text:
                                '• Global Clinical Research Scholar: Harvard Medical School\n',
                          ),
                          TextSpan(
                            text:
                                '• Stem Cell and Regenerative Medicine Fellowship Training: A4M\n',
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   'Dr. Brandon Brock is a clinician in Dallas Texas who holds a Doctorate in Family Nursing Practice from Duke University and is currently doing Ph.D. studies. He has also completed a specialization in orthopedics From Duke University and also has specialized fellowship training in regenerative medicine.',
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 12.sp,
                    //     fontFamily: 'Gilroy-Regular',
                    //     fontWeight: FontWeight.bold,
                    //     height: 1.4,
                    //     letterSpacing: 0.41,
                    //   ),
                    // ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Brock Integrative Medicine \n15150 Preston Road Suite 300, Room 21\nDallas, Texas 75248\nwww.DrBrock.com\nPhone: 214-704-6537\nmail: BIM@drbrock.com',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: 'Gilroy-Regular',
                          fontWeight: FontWeight.w300,
                          height: 1.4,
                          letterSpacing: 0.41,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded(child: WebViewWidget(controller: (controller))),
            ],
          ),
        ),
      ),
    );
  }
}
