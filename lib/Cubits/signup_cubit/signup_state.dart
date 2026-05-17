part of 'signup_cubit.dart';

@immutable
class SignupState {
  final AppResultState<String>? signupResult;

  SignupState(this.signupResult);
}

class SignupInitial extends SignupState {
  SignupInitial(AppResultState<String>? signupResult) : super(signupResult);
}
