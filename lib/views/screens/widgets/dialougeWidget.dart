import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:blood_synergy_app/views/screens/widgets/appBottomBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class DialogWidget extends StatelessWidget {
  DialogWidget({required this.title, required this.message});

  String title;
  String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.0),
      body: Center(
        child: Container(
          height: 282.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(22.r)),
            color: const Color.fromRGBO(26, 20, 29, 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          margin: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          title,
                        )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "assets/images/cross_grey.png",
                            fit: BoxFit.fill,
                            width: 14.w,
                            height: 14.h,
                            color: const Color.fromRGBO(202, 202, 202, 1),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(message, style: appTextTheme.gilorySemiBold16White),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppBottomButton(
                          text: 'Yes',
                          width: double.infinity,
                          height: 50.h,
                          radius: 18,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text('No',
                            style: appTextTheme.gilorySemiBold16White),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
