import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/Models/SignupReqModel.dart';
import 'package:blood_synergy_app/Repositories/AuthenticationRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/env_config.dart';
import 'package:blood_synergy_app/helpers/pending_signup_storage.dart';
import 'package:blood_synergy_app/helpers/password_reset_storage.dart';
import 'package:blood_synergy_app/helpers/validator.dart';
import 'package:blood_synergy_app/services/sendgrid_otp_service.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  AuthenticationRepository repo;
  final SendGridOtpService _sendGridOtpService = SendGridOtpService();

  SignupCubit(this.repo) : super(SignupState(null));
  bool shouldCallApi = true;

  void _safeEmit(SignupState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  /// Validates form, saves signup data locally, sends email OTP (no API signup yet).
  Future<void> prepareSignupAndSendOtp({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? password,
    String? confirmPassword,
  }) async {
    shouldCallApi = false;

    try {
      final validationError = validateFields(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (validationError != null) {
        _safeEmit(SignupState(AppResultState.error(validationError)));
        return;
      }

      _safeEmit(SignupState(
          AppResultState.loading('Saving your details and sending code...')));

      final signupData = SignupRequest(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        password: password,
        deviceId: EnvConfig.deviceId,
        deviceType: EnvConfig.deviceType,
        fcmToken: EnvConfig.fcmToken,
      );

      await PendingSignupStorage.savePendingSignup(signupData);

      final otpResult = await _sendGridOtpService.sendOtp(email!.trim());
      _safeEmit(SignupState(otpResult));
    } catch (error) {
      _safeEmit(SignupState(AppResultState.error(error.toString())));
    } finally {
      shouldCallApi = true;
    }
  }

  /// Resend email OTP during signup (after 2-minute window).
  Future<void> resendEmailOtp(String email) async {
    shouldCallApi = false;
    _safeEmit(
        SignupState(AppResultState.loading('Resending verification code...')));

    try {
      final pending = await PendingSignupStorage.loadPendingSignup();
      if (pending == null) {
        _safeEmit(SignupState(AppResultState.error(
            'Signup session expired. Please go back and try again.')));
        return;
      }

      final otpResult = await _sendGridOtpService
          .sendOtp(email.trim().isNotEmpty ? email : pending.email!);
      _safeEmit(SignupState(otpResult));
    } catch (error) {
      _safeEmit(SignupState(AppResultState.error(error.toString())));
    } finally {
      shouldCallApi = true;
    }
  }

  /// Resend the locally generated password-reset OTP to the returned email.
  Future<void> resendPasswordResetOtp(String email) async {
    shouldCallApi = false;
    _safeEmit(
        SignupState(AppResultState.loading('Resending verification code...')));

    try {
      final otpResult = await _sendGridOtpService.sendOtp(
        email.trim(),
        forPasswordReset: true,
      );
      _safeEmit(SignupState(otpResult));
    } catch (error) {
      _safeEmit(SignupState(AppResultState.error(error.toString())));
    } finally {
      shouldCallApi = true;
    }
  }

  /// Verify email OTP locally, then call signup API.
  Future<void> verifyEmailOtpAndRegister(String? code) async {
    if (code == null || code.isEmpty) {
      _safeEmit(SignupState(
          AppResultState.error('Please enter the verification code')));
      return;
    }

    shouldCallApi = false;
    try {
      if (PendingSignupStorage.isOtpExpired()) {
        _safeEmit(SignupState(AppResultState.error(
            'Verification code expired. Tap Resend to get a new code.')));
        return;
      }

      if (!PendingSignupStorage.verifyOtp(code)) {
        _safeEmit(SignupState(
            AppResultState.error('Invalid verification code. Please try again.')));
        return;
      }

      final pending = await PendingSignupStorage.loadPendingSignup();
      if (pending == null) {
        _safeEmit(SignupState(AppResultState.error(
            'Signup session expired. Please go back and try again.')));
        return;
      }

      _safeEmit(SignupState(
          AppResultState.loading('Verified! Creating your account...')));

      final response = await repo.signup(pending);

      if (response is RespErrorState<String>) {
        _safeEmit(SignupState(response));
      } else if (response is RespSuccessState<String>) {
        await PendingSignupStorage.clear();
        _safeEmit(SignupState(AppResultState.successNavigate(
            response.value ?? 'Account created successfully')));
      } else {
        await PendingSignupStorage.clear();
        _safeEmit(SignupState(AppResultState.successNavigate(
            'Account created successfully')));
      }
    } catch (error) {
      _safeEmit(SignupState(AppResultState.error(error.toString())));
    } finally {
      shouldCallApi = true;
    }
  }

  Future<void> resentOTP() async {
    shouldCallApi = false;
    _safeEmit(SignupState(AppResultState.loading('Resending OTP...')));

    try {
      final response = await repo.reSendOTP();
      _safeEmit(SignupState(response));
    } catch (error) {
      _safeEmit(SignupState(AppResultState.error(error.toString())));
    } finally {
      shouldCallApi = true;
    }
  }

  Future<void> verifyOTP(String? code) async {
    if (code == null || code.isEmpty) {
      _safeEmit(SignupState(AppResultState.error('Please Enter OTP Code')));
      return;
    }
    shouldCallApi = false;
    try {
      _safeEmit(SignupState(AppResultState.loading('Verifying OTP...')));

      final response = await repo.verifyOTP(code);
      _safeEmit(SignupState(response));
    } catch (error) {
      _safeEmit(SignupState(AppResultState.error(error.toString())));
    } finally {
      shouldCallApi = true;
    }
  }

  /// Verify the password-reset OTP on-device before allowing a password change.
  Future<void> verifyPasswordResetOtp(String? code) async {
    if (code == null || code.isEmpty) {
      _safeEmit(SignupState(AppResultState.error('Please enter the verification code')));
      return;
    }

    shouldCallApi = false;
    try {
      if (PasswordResetStorage.isOtpExpired()) {
        _safeEmit(SignupState(AppResultState.error(
            'Verification code expired. Tap Resend to get a new code.')));
        return;
      }

      if (!PasswordResetStorage.verifyOtp(code)) {
        _safeEmit(SignupState(
            AppResultState.error('Invalid verification code. Please try again.')));
        return;
      }

      await PasswordResetStorage.markOtpVerified();
      _safeEmit(SignupState(
          AppResultState.successNavigate('Email verified successfully.')));
    } catch (error) {
      _safeEmit(SignupState(AppResultState.error(error.toString())));
    } finally {
      shouldCallApi = true;
    }
  }

  String? validateFields({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? password,
    String? confirmPassword,
  }) {
    final emailError = Validator.isEmailValid(email ?? '');
    final phoneError = Validator.isPhoneValid(phone);
    final passwordError = Validator.isPasswordValid(password ?? '');
    final confirmPasswordError =
        Validator.isPasswordValid(confirmPassword ?? '');
    final firstNameError = Validator.isNameValid(firstName);
    final lastNameError = Validator.isNameValid(lastName);
    if (firstNameError != null) {
      return 'first $firstNameError';
    } else if (lastNameError != null) {
      return 'last $lastNameError';
    } else if (emailError != null) {
      return emailError;
    } else if (phoneError != null) {
      return phoneError;
    } else if (passwordError != null) {
      return passwordError;
    } else if (confirmPasswordError != null) {
      return confirmPasswordError;
    } else if (password != confirmPassword) {
      return 'Password and Confirm Password do not match';
    }

    return null;
  }
}
