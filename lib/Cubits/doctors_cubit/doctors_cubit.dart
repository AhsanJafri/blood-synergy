import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/Models/DoctorsModel.dart';
import 'package:blood_synergy_app/Repositories/HomeRepository.dart';
import 'package:blood_synergy_app/Models/DoctorDetailModel.dart';
import 'package:blood_synergy_app/helpers/GeneralStates.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
// import 'package:equatable/equatable.dart';

part 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  HomeRepository repo;
  List<DoctorModel> docs = [];
  DoctorDetailModel? docDetail;
  DoctorsCubit(this.repo) : super(DoctorsState(null, GeneralStatus.initial));

  void getDoctors() async {
    try {
      var response = await repo.getDoctors();

      if (response is RespSuccessStateWithData) {
        List<dynamic> data = response.value;

        List<DoctorModel> list =
            data.map((map) => DoctorModel.fromJson(map)).toList();
        print(list);
        docs = list;
        emit(DoctorsState(
            AppResultState.successWithData(''), GeneralStatus.success));
      } else {
        emit(DoctorsState(response, GeneralStatus.error));
      }
    } catch (e) {
      // Provide the error message for better feedback
      emit(DoctorsState(
          AppResultState.error(e.toString()), GeneralStatus.error));
    }
  }

  void getDoctorDetailById(int id) async {
    try {
      emit(DoctorsState(
          AppResultState.loading('Loading'), GeneralStatus.loading));
      final response = await repo.getDoctorDetail(id);
      if (response is RespSuccessStateWithData) {
        final data = response.value;
        docDetail = DoctorDetailModel.fromJson(data);
        emit(DoctorsState(AppResultState.success(''), GeneralStatus.success));
      } else {
        emit(DoctorsState(response, GeneralStatus.error));
      }
    } catch (e) {
      emit(DoctorsState(
          AppResultState.error(e.toString()), GeneralStatus.error));
    }
  }
}
