import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'views/screens/splash/spalshScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await UserPref.initPrefs();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          Brightness.dark, // Change to Brightness.dark for dark icons
    ));
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (BuildContext context, Widget? child) {
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: MaterialApp(
              title: 'Flutter Demo',
              builder: EasyLoading.init(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                      cursorColor: Colors.black,
                      selectionHandleColor: Colors.green.shade400),
                  primarySwatch: Colors.blue,
                  primaryColor: Colors.green),

              home: const splashScreen(),
              // home: tripSeccessfulPopup(onTapOK: () {
              //       print('OK');
              // },
              // )  //bottomPopup(false , false, false, 'sdsdsd', 'dsdcdd', 'Greane Maxwell', 'dcdccd', 'cdcd', true, 'cdcdcdc', '420.00', false, '4.0', false)
              //SplashScreen(),
            ),
          );
        });
  }
}
