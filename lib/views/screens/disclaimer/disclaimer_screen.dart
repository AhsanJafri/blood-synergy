import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../themes/textTheme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisclaimerScreen extends StatefulWidget {
  @override
  _DisclaimerScreenState createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  late InAppWebViewController webViewController;
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disclaimer!"),
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(
                      "https://web.blood-synergy.com/disclaimer.php"),
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
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                Checkbox(
                  value: isAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      isAccepted = value ?? false;
                    });
                  },
                  activeColor: Color.fromRGBO(92, 174, 65, 1),
                ),
                Expanded(
                  child: Text(
                    'I have read and accept the disclaimer',
                    style: appTextTheme.giloryMedium14BlackTheme,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(child: declineBtn(context)),

                // SizedBox(width: 20.w), // Adds space between buttons
                Expanded(child: continuebtn(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget continuebtn(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: isAccepted ? () async {
        await UserPref.firstLoad(false);
        AppNavigator.navigateToDashboard(context);
      } : null,
      child: Container(
        width: 345.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: isAccepted 
              ? Color.fromRGBO(92, 174, 65, 1)
              : Color.fromRGBO(92, 174, 65, 0.5),
          borderRadius: BorderRadius.all(Radius.circular(18.w)),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'I Agree',
            style: appTextTheme.gilorySemiBold16White,
          ),
        ),
      ),
    );
  }

  Widget declineBtn(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 345.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Color.fromRGBO(246, 22, 63, 1),
          borderRadius: BorderRadius.all(Radius.circular(18.w)),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Decline',
            style: appTextTheme.gilorySemiBold16White,
          ),
        ),
      ),
    );
  }
}
