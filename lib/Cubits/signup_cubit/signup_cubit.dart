import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/Models/SignupReqModel.dart';
import 'package:blood_synergy_app/Repositories/AuthenticationRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/validator.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  AuthenticationRepository repo;
  SignupCubit(this.repo) : super(SignupState(null));
  bool shouldCallApi = true;
  Future<void> performSignup(
      {String? email,
      String? firstName,
      String? lastName,
      String? phone,
      String? password,
      String? confirmPassword}) async {
    shouldCallApi = false;

    try {
      // Perform field validation
      String? validationError = validateFields(
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          password: password,
          confirmPassword: confirmPassword);

      if (validationError != null) {
        emit(SignupState(AppResultState.error(validationError)));
        return;
      }

      emit(SignupState(
          AppResultState.loading('Please wait while we register you...')));

      // Continue with the signup logic...
      SignupRequest signupData = SignupRequest(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        password: password,
        deviceId: '987675rdtcfvghbhn7867',
        deviceType: 'iPhone',
        fcmToken: '09876ftyvghbhjnkoi8978g67t',
      );

      AppResultState<String> _response = await repo.signup(signupData);

      emit(SignupState(_response));
    } catch (error) {
      // Handle other errors (not related to signup result)
      emit(SignupState(AppResultState.error(error.toString())));
    } finally {
      shouldCallApi = true;
    }
  }

  // void resentOTP() {
  //   print("Resend OTP");
  // }
  Future<void> resentOTP() async {
    shouldCallApi = false;
    emit(SignupState(AppResultState.loading('Resending OTP...')));

    try {
      // Perform field validation

      AppResultState<String> _response = await repo.reSendOTP();

      emit(SignupState(_response));
    } catch (error) {
      // Handle other errors (not related to signup result)
      emit(SignupState(AppResultState.error(error.toString())));
    } finally {
      shouldCallApi = true;
    }
  }

  Future<void> verifyOTP(String? code) async {
    if (code == null || code.isEmpty) {
      emit(SignupState(AppResultState.error("Please Enter OTP Code")));
      return;
    }
    shouldCallApi = false;
    try {
      // Perform field validation

      emit(SignupState(AppResultState.loading('Verifying OTP...')));

      AppResultState<String> _response = await repo.verifyOTP(code!);

      emit(SignupState(_response));
    } catch (error) {
      // Handle other errors (not related to signup result)
      emit(SignupState(AppResultState.error(error.toString())));
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
    // Use the Validator class for field validation
    String? emailError = Validator.isEmailValid(email ?? '');
    String? phoneError = Validator.isPhoneValid(phone);
    String? passwordError = Validator.isPasswordValid(password ?? '');
    String? confirmPasswordError =
        Validator.isPasswordValid(confirmPassword ?? '');
    String? firstNameError = Validator.isNameValid(firstName);
    String? lastNameError = Validator.isNameValid(lastName);
    if (firstNameError != null) {
      return "first $firstNameError";
    } else if (lastNameError != null) {
      return "last $lastNameError";
    } else if (emailError != null) {
      return emailError;
    } else if (phoneError != null) {
      return phoneError;
    } else if (passwordError != null) {
      return passwordError;
    } else if (confirmPasswordError != null) {
      return confirmPasswordError;
    } else if (password != confirmPassword) {
      return "Password and Confirm Password do not match";
    }

    // validationErrors.add("Password and Confirm Password do not match");

    return null;
  }
}
