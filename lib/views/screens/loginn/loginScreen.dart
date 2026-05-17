import 'package:blood_synergy_app/Cubits/login_cubit/login_cubit.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/apploader.dart';
import 'package:blood_synergy_app/helpers/countryPickerTextField.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isobscure = true;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var countryPhoneCode = '+1';
  // RemoteDataSource _apiResponce = RemoteDataSource();
  var isCalled = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(context) {
    // final loginCubit = BlocProvider.of<LoginCubit>(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginScreenStates) {
          print("Listening in login");

          EasyLoading.dismiss();
          // Handle state changes here
          if (state.loginResult is LoadingState) {
            // Show EasyLoader when the state is loading
            // You can customize this part based on your EasyLoader implementation
            EasyLoading.show(
                status: (state.loginResult as LoadingState).msg ?? '');
          } else if (state.loginResult is RespSuccessState) {
            // Handle success state, e.g., navigate to the next screen
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => NextScreen()),
            // );
            AppNavigator.navigateToDisclaimer(context);
          } else if (state.loginResult is RespErrorState) {
            // Handle error state, e.g., show an error message
            if (!isCalled) {
              isCalled = true;
              AppLoader.showSnackbar(
                  context,
                  (state.loginResult as RespErrorState).failure?.errorMessage ??
                      '',
                  false);
            }
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60).r,
                      child: Image.asset(
                        'assets/images/splashLog.png',
                        height: 142.h,
                        width: 135.w,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22, top: 30).r,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: appTextTheme.giloryBold32WhiteBlack,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8).r,
                            child: Text('Welcome back! You’ve been missed!',
                                style: appTextTheme.giloryRegular14lightGrey),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                // Container(
                //   height: 51.h,
                //   width: 345.w,
                //   margin: const EdgeInsets.only(left: 15, right: 15, top: 20).r,
                //   decoration: BoxDecoration(
                //     color: const Color.fromRGBO(243, 243, 243, 1),
                //     borderRadius: BorderRadius.all(
                //       const Radius.circular(12.0).w,
                //     ),
                //     // boxShadow: [
                //     //   BoxShadow(
                //     //     color: Color(0xffe2e2e2),
                //     //     offset: const Offset(
                //     //       1.0,
                //     //       1.0,
                //     //     ),
                //     //     blurRadius: 10.0,
                //     //     spreadRadius: 2.0,
                //     //   ), //BoxShadow

                //     //   //BoxShadow
                //     // ]
                //   ),
                //   child: TextField(
                //     obscureText: false,
                //     controller: _nameController,
                //     decoration: InputDecoration(
                //       // labelText: 'Yards',
                //       // floatingLabelStyle: TextStyle(
                //       //   color: Color.fromRGBO(73, 162, 237, 1)
                //       // ),
                //       hintText: 'Phone Number/Email',
                //       hintStyle: appTextTheme.giloryMedium14lightGrey,

                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(20).w,
                //         borderSide: BorderSide(
                //           color: Colors.transparent,
                //           width: 1.0.w,
                //         ),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10).w,
                //         borderSide: BorderSide(
                //           color: const Color.fromRGBO(92, 174, 65, 1),
                //           // color:Color.fromRGBO(73, 162, 237, 1),
                //           width: 1.0.w,
                //         ),
                //       ),
                //     ),

                //     // onChanged: (value) => context.read<LoginBloc>().add(
                //     //   LoginPasswordChanged(password: value)
                //     // ),
                //   ),
                // ),

                Container(
                  height: 50.h,
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 10).r,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(243, 243, 243, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
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
                    // ]),
                  ),

                  child: SizedBox(
                    height: 57.h,
                    child: AppCountryInputTextField(
                      hintLabel: 'Mobile Number',
                      imageName: '',
                      shouldObscure: false,
                      imgWidth: 24,
                      imgHeight: 24,
                      myController: _phoneNumberController,
                      onCountryChanged: (code) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            countryPhoneCode = code;
                          });
                        });
                      },
                    ),
                  ),
                  // ),
                ),

                Container(
                  height: 50.h,
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 24).r,
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
                            start: 15.0.r, top: 10.r, end: 15.r, bottom: 10.r),
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
                  margin: const EdgeInsets.only(left: 27, right: 27, top: 21).r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          var cubit = BlocProvider.of<LoginCubit>(context);
                          AppNavigator.navigateToForgotPassword(context, cubit);
                          //  Util.push(context, ForgetPasswordScreen());
                          //  context.read<AuthCubit>().showForgotPassword();
                          //  util.push(context,  recoverPasswordScreen());
                          // util.push(context, selectServiceScreen());
                        },
                        child: Container(
                          child: Text('Recover Password?',
                              style: appTextTheme.giloryMedium14lightGrey),
                        ),
                      ),
                    ],
                  ),
                ),

                //  SizedBox(
                //    height: 8,
                //  ),

                //   SizedBox(
                //    height: 8,
                //  ),

                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    isCalled = false;
                    context.read<LoginCubit>().login(
                          username:
                              countryPhoneCode + _phoneNumberController.text,
                          password: _passwordController.text,
                        );
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => SetPasswordScreen())));
                    // Util.pushAndRemoveUntil(context, const HomeScreen());
                  },
                  child: Container(
                    width: 345.w,
                    height: 50.h,

                    margin:
                        const EdgeInsets.only(top: 24, left: 15, right: 15).r,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(92, 174, 65, 1),
                      borderRadius:
                          BorderRadius.all(const Radius.circular(18).w),
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
                        'Sign In',
                        style: appTextTheme.gilorySemiBold16White,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(top: 28, left: 50, right: 50).r,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: 2.h,
                          width: 67.w,
                          color: const Color.fromRGBO(181, 181, 181, 1)),
                      Text('Or continue with',
                          style: appTextTheme.giloryMedium14lightGrey),
                      Container(
                          height: 2.h,
                          width: 67.w,
                          color: const Color.fromRGBO(181, 181, 181, 1))
                    ],
                  ),
                ),

                // Padding(
                //   padding:
                //       const EdgeInsets.only(top: 25, left: 42, right: 42).r,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         width: 70.w,
                //         height: 60.h,
                //         decoration: BoxDecoration(
                //           color: const Color.fromRGBO(243, 243, 243, 1),
                //           borderRadius:
                //               BorderRadius.all(const Radius.circular(12).w),
                //           //  boxShadow: [
                //           //    BoxShadow(
                //           //      color: Colors.grey.withOpacity(0.5),
                //           //      spreadRadius: 3,
                //           //      blurRadius: 7,
                //           //      offset: Offset(0, 3), // changes position of shadow
                //           //    ),
                //           //  ],
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(5.0).w,
                //           child: Image.asset(
                //             'assets/images/googleLogin.png',
                //           ),
                //         ),
                //       ),
                //       Container(
                //         width: 70.w,
                //         height: 60.h,
                //         decoration: BoxDecoration(
                //           color: const Color.fromRGBO(243, 243, 243, 1),
                //           borderRadius:
                //               BorderRadius.all(const Radius.circular(12).w),
                //           //  boxShadow: [
                //           //    BoxShadow(
                //           //      color: Colors.grey.withOpacity(0.5),
                //           //      spreadRadius: 3,
                //           //      blurRadius: 7,
                //           //      offset: Offset(0, 3), // changes position of shadow
                //           //    ),
                //           //  ],
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(16.0).w,
                //           child: Image.asset(
                //             'assets/images/appleLogin.png',
                //           ),
                //         ),
                //       ),
                //       Container(
                //         width: 70.w,
                //         height: 60.h,
                //         decoration: BoxDecoration(
                //           color: const Color.fromRGBO(243, 243, 243, 1),
                //           borderRadius:
                //               BorderRadius.all(const Radius.circular(12).w),
                //           //  boxShadow: [
                //           //    BoxShadow(
                //           //      color: Colors.grey.withOpacity(0.5),
                //           //      spreadRadius: 3,
                //           //      blurRadius: 7,
                //           //      offset: Offset(0, 3), // changes position of shadow
                //           //    ),
                //           //  ],
                //         ),
                //         child: GestureDetector(
                //           onTap: () {
                //             context
                //                 .read<LoginCubit>()
                //                 .handleSocialLogin(SocialLoginPlatforms.google);
                //           },
                //           child: Padding(
                //             padding: const EdgeInsets.all(15.0).w,
                //             child: Image.asset('assets/images/fbLogin.png'),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                Container(
                  // color: Colors.red,

                  child: Padding(
                      padding: const EdgeInsets.only(
                              top: 30, left: 5, right: 5, bottom: 10)
                          .r,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          AppNavigator.navigateToSignup(context);
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Not a member?',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Gilroy-Medium',
                                    color: const Color.fromRGBO(0, 0, 0, 1)),
                              ),
                              TextSpan(
                                text: " Sign Up now",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Gilroy-Bold',
                                    color:
                                        const Color.fromRGBO(92, 174, 65, 1)),
                              ),
                            ],
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void shouldClearAllTextFields() {
    _phoneNumberController.clear();
    _passwordController.clear();
  }
}
