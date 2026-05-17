import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/Models/DoctorsModel.dart';
import 'package:blood_synergy_app/Models/SupplementsModel.dart';
import 'package:blood_synergy_app/Repositories/HomeRepository.dart';
import 'package:blood_synergy_app/helpers/GeneralStates.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:equatable/equatable.dart';

part 'supplements_state.dart';

class SupplementsCubit extends Cubit<SupplementsState> {
  HomeRepository repo;

  SupplementsCubit(this.repo)
      : super(SupplementsState(null, GeneralStatus.initial));

  List<SupplementModel> supplements = [];

  void getDoctors() async {
    try {
      var response = await repo.getSupplements();

      if (response is RespSuccessStateWithData) {
        List<dynamic> data = response.value;
        List<SupplementModel> list =
            data.map((map) => SupplementModel.fromJson(map)).toList();
        print(list);
        supplements = list;
        emit(SupplementsState(
            AppResultState.successWithData(''), GeneralStatus.success));
      } else {
        emit(SupplementsState(response, GeneralStatus.error));
      }
    } catch (e) {
      // Provide the error message for better feedback
      if(isClosed) return;
      emit(SupplementsState(
          AppResultState.error(e.toString()), GeneralStatus.error));
    }
  }
}
