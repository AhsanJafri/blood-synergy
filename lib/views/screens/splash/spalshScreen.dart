import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen>
    with SingleTickerProviderStateMixin {
  bool showGetStartedBtn = false;
  bool userExists = false;
  @override
  void initState() {
    super.initState();

    checkCond();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 156.w, //MediaQuery.of(context).size.width,
              height: 163.h,

              ///MediaQuery.of(context).size.height,

              child: Image.asset(
                'assets/images/splashLog.png',
                fit: BoxFit.fill,
                //  height: 50,
                //  width: 40,
              ),
            ),
          ),

          //     Padding(
          //       padding: const EdgeInsets.only(bottom: 15),
          //       child: Align(
          //    alignment: Alignment.center,
          //   child: Container(
          //         width: 250,
          //         height: 60,

          //       child: Image.asset('assets/images/splashMidImage.png',
          //        fit: BoxFit.fill,
          //       ),

          //   ),
          // ),
          //     ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 15, left: 15).r,
        child: SizedBox(
          width: 345,
          height: 51,
          child: Visibility(
            visible: showGetStartedBtn,
            child: ElevatedButton(
              onPressed: () {
                userExists
                    ? AppNavigator.navigateToDashboard(context)
                    : AppNavigator.navigateToLogin(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(92, 174, 65, 1)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              child: Text('Get Started',
                  style: appTextTheme.gilorySemiBold16White),
            ),
          ),
        ),
      ),
    );
  }

  //  AppBottomButton(
  //                         text: 'Get Started',
  //                         width: 345,
  //                         height: 50,
  //                         radius: 18,
  //                         onPressed: (){
  //                           // Navigator.pop(context);
  //                         }
  //                     ),

  Future<void> checkCond() async {
    userExists = await UserPref.isLogin();
    setState(() {
      showGetStartedBtn = true;
    });
  }
}
