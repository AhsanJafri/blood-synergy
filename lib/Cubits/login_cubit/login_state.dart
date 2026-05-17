part of 'login_cubit.dart';

@immutable
class LoginState {}

class LoginScreenStates extends LoginState {
  final AppResultState<String>? loginResult;

  LoginScreenStates(this.loginResult);
}

class LoginInitial extends LoginState {
  LoginInitial(AppResultState<String>? loginResult) : super();
}

class ForgotPasswordScreenStates extends LoginState {
  final AppResultState<String>? forgotPasswordResults;

  ForgotPasswordScreenStates(this.forgotPasswordResults);
}
