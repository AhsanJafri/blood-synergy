import 'package:blood_synergy_app/Cubits/update_password_cubit/update_password_cubit.dart';
import 'package:blood_synergy_app/Repositories/AuthenticationRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/apploader.dart';
import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';

class SetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context) => UpdatePasswordCubit(
          AuthenticationRepository(NetworkClient(Client(), dio: Dio()))),
      child: SetPasswordScreen_Widget(),
    );
  }
}

class SetPasswordScreen_Widget extends StatefulWidget {
  @override
  State<SetPasswordScreen_Widget> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen_Widget> {
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isobscure = true;

  bool _isobscureConfirmPass = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15).r,
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: BlocConsumer<UpdatePasswordCubit, UpdatePasswordState>(
                  listener: (context, state) {
                    // TODO: implement listener
                    EasyLoading.dismiss();
                    if (state.result is LoadingState) {
                      EasyLoading.show(
                          status: (state.result as LoadingState).msg);
                    } else if (state.result is RespErrorState) {
                      AppLoader.showSnackbar(
                          context,
                          (state.result as RespErrorState)
                                  .failure
                                  ?.errorMessage ??
                              'Unknow Error Occured',
                          false);
                    } else if (state.result is RespSuccessAndNavigateState) {
                      AppLoader.showSnackbar(
                          context, 'Password updated successfully', true);
                      Future.delayed(Duration(seconds: 2), () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        Navigator.pop(context);
                      });
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'Set New Password',
                          style: appTextTheme.giloryBold28WBlack,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),

                        Text(
                          'Please enter your new password',
                          style: appTextTheme.giloryMedium14lightGrey,
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          'Set New Password',
                          style: appTextTheme.giloryBold15Black,
                        ),
                        Container(
                          height: 50.h,
                          margin:
                              const EdgeInsets.only(left: 0, right: 0, top: 24)
                                  .r,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(243, 243, 243, 1),
                            borderRadius: BorderRadius.all(
                              const Radius.circular(12.0).w,
                            ),
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
                            // ]
                          ),
                          child: TextField(
                            obscureText: _isobscure,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              // labelText: 'Yards',
                              // floatingLabelStyle: TextStyle(
                              //   color: Color.fromRGBO(73, 162, 237, 1)
                              // ),
                              hintText: 'Password',
                              hintStyle: appTextTheme.giloryMedium14lightGrey,

                              suffixIcon: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 15.0.r,
                                    top: 10.r,
                                    end: 15.r,
                                    bottom: 10.r),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isobscure = !_isobscure;
                                    });
                                  },
                                  child: _isobscure
                                      ? Image.asset(
                                          'assets/images/eyeHide.png',
                                          color: Colors.black,
                                          height: 8.h,
                                          width: 12.w,
                                        )
                                      : Image.asset(
                                          'assets/images/eyeHide.png',
                                          color: Colors.black,
                                          height: 8.h,
                                          width: 12.w,
                                        ),
                                ),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20).w,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0.w,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).w,
                                borderSide: BorderSide(
                                  color: const Color.fromRGBO(92, 174, 65, 1),
                                  // color:Color.fromRGBO(73, 162, 237, 1),
                                  width: 1.0.w,
                                ),
                              ),
                            ),

                            // onChanged: (value) => context.read<LoginBloc>().add(
                            //   LoginPasswordChanged(password: value)
                            // ),
                          ),
                        ),

                        Container(
                          height: 50.h,
                          margin: const EdgeInsets.only(top: 10).r,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(243, 243, 243, 1),
                            borderRadius: BorderRadius.all(
                              const Radius.circular(12.0).w,
                            ),
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
                            // ]
                          ),
                          child: TextField(
                            obscureText: _isobscureConfirmPass,
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              // labelText: 'Yards',
                              // floatingLabelStyle: TextStyle(
                              //   color: Color.fromRGBO(73, 162, 237, 1)
                              // ),
                              hintText: 'Confirm Password',
                              hintStyle: appTextTheme.giloryMedium14lightGrey,

                              suffixIcon: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 15.0.r,
                                    top: 10.r,
                                    end: 15.r,
                                    bottom: 10.r),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isobscureConfirmPass =
                                          !_isobscureConfirmPass;
                                    });
                                  },
                                  child: _isobscureConfirmPass
                                      ? Image.asset(
                                          'assets/images/eyeHide.png',
                                          color: Colors.black,
                                          height: 8.h,
                                          width: 12.w,
                                        )
                                      : Image.asset(
                                          'assets/images/eyeHide.png',
                                          color: Colors.black,
                                          height: 8.h,
                                          width: 12.w,
                                        ),
                                ),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20).w,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0.w,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).w,
                                borderSide: BorderSide(
                                  color: const Color.fromRGBO(92, 174, 65, 1),
                                  // color:Color.fromRGBO(73, 162, 237, 1),
                                  width: 1.0.w,
                                ),
                              ),
                            ),

                            // onChanged: (value) => context.read<LoginBloc>().add(
                            //   LoginPasswordChanged(password: value)
                            // ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: const Icon(Icons.brightness_1, size: 5.0),
                            ),
                            SizedBox(width: 8.0.w),
                            Flexible(
                              child: Text(
                                'Password needs to be 7 - 12 characters long including at least 1 symbol and 1 uppercase letter',
                                style: appTextTheme.giloryRegular12lightGrey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: Icon(Icons.brightness_1, size: 5.0),
                            ),
                            SizedBox(width: 8.0.w),
                            Flexible(
                              child: Text(
                                'A combination of uppercase letters, lowercase letters, numbers, and symbols.',
                                style: appTextTheme.giloryRegular12lightGrey,
                              ),
                            ),
                          ],
                        ),
                        //  Spacer(),

                        SizedBox(height: 20.0.h),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            // Util.push(context, otpVerificationScreen('SignUp'));

            context.read<UpdatePasswordCubit>().setPassword(
                password: _passwordController.text,
                confirmPassword: _confirmPasswordController.text);
          },
          child: Container(
            width: 345.w,
            height: 50.h,

            margin: const EdgeInsets.only(top: 40, left: 20, right: 20).r,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(92, 174, 65, 1),
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
                'Continue',
                style: appTextTheme.gilorySemiBold16White,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
