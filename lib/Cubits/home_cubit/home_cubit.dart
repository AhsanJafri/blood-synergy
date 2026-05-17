import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/Models/Catergories.dart';
import 'package:blood_synergy_app/Repositories/HomeRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeRepository repo;
  List<Categories> cats = []; // Initialize with an empty list

  HomeCubit(this.repo) : super(HomeInitial());

  void getCategories() async {
    try {
      var response = await repo.getCategories();

      if (response is RespSuccessStateWithData) {
        List<dynamic> data = response.value;
        List<Categories> list =
            data.map((map) => Categories.fromJson(map)).toList();
        print(list);
        cats = list;
        emit(HomeScreenStates(AppResultState.successWithData('')));
      } else {
        emit(HomeScreenStates(response));
      }
    } catch (e) {
      // Provide the error message for better feedback
      if(isClosed) return;
      emit(HomeScreenStates(AppResultState.error(e.toString())));
    }
  }
}
