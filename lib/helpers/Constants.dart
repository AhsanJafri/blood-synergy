import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Constants {
  var bottomWidgetKey = new GlobalKey<State<BottomNavigationBar>>();
  static GlobalKey bottomNavGlobalKey = new GlobalKey();

  static GlobalKey<ScaffoldState> scaffoldGlobalKey =
      GlobalKey<ScaffoldState>();
  static String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2Jsb29kc3luZXJneWJhY2tlbmQudHJhbmdvdGVjaC5kZXYvYXBpL2N1c3RvbWVyL2xvZ2luIiwiaWF0IjoxNzAzNTkwNjk4LCJuYmYiOjE3MDM1OTA2OTgsImp0aSI6IlMwY3Znb3VDMWVZMXM2Q3YiLCJzdWIiOiIyMCIsInBydiI6IjFkMGEwMjBhY2Y1YzRiNmM0OTc5ODlkZjFhYmYwZmJkNGU4YzhkNjMifQ.8HuNdLXG8DpfVR5zSrL6XLrllQOxYmXTLgAm1CFr4UU";

  static String placeHolderImage =
      'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=';

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
