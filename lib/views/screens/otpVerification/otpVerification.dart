import 'package:blood_synergy_app/Cubits/signup_cubit/signup_cubit.dart';
import 'package:blood_synergy_app/helpers/AppNavigator.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/network_error_message.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class otpVerificationScreen extends StatefulWidget {
  String phone;
  bool fromForgotPassword = false;
  otpVerificationScreen(this.phone, this.fromForgotPassword);

  @override
  State<otpVerificationScreen> createState() => _otpVerificationScreenState();
}

class _otpVerificationScreenState extends State<otpVerificationScreen> {
  static const int _otpWindowSeconds = 120;

  bool _canResend = false;
  bool _isVerifying = false;
  bool _isDisposed = false;
  int endTime =
      DateTime.now().millisecondsSinceEpoch + _otpWindowSeconds * 1000;
  String otp = '';

  CountdownTimerController? _countdownController;

  @override
  void initState() {
    super.initState();
    _countdownController = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _countdownController?.dispose();
    super.dispose();
  }

  void _resetCountdown() {
    if (_isDisposed || !mounted) return;
    setState(() {
      _canResend = false;
      endTime = DateTime.now().millisecondsSinceEpoch + _otpWindowSeconds * 1000;
      _countdownController?.dispose();
      _countdownController = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    });
  }

  void onEnd() {
    if (_isDisposed || !mounted) return;
    setState(() {
      _canResend = true;
    });
  }

  void _onResend() {
    if (!_canResend) return;
    if (widget.fromForgotPassword) {
      context.read<SignupCubit>().resentOTP();
    } else {
      context.read<SignupCubit>().resendEmailOtp(widget.phone);
    }
    _resetCountdown();
  }

  void _onVerify() {
    if (otp.length < 6 || _isVerifying || !mounted) return;
    
    setState(() {
      _isVerifying = true;
    });
    
    if (widget.fromForgotPassword) {
      context.read<SignupCubit>().verifyOTP(otp);
    } else {
      context.read<SignupCubit>().verifyEmailOtpAndRegister(otp);
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
                status: (state.signupResult as LoadingState).msg.toString());
          } else if (state.signupResult is RespSuccessState) {
            if (mounted) {
              setState(() {
                _isVerifying = false;
              });
              if (!widget.fromForgotPassword) {
                _resetCountdown();
              }
              EasyLoading.showSuccess(
                (state.signupResult as RespSuccessState).value.toString(),
                duration: const Duration(seconds: 2),
              );
            }
          } else if (state.signupResult is RespSuccessAndNavigateState) {
            EasyLoading.dismiss();
            if (widget.fromForgotPassword) {
              AppNavigator.navigateToSetNewPassword(context);
            } else {
              EasyLoading.showSuccess(
                'Account created! Please login.',
                duration: const Duration(seconds: 2),
              );
              AppNavigator.navigateToLogin(context);
            }
          } else if (state.signupResult is RespErrorState) {
            EasyLoading.dismiss();
            final errorState = state.signupResult as RespErrorState;
            final failure = errorState.failure;
            final errorMsg = failure?.errorMessage ??
                'Registration failed. Please try again.';
            final networkError = isNetworkFailure(
              null,
              failure: failure,
            );

            EasyLoading.showError(
              errorMsg,
              duration: const Duration(seconds: 3),
            );

            if (mounted) {
              setState(() {
                _isVerifying = false;
              });
            }

            if (!widget.fromForgotPassword && !networkError) {
              Future.delayed(const Duration(milliseconds: 2500), () {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.only(top: 35, left: 20).r,
                height: 46.h,
                width: 46.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                  borderRadius:
                      BorderRadius.all(const Radius.circular(30).w),
                ),
                child: Image.asset('assets/images/back.png'),
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
                  SizedBox(height: 9.h),
                  Text(
                    widget.fromForgotPassword
                        ? 'Please enter the 6-digit code sent to ${widget.phone}'
                        : 'Enter the 6-digit code we sent to your email ${widget.phone}. Code expires in 2 minutes.',
                    style: appTextTheme.giloryRegular14lightGrey,
                    textAlign: TextAlign.start,
                  ),
                  if (!widget.fromForgotPassword) ...[
                    SizedBox(height: 8.h),
                    Text(
                      'If you don\'t see the email, please check your spam or junk folder.',
                      style: appTextTheme.giloryRegular14lightGrey.copyWith(
                        fontStyle: FontStyle.italic,
                        color: const Color.fromRGBO(120, 120, 120, 1),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35, left: 25, right: 25).r,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50.h,
                  fieldWidth: 50.w,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: const Color.fromRGBO(92, 174, 65, 1),
                  inactiveColor: const Color.fromRGBO(218, 218, 218, 1),
                  selectedColor: const Color.fromRGBO(92, 174, 65, 1),
                ),
                textStyle: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.green,
                  fontFamily: 'Gilory-Bold',
                  fontWeight: FontWeight.bold,
                ),
                enableActiveFill: true,
                onChanged: (value) {
                  setState(() {
                    otp = value;
                  });
                },
                onCompleted: (value) {
                  setState(() {
                    otp = value;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 20).r,
                child: Container(
                  height: 50.h,
                  width: 160.w,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(243, 243, 243, 1),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: InkWell(
                    onTap: _onResend,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_canResend && _countdownController != null)
                          CountdownTimer(
                            controller: _countdownController,
                            endTime: endTime,
                            widgetBuilder: (_, time) {
                              if (time != null) {
                                final mins = time.min ?? 0;
                                final secs = time.sec ?? 0;
                                return Text(
                                  'Resend in ${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                                  style: appTextTheme.giloryRegular14lightGrey,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          )
                        else
                          Text(
                            'Resend code',
                            style: appTextTheme.giloryRegular14lightGrey
                                .copyWith(
                              color: const Color.fromRGBO(92, 174, 65, 1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        splashColor: Colors.transparent,
        onTap: _onVerify,
        child: Container(
          width: 345.w,
          height: 50.h,
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20).r,
          decoration: BoxDecoration(
            color: otp.length < 6 || _isVerifying
                ? Colors.grey
                : const Color.fromRGBO(92, 174, 65, 1),
            borderRadius: BorderRadius.all(const Radius.circular(18).w),
          ),
          child: Align(
            alignment: Alignment.center,
            child: _isVerifying
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.fromForgotPassword ? 'Verify' : 'Verify & Sign Up',
                    style: appTextTheme.gilorySemiBold16White,
                  ),
          ),
        ),
      ),
    );
  }
}
