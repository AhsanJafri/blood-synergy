import 'package:bloc/bloc.dart';
import 'package:blood_synergy_app/Models/UserModel.dart';
import 'package:blood_synergy_app/Repositories/ProfileRepository.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileScreenState> {
  ProfileRepository repo;
  ProfileCubit(this.repo) : super(ProfileInitial());

  Future<void> verifyAndUpdateProfile(CurrentUser user) async {
    AppResultState<String>? validation = _validateInput(user);
    if (validation != null) {
      emit(GetProfileState(validation));
      return;
    }
    emit(GetProfileState(AppResultState.loading("Please wait...")));
    _updateProfile(user);
  }

  Future<void> _updateProfile(CurrentUser user) async {
    final _response = await repo.updateProfile(user);
    emit(GetProfileState(_response));
  }

  AppResultState<String>? _validateInput(CurrentUser profile) {
    if ((profile.gender?.isEmpty ?? true)) {
      return AppResultState.error("Please Select Gender");
    } else if ((profile.age?.isEmpty ?? true)) {
      return AppResultState.error("You must enter your age");
    } else if ((int.parse(profile.age ?? '') > 100) ||
        (int.parse(profile.age ?? '') < 0)) {
      return AppResultState.error(
          "Age must be valid or greater than 0years and less than 100 years");
    }
    //  else if (profile.medicalHistory?.isEmpty ?? true) {
    //   return AppResultState.error("Please enter medical history");
    // } 
    else {
      return null;
    }
  }
}
