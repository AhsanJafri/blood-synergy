import 'package:blood_synergy_app/Cubits/signup_cubit/signup_cubit.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/apploader.dart';
import 'package:blood_synergy_app/helpers/countryPickerTextField.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({Key? key}) : super(key: key);

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isobscure = true;
  bool _isobscureConfirmPass = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _phoneCodeController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  var countryPhoneCode = "";
  bool _isChecked = false;
  // RemoteDataSource _apiResponce = RemoteDataSource();

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

  void _signUp() {
    final signupCubit = BlocProvider.of<SignupCubit>(context);

    // Create a SignupRequestModel using the data from your controllers
    // AppNavigator.navigateToOTP(context);
    if (signupCubit.shouldCallApi) {
      signupCubit.performSignup(
          email: _emailController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          phone: countryPhoneCode + _phoneCodeController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        resizeToAvoidBottomInset: true,
        body: BlocListener<SignupCubit, SignupState>(
          listener: (context, state) {
            EasyLoading.dismiss();
            if (state.signupResult is LoadingState) {
              EasyLoading.show(
                  status: ((state.signupResult as LoadingState).msg));
            } else if (state.signupResult is RespSuccessState) {
              AppNavigator.navigateToOTP(
                  context, countryPhoneCode + _phoneCodeController.text, false);
              print(state);
            } else if (state.signupResult is RespErrorState) {
              // Handle error state, e.g., show an error message
              AppLoader.showSnackbar(
                  context,
                  (state.signupResult as RespErrorState)
                          .failure
                          ?.errorMessage ??
                      '',
                  false);
            }
          },
          child: SingleChildScrollView(
            child: Column(
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
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30).r,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign Up',
                            style: appTextTheme.giloryBold32WhiteBlack,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            'Please fill up the form to register',
                            style: appTextTheme.giloryRegular14lightGrey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 160.w,
                      height: 50.h,
                      margin:
                          const EdgeInsets.only(left: 8, right: 0, top: 25).r,
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
                        // ]
                      ),

                      child: TextField(
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          controller: _firstNameController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          // cursorColor: Colors.black,
                          decoration: InputDecoration(
                            // labelText: 'Yards',
                            // floatingLabelStyle: const TextStyle(
                            //   color: Color.fromRGBO(234, 170, 41, 1),
                            // ),
                            hintText: 'First Name',
                            hintStyle: appTextTheme.giloryMedium14lightGrey,

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(92, 174, 65, 1),
                                width: 1.0,
                              ),
                            ),
                          ),
                          onChanged: (value) => context),

                      // ),
                    ),
                    Container(
                      width: 160.w,
                      margin:
                          const EdgeInsets.only(left: 0, right: 8, top: 25).r,
                      height: 50.h,
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
                      child: TextField(
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          controller: _lastNameController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          decoration: InputDecoration(
                            // labelText: 'Yards',
                            floatingLabelStyle: const TextStyle(
                              color: Color.fromRGBO(92, 174, 65, 1),
                            ),
                            hintText: 'Last Name',
                            hintStyle: appTextTheme.giloryMedium14lightGrey,

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(92, 174, 65, 1),
                                width: 1.0,
                              ),
                            ),
                          ),
                          onChanged: (value) => context),
                    ),
                  ],
                ),
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

                  child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(60),
                      ],
                      decoration: InputDecoration(
                        // labelText: 'Yards',

                        hintText: 'Enter Email address',
                        hintStyle: appTextTheme.giloryMedium14lightGrey,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20).w,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(92, 174, 65, 1),
                            width: 1.0,
                          ),
                        ),
                      ),
                      onChanged: (value) => context),

                  // ),
                ),

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
                      myController: _phoneCodeController,
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
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
                    obscureText: _isobscureConfirmPass,
                    controller: _confirmPasswordController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    decoration: InputDecoration(
                      // labelText: 'Yards',
                      // floatingLabelStyle: TextStyle(
                      //   color: Color.fromRGBO(73, 162, 237, 1)
                      // ),
                      hintText: 'Confirm Password',
                      hintStyle: appTextTheme.giloryMedium14lightGrey,

                      suffixIcon: Padding(
                        padding: EdgeInsetsDirectional.only(
                            start: 15.0.r, top: 10.r, end: 15.r, bottom: 10.r),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isobscureConfirmPass = !_isobscureConfirmPass;
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
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 0).r,
                  child: Row(
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15, right: 5, left: 8)
                                  .r,
                          child: _isChecked
                              ? Image.asset(
                                  'assets/images/termsAndCondChec.png',
                                  height: 12.h,
                                  width: 12.w,
                                )
                              : Image.asset(
                                  'assets/images/termsAndCondUnChec.png',
                                  height: 12.h,
                                  width: 12.w,
                                ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 0, top: 30, right: 0).r,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'By Signing up, you agree to our',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gilroy-Medium',
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // util.push(context, TermsAndCondScreen());
                                  },
                                  child: const Text(
                                    ' Terms of Services',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Gilroy-Medium',
                                        color: Color.fromRGBO(92, 174, 65, 1)),
                                  ),
                                ),
                                const Text(
                                  ' and',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gilroy-Medium',
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                // util.push(context, privacyPolicyScreen());
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1).r,
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Gilroy-Medium',
                                      color:
                                          const Color.fromRGBO(92, 174, 65, 1)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(left: 27, right: 27, top: 10),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Container(
                //           color: Colors.green,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    // Util.push(context, otpVerificationScreen('SignUp'));
                    _signUp();
                  },
                  child: Container(
                    width: 345.w,
                    height: 50.h,

                    margin:
                        const EdgeInsets.only(top: 40, left: 15, right: 15).r,
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
                        'Sign Up',
                        style: appTextTheme.gilorySemiBold16White,
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Padding(
                      padding: const EdgeInsets.only(
                              top: 17, left: 30, right: 10, bottom: 15)
                          .r,
                      child: InkWell(
                        onTap: () {
                          //  util.push(context, loginScreen());
                          // context.read<AuthCubit>().Login();
                          Navigator.pop(context);
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already member?',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy-Medium',
                                  color: const Color.fromRGBO(0, 0, 0, 1),
                                ),
                              ),
                              TextSpan(
                                text: "  Login now",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gilroy-Medium',
                                    color:
                                        const Color.fromRGBO(230, 18, 114, 1)),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  void shouldClearAllTextFields() {
    _firstNameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneCodeController.clear();
    _postalCodeController.clear();
  }
}
