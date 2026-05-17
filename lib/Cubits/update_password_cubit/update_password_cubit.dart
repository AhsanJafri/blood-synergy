import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/Repositories/AuthenticationRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/validator.dart';
import 'package:meta/meta.dart';
part 'update_password_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  AuthenticationRepository repo;
  UpdatePasswordCubit(this.repo) : super(UpdatePasswordInitial(null));
  var apiCalled = false;

  Future<void> setPassword(
      {required String password, required String confirmPassword}) async {
    if (!apiCalled) {
      apiCalled = true;
      AppResultState<String>? validationResult =
          _validateInput(password, password);

      if (validationResult != null) {
        emit(UpdatePasswordInitial(validationResult));
        apiCalled = false;
        return;
      }

      emit(UpdatePasswordState(AppResultState.loading("Please wait...")));

      await _setNewPassword(password, password);
    }
  }

  AppResultState<String>? _validateInput(
      String password, String confirmPassword) {
    List<String?> errors = [];

    if (password.isEmpty || confirmPassword.isEmpty) {
      errors.add('Please enter both password and confirmPassword');
    } else if (password.isEmpty != confirmPassword.isEmpty) {
      errors.add('password do not match');
    }

    if (errors.isNotEmpty) {
      errors.forEach((error) {
        emit(UpdatePasswordState(AppResultState.error(error!)));
      });
      return RespErrorState(
          errors.join('\n')); // Combine errors into a single string
    }

    return null;
  }

  Future<void> _setNewPassword(String username, String password) async {
    final _response = await repo.changePassword('', password, true);
    apiCalled = false;
    emit(UpdatePasswordState(_response));
  }
}
