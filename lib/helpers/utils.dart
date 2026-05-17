
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../views/screens/widgets/dialougeWidget.dart';

class Util {
  static void pushAndRemoveUntil(BuildContext context, Widget newScreen) {
    Navigator.of(context).pushAndRemoveUntil(
      // the new route
      MaterialPageRoute(
        builder: (BuildContext context) => newScreen,
      ),
      (Route route) => false,
    );
  }

  static void push(BuildContext context, Widget newScreen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => newScreen),
    );
  }

  static String countryCodeToFlagEmoji(String countryCode) {
    if (countryCode == '') {
      return "";
    }
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    print(flag);
    return flag;
  }

  static void showBottomSheet(BuildContext context, Widget childWidget,
      double minHeight, double maxHeight,
      {bool enableDrag = true,
      bool isDismissable = true,
      Color backgroundColor = const Color.fromRGBO(251, 251, 251, 0.5),
      bool isFullScreen = false}) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: enableDrag,
        isDismissible: isDismissable,
        context: context,
        constraints: BoxConstraints(
          minHeight: minHeight,
          maxHeight:
              isFullScreen ? MediaQuery.of(context).size.height : maxHeight,
        ),
        barrierColor: backgroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (BuildContext context) {
          // return Padding(padding: EdgeInsets.only(
          //     bottom: MediaQuery.of(context).viewInsets.bottom),
          //   child: childWidget,
          //     );
          return childWidget;
        });
  }

  static String convertStringDateUsing(
      String dateString, String fromFormat, String toFormat, bool toLocal) {
    try {
      String newDT = "";
      if (toLocal == true) {
        newDT = DateFormat(fromFormat)
            .parse(dateString, toLocal)
            .toLocal()
            .toString();
      } else {
        newDT =
            DateFormat(fromFormat).parse(dateString, toLocal).toString();
      }
      var newDate = DateTime.parse(newDT.toString());
      var outputFormat = DateFormat(toFormat);
      var outputDate = outputFormat.format(newDate);
      return outputDate;
    } catch (e) {
      return dateString;
    }
  }

  static String formatedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  static void showToast(String msg, {bool? isError}) {
    print(msg);
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: isError != null ? Colors.redAccent : Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showTheBridgeLoader(String? message) {
    var m = message == '' ? 'loading' : message!;
    EasyLoading.instance.userInteractions = false;
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
    EasyLoading.show(
      status: m,
      indicator: const CircularProgressIndicator(),
    );
  }

  static void dimissTheBridgeLoader() {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.dismiss();
  }

  String convert1StringDateUsing(
      String dateString, String fromFormat, String toFormat) {
    try {
      String newDT = DateFormat(fromFormat)
          .parse(dateString, true)
          .toLocal()
          .toString();
      var newDate = DateTime.parse(newDT.toString());
      var outputFormat = DateFormat(toFormat);
      var outputDate = outputFormat.format(newDate);
      return outputDate;
    } catch (e) {
      return dateString;
    }
  }

  static String convertStringDateUsing2(
      String dateString, String fromFormat, String toFormat, bool toLocal) {
    try {
      String newDT = "";
      if (toLocal == true) {
        newDT = DateFormat(fromFormat)
            .parse(dateString, toLocal)
            .toLocal()
            .toString();
      } else {
        newDT =
            DateFormat(fromFormat).parse(dateString, toLocal).toString();
      }
      var newDate = DateTime.parse(newDT.toString());
      var outputFormat = DateFormat(toFormat);
      var outputDate = outputFormat.format(newDate);
      return outputDate;
    } catch (e) {
      return dateString;
    }
  }

  static DateTime convertToDateTime(String d) {
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");
    final newDate = format.parse(d);
    return newDate;
  }

  static String convertDateTimeToString() {
    final DateTime now = DateTime.now().toUtc();

    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(now);

    return now.toIso8601String();
  }

  // static Future<void> unauthenticatedUser(BuildContext context) async {
  //   await UserPref.removeUser();
  //   // ignore: use_build_context_synchronously
  //   //Util.pushAndRemoveUntil(context, LoginScreen());
  // }

  static bool isAndroid() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  static bool isIOS() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool urlIsSecure(Uri url) {
    return (url.scheme == "https") || Util.isLocalizedContent(url);
  }

  static bool isLocalizedContent(Uri url) {
    return (url.scheme == "file" ||
        url.scheme == "chrome" ||
        url.scheme == "data" ||
        url.scheme == "javascript" ||
        url.scheme == "about");
  }

  static void showDialog(BuildContext context, title, message) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
     // barrierColor: Colors.white.withOpacity(0.0),
     // transitionDuration: Duration(milliseconds: 0),
      pageBuilder: (_, __, ___) {
        return DialogWidget(title: title, message: message, );
      },
    );
  }
}

