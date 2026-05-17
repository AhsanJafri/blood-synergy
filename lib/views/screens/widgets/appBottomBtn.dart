import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class AppBottomButton extends StatelessWidget {
  AppBottomButton(
      {required this.text,
      required this.onPressed,
      this.fontSize = 12.0,
      this.width = 143.0,
      this.height = 30.0,
      this.fontColorDarkTheme,
      this.fontColorLightTheme,
      this.radius = 0});

  String text;
  double? fontSize;
  double? width;
  double? height;
  Color? fontColorDarkTheme;
  Color? fontColorLightTheme;
  Function()? onPressed;
  double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.w,
      height: height?.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius).r),
      ),
      child: SizedBox(
        height: 51,
        width: 345,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(92, 174, 65, 1),
            // backgroundColor:
            //     MaterialStateProperty.all(),
          ),
          child: Text(
            "text",
            style: TextStyle(
              fontFamily: "Gilroy-Bold",
              fontWeight: FontWeight.bold,
              fontSize: fontSize?.sp,
              color: fontColorLightTheme,
            ),
          ),
        ),
      ),
    );
  }
}
