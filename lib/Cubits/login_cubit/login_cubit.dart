import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/Models/SocialLoginRequestModel.dart';
import 'package:blood_synergy_app/Repositories/AuthenticationRepository.dart';
import 'package:blood_synergy_app/helpers/SocialMediaAuthManager.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/validator.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

enum SocialLoginPlatforms { facebook, apple, google }

class LoginCubit extends Cubit<LoginState> {
  AuthenticationRepository repo;
  LoginCubit(this.repo) : super(LoginInitial(null));

  Future<void> login(
      {required String username, required String password}) async {
    AppResultState<String>? validationResult =
        _validateInput(username, password);

    if (validationResult != null) {
      emit(LoginScreenStates(validationResult));
      return;
    }
    emit(LoginScreenStates(AppResultState.loading("Signing in...")));

    await _performLogin(username, password);
  }

  AppResultState<String>? _validateInput(String username, String password) {
    List<String?> errors = [];

    if (username.isEmpty || password.isEmpty) {
      errors.add('Please enter credentials');
    }

    if (errors.isNotEmpty) {
      errors.forEach((error) {
        emit(LoginScreenStates(AppResultState.error(error!)));
      });
      return RespErrorState(
          errors.join('\n')); // Combine errors into a single string
    }

    return null;
  }

  Future<void> handleSocialLogin(SocialLoginPlatforms platform) async {
    switch (platform) {
      case SocialLoginPlatforms.apple:
        print('Login with apple');

        // await _loginWithApple().then((value) => emit(value));
        // ;
        break;
      case SocialLoginPlatforms.google:
        print('Login with Google');
        await _loginWithGoogle().then((value) {
          if (value is RespErrorState) {
            if ((value as RespErrorState).failure?.errorMessage?.isNotEmpty ==
                true) {
              emit(LoginScreenStates(value));
            }
          }
        });
        break;
      case SocialLoginPlatforms.facebook:
        print('Login with Facebook');

        await _loginWithFacebook().then((value) {
          if (value is RespErrorState) {
            if ((value as RespErrorState).failure?.errorMessage?.isNotEmpty ==
                true) {
              emit(LoginScreenStates(value));
            }
          }
        });
        break;
    }
  }

  Future<AppResultState<String>> _loginWithGoogle() async {
    try {
      final _response = await SocialAuthService().signInWithGoogle();
      if (_response != null) {
        var socialModel = SocialLoginModel(
            id: _response.id,
            name: _response.displayName ?? '',
            nickname: "",
            email: _response.email,
            avatar: _response.photoUrl ?? '',
            type: SocialLoginPlatforms.google.name);

        return await _socialLogin(socialModel);
      }
      // Removed check for serverAuthCode as GoogleSignInAccount does not have this property
      return AppResultState.error((""));
    } catch (e) {
      return AppResultState.error((e.toString()));

      // emit(AuthFailureState('${AppMessages.signupFailure}: $e'));
    }
  }

  Future<AppResultState<String>> _loginWithFacebook() async {
    try {
      final _response = await SocialAuthService().signInWithFacebook();
      if (_response != null) {
        var socialModel = SocialLoginModel(
            id: _response["id"],
            name: _response["name"] ?? '',
            nickname: "",
            email: _response["email"],
            avatar: _response['picture']['data']['url'],
            type: SocialLoginPlatforms.facebook.name);
        return _socialLogin(socialModel);
      }
      if (_response != null) {
        return AppResultState.error(("Unknown Error Occured"));
      }
      return AppResultState.error((""));
    } catch (e) {
      return AppResultState.error((e.toString()));

      // emit(AuthFailureState('${AppMessages.signupFailure}: $e'));
    }
  }

  // Future<AuthenticationState> _loginWithApple() async {
  //   try {
  //     final _response = await SocialAuthService().signInWithApple();
  //     if (_response?.userIdentifier != null) {
  //       var socialModel = SocialLoginModel(
  //           id: _response?.userIdentifier ?? '',
  //           name: '',
  //           nickname: "",
  //           email: _response?.email ?? '',
  //           avatar: '',
  //           type: SocialLoginPlatforms.facebook.name);
  //       return _socialLogin(socialModel);
  //     }
  //     return AuthFailureState("Unknown Error Occured");
  //   } catch (e) {
  //     return AuthFailureState(e.toString());

  //     // emit(AuthFailureState('${AppMessages.signupFailure}: $e'));
  //   }
  // }

  Future<AppResultState<String>> _socialLogin(SocialLoginModel model) async {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(LoginScreenStates(AppResultState.loading("Signing in...")));

    final _response = await repo.socialLogin(model);
    return _response;
  }

  Future<void> _performLogin(String username, String password) async {
    final _response = await repo.login(
      username,
      password,
    );
    emit(LoginScreenStates(_response));
  }

  String? verifyPhone(String phone) {
    return Validator.isPhoneValid(phone);
  }

  Future<void> forgotPassword(String phone) async {
    var verify = verifyPhone(phone);
    if (verify != null) {
      emit(ForgotPasswordScreenStates(AppResultState.error(verify)));
      return;
    }

    emit(ForgotPasswordScreenStates(AppResultState.loading("Please wait...")));
    final _response = await repo.forgotPassword(phone);
    emit(ForgotPasswordScreenStates(_response));
  }
}
