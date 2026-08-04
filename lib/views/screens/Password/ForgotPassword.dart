import 'package:blood_synergy_app/Cubits/login_cubit/login_cubit.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/apploader.dart';
import 'package:blood_synergy_app/helpers/countryPickerTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneCodeController = TextEditingController();
  var countryPhoneCode = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is ForgotPasswordScreenStates) {
              print("Listening in forgotPass");

              EasyLoading.dismiss();
              // Handle state changes here
              if (state.forgotPasswordResults is LoadingState) {
                // Show EasyLoader when the state is loading
                // You can customize this part based on your EasyLoader implementation
                EasyLoading.show(
                    status: (state.forgotPasswordResults as LoadingState).msg ??
                        '');
              } else if (state.forgotPasswordResults
                  is RespSuccessAndNavigateState) {
                // Handle success state, e.g., navigate to the next screen
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => NextScreen()),
                // );
                context
                    .read<LoginCubit>()
                    .emit(ForgotPasswordScreenStates(null));
                AppNavigator.navigateToOTP(context,
                    (state.forgotPasswordResults
                            as RespSuccessAndNavigateState<String>)
                        .value,
                    true);
              } else if (state.forgotPasswordResults is RespErrorState) {
                // Handle error state, e.g., show an error message
                AppLoader.showSnackbar(
                    context,
                    (state.forgotPasswordResults as RespErrorState)
                            .failure
                            ?.errorMessage ??
                        '',
                    false);
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Forgot Password',
                        style: appTextTheme.giloryBold28WBlack,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        'In order to reset your password you need to enter your registered phone number.',
                        style: appTextTheme.giloryMedium14lightGrey,
                      ),
                      SizedBox(height: 40.h),
                      Container(
                        height: 50.h,
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10)
                                .r,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(243, 243, 243, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
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
                      SizedBox(height: 20.0.h),
                    ],
                  ),
                ),
              ],
            ));
          },
        ),
        floatingActionButton: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            var phone = countryPhoneCode + _phoneCodeController.text;
            if (_phoneCodeController.text.isEmpty) {
              AppLoader.showSnackbar(
                  context, 'Phone number can not be empty', false);
            } else {
              context.read<LoginCubit>().forgotPassword(phone);
            }
            // Util.push(context, otpVerificationScreen('SignUp'));
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
