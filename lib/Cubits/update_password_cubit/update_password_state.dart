part of 'update_password_cubit.dart';

@immutable
class UpdatePasswordState {
  final AppResultState<String>? result;

  const UpdatePasswordState(this.result);
}

class UpdatePasswordInitial extends UpdatePasswordState {
  UpdatePasswordInitial(AppResultState<String>? result) : super(result);
}
