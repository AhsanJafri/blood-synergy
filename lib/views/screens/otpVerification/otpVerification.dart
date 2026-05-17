import 'package:blood_synergy_app/Cubits/signup_cubit/signup_cubit.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/apploader.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class otpVerificationScreen extends StatefulWidget {
  // const otpVerificationScreen({Key? key}) : super(key: key);
  String phone;
  bool fromForgotPassword = false;
  otpVerificationScreen(this.phone, this.fromForgotPassword);

  @override
  State<otpVerificationScreen> createState() => _otpVerificationScreenState();
}

class _otpVerificationScreenState extends State<otpVerificationScreen>
    with SingleTickerProviderStateMixin {
  bool tappedResend = true;
  // int endTime = DateTime.now().millisecondsSinceEpoch + 1500 * 60;
  int endTime = DateTime.now().millisecondsSinceEpoch + 800 * 60;
  String? otp;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onEnd() {
    if (mounted) {
      setState(() {
        tappedResend = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height * 0.1;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          EasyLoading.dismiss();
          if (state.signupResult is LoadingState) {
            EasyLoading.show(
                status: ((state.signupResult as LoadingState).msg));
          } else if (state.signupResult is RespSuccessState) {
            setState(() {
              endTime = DateTime.now().millisecondsSinceEpoch + 800 * 60;
            });
            AppLoader.showSnackbar(
                context,
                (state.signupResult as RespSuccessState).value.toString(),
                true);
          } else if (state.signupResult is RespSuccessAndNavigateState) {
            widget.fromForgotPassword
                ? AppNavigator.navigateToSetNewPassword(context)
                : AppNavigator.navigateToProfile(context);
          } else if (state.signupResult is RespErrorState) {
            // Handle error state, e.g., show an error message
            AppLoader.showSnackbar(
                context,
                (state.signupResult as RespErrorState).failure?.errorMessage ??
                    '',
                false);
          }
        },
        builder: (context, state) {
          return Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 35, left: 20).r,
                    height: 46.h,
                    width: 46.w,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                        borderRadius:
                            BorderRadius.all(const Radius.circular(30).w)),
                    child: Image.asset(
                      'assets/images/back.png',
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 25, right: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OTP Verification',
                        style: appTextTheme.giloryBold28WBlack,
                      ),
                      SizedBox(
                        height: 9.h,
                      ),
                      Text(
                        'Please enter 6-digit code we have sent you on your phone ${widget.phone}',
                        //  'Please enter 6-digit code we have sent you on your phone ${barnoliAppStateManager.showNum}',
                        style: appTextTheme.giloryRegular14lightGrey,

                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),

                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 35, left: 15, right: 15).r,
                      child: Container(
                        child: OTPTextField(
                          length: 6,
                          otpFieldStyle: OtpFieldStyle(
                              focusBorderColor:
                                  const Color.fromRGBO(92, 174, 65, 1),
                              borderColor:
                                  const Color.fromRGBO(218, 218, 218, 1),
                              backgroundColor: Colors.white),
                          width: 375.w,
                          fieldWidth: 50.w,
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: Colors.green,
                            fontFamily: "Gilory-Bold",
                            fontWeight: FontWeight.bold,
                          ),
                          textFieldAlignment: MainAxisAlignment.spaceBetween,
                          fieldStyle: FieldStyle.box,
                          onChanged: (c) {
                            print(c);
                          },
                          onCompleted: (pin) {
                            setState(() {
                              otp = pin;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 40).r,
                        child: Container(
                          height: 50.h,
                          width: 100.w,
                          decoration: const BoxDecoration(
                            //       border: Border.all(
                            //   width: 1.5,
                            //   color:Color.fromRGBO(235, 235, 235, 1),
                            // ),
                            color: Color.fromRGBO(243, 243, 243, 1),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Color(0xffe2e2e2),
                            //     offset: const Offset(
                            //       1.0,
                            //       1.0,
                            //     ),
                            //     blurRadius: 10.0,
                            //     spreadRadius: 2.0,
                            //   ), //BoxShadow

                            //   //BoxShadow
                            // ]),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AbsorbPointer(
                                  absorbing: tappedResend,
                                  child: InkWell(
                                    onTap: () {
                                      if (tappedResend == false) {
                                        print("hello");
                                        context.read<SignupCubit>().resentOTP();
                                      }
                                      // context.read<VerifyOTPBloc>().add(VerifyOTPResendCodeSubmitted());
                                    },
                                    child: Row(
                                      children: [
                                        // Text(
                                        //   'Resend in',
                                        //   style:
                                        //       appTextTheme.giloryRegular14lightGrey,
                                        // ),
                                        CountdownTimer(
                                          endTime: endTime,
                                          onEnd: onEnd,
                                          widgetBuilder: (contxt, time) {
                                            if (time != null) {
                                              return Text(
                                                  "Resend in ${time.sec.toString()}");
                                            }
                                            return const Text(
                                              "Resend",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ))),

                // SizedBox(
                //   width: 8,
                // ),
              ]);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          // Util.push(context, const ProfileSetupScreen());
          if (otp != null) {
            context.read<SignupCubit>().verifyOTP(otp);
          }
        },
        child: Container(
          width: 345.w,
          height: 50.h,

          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20).r,
          decoration: BoxDecoration(
            color: otp == null
                ? Colors.grey
                : const Color.fromRGBO(92, 174, 65, 1),
            borderRadius: BorderRadius.all(const Radius.circular(18).w),
          ),

          // color: Color.fromRGBO(156, 144, 145, 1),

          // boxShadow: [
          //   // BoxShadow(
          //   //   color: Color(0xffe2e2e2),
          //   //   offset: const Offset(
          //   //     1.0,
          //   //     1.0,
          //   //   ),
          //   //   // blurRadius: 1.0,
          //   //   // spreadRadius: 1.0,
          //   // ), //BoxShadow

          //   //BoxShadow
          // ]

          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Verify',
              style: appTextTheme.gilorySemiBold16White,
            ),
          ),
        ),
      ),
    );
  }

  void shouldClearAllTextFields() {}
}
