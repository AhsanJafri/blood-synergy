import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_synergy_app/Cubits/update_password_cubit/update_password_cubit.dart';
import 'package:blood_synergy_app/Repositories/AuthenticationRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:http/http.dart';
import 'package:dio/dio.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();

  bool _isobscure = true;
  bool _isobscureConfirmPass = true;
  bool _isobscureCurrentPass = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdatePasswordCubit(AuthenticationRepository(NetworkClient(Client(), dio: Dio()))),
      child: ChangePasswordContent(
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        currentPasswordController: _currentPasswordController,
        isobscure: _isobscure,
        isobscureConfirmPass: _isobscureConfirmPass,
        isobscureCurrentPass: _isobscureCurrentPass,
        onTogglePasswordVisibility: () => setState(() => _isobscure = !_isobscure),
        onToggleConfirmPasswordVisibility: () => setState(() => _isobscureConfirmPass = !_isobscureConfirmPass),
        onToggleCurrentPasswordVisibility: () => setState(() => _isobscureCurrentPass = !_isobscureCurrentPass),
      ),
    );
  }
}

class ChangePasswordContent extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController currentPasswordController;
  final bool isobscure;
  final bool isobscureConfirmPass;
  final bool isobscureCurrentPass;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback onToggleCurrentPasswordVisibility;

  const ChangePasswordContent({
    Key? key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.currentPasswordController,
    required this.isobscure,
    required this.isobscureConfirmPass,
    required this.isobscureCurrentPass,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onToggleCurrentPasswordVisibility,
  }) : super(key: key);

  void _changePassword(BuildContext context) {
    final String currentPassword = currentPasswordController.text.trim();
    final String newPassword = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your current password')),
      );
      return;
    }

    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a new password')),
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please confirm your new password')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters long')),
      );
      return;
    }

    // Call the cubit to change password
    context.read<UpdatePasswordCubit>().setPassword(
      password: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdatePasswordCubit, UpdatePasswordState>(
      listener: (context, state) {
        if (state.result != null) {
          if (state.result is LoadingState) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // Hide loading indicator
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            if (state.result is RespSuccessAndNavigateState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password changed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Clear the text fields
              currentPasswordController.clear();
              passwordController.clear();
              confirmPasswordController.clear();
              // Navigate back
              Navigator.pop(context);
            } else if (state.result is RespErrorState) {
              final errorState = state.result as RespErrorState;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorState.failure?.errorMessage ?? 'Failed to change password'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      },
      child: SafeArea(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Change Password',
                      style: appTextTheme.giloryBold28WBlack,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),

                    Text(
                      'In order to change password you need to enter the current password',
                      style: appTextTheme.giloryMedium14lightGrey,
                    ),

                    SizedBox(height: 40.h),
                    Text(
                      'Current Password',
                      style: appTextTheme.giloryBold15Black,
                    ),
                    Container(
                      height: 50.h,
                      margin:
                          const EdgeInsets.only(left: 0, right: 0, top: 10).r,
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
                        obscureText: isobscureCurrentPass,
                        controller: currentPasswordController,
                        decoration: InputDecoration(
                          // labelText: 'Yards',
                          // floatingLabelStyle: TextStyle(
                          //   color: Color.fromRGBO(73, 162, 237, 1)
                          // ),
                          hintText: 'Current Password',
                          hintStyle: appTextTheme.giloryMedium14lightGrey,

                          suffixIcon: Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: 15.0.r,
                                top: 10.r,
                                end: 15.r,
                                bottom: 10.r),
                            child: InkWell(
                              onTap: () {
                                onToggleCurrentPasswordVisibility();
                              },
                              child: isobscureCurrentPass
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

                    SizedBox(height: 30.h),
                    Text(
                      'Set New Password',
                      style: appTextTheme.giloryBold15Black,
                    ),
                    Container(
                      height: 50.h,
                      margin:
                          const EdgeInsets.only(left: 0, right: 0, top: 10).r,
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
                        obscureText: isobscure,
                        controller: passwordController,
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
                                onTogglePasswordVisibility();
                              },
                              child: isobscure
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
                        obscureText: isobscureConfirmPass,
                        controller: confirmPasswordController,
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
                                onToggleConfirmPasswordVisibility();
                              },
                              child: isobscureConfirmPass
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
                            'At least 12 characters long but 14 or more is better.',
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
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: InkWell(
          onTap: () {
            _changePassword(context);
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
                'Change Password',
                style: appTextTheme.gilorySemiBold16White,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    ),
    );
  }
}
