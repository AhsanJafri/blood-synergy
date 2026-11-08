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

  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final shortestSide =
      MediaQueryData.fromView(view).size.shortestSide;
  final isTablet = shortestSide >= 600;

  // Phones stay portrait; iPad can use portrait + landscape for readability.
  final orientations = isTablet
      ? <DeviceOrientation>[
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]
      : <DeviceOrientation>[DeviceOrientation.portraitUp];

  SystemChrome.setPreferredOrientations(orientations)
      .then((value) => runApp(MyApp(isTablet: isTablet)));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.isTablet = false}) : super(key: key);

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          Brightness.dark, // Change to Brightness.dark for dark icons
    ));
    return ScreenUtilInit(
        // Use a tablet-friendly design size so .w/.h/.sp don't overscale on iPad.
        designSize: isTablet ? const Size(768, 1024) : const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: MaterialApp(
              title: 'Blood Synergy',
              builder: (context, widget) {
                final easy = EasyLoading.init();
                final built = easy(context, widget) ?? const SizedBox.shrink();
                final width = MediaQuery.of(context).size.width;
                final tablet = width >= 600;
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(tablet ? 1.05 : 1.0),
                  ),
                  child: tablet
                      ? Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 720),
                            child: built,
                          ),
                        )
                      : built,
                );
              },
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                      cursorColor: Colors.black,
                      selectionHandleColor: Colors.green.shade400),
                  primarySwatch: Colors.blue,
                  primaryColor: Colors.green,
                  visualDensity: VisualDensity.adaptivePlatformDensity),

              home: const splashScreen(),
            ),
          );
        });
  }
}
