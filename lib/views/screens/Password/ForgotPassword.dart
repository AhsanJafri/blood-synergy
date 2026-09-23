import 'package:blood_synergy_app/Cubits/login_cubit/login_cubit.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/apploader.dart';
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
  final TextEditingController _emailController = TextEditingController();

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
                    margin: EdgeInsets.only(left: 20.w, top: 4.h),
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
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        'Forgot Password',
                        style: appTextTheme.giloryBold28WBlack,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'In order to reset your password you need to enter your registered email.',
                        style: appTextTheme.giloryMedium14lightGrey,
                      ),
                      SizedBox(height: 28.h),
                      Container(
                        height: 50.h,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(243, 243, 243, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.r),
                          ),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: appTextTheme.giloryMedium14lightGrey,
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 18.w),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
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
            final email = _emailController.text.trim();
            if (email.isEmpty) {
              AppLoader.showSnackbar(
                  context, 'Email cannot be empty', false);
            } else {
              context.read<LoginCubit>().forgotPassword(email);
            }
          },
          child: Container(
            width: double.infinity,
            height: 50.h,
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(92, 174, 65, 1),
              borderRadius: BorderRadius.all(Radius.circular(18.r)),
            ),
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
