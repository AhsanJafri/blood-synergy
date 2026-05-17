part of 'doctors_cubit.dart';

class DoctorsState {
  final AppResultState<dynamic>? result;
  GeneralStatus status;
  DoctorsState(this.result, this.status);

  DoctorsState copyWith({
    AppResultState<dynamic>? result,
    GeneralStatus? status,
    int? currentTab,
  }) {
    return DoctorsState(
      result ?? this.result,
      status ?? this.status,
    );
  }
}
