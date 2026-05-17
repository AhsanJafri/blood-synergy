part of 'supplements_cubit.dart';

class SupplementsState {
  final AppResultState<dynamic>? result;
  GeneralStatus status;

  SupplementsState(this.result, this.status);

  SupplementsState copyWith({
    AppResultState<dynamic>? result,
    GeneralStatus? status,
    int? currentTab,
  }) {
    return SupplementsState(
      result ?? this.result,
      status ?? this.status,
    );
  }
}
