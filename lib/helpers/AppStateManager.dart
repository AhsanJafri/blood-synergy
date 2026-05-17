import 'package:blood_synergy_app/Models/UserModel.dart';
import 'package:blood_synergy_app/helpers/AppPreference.dart';

class AppStateManagerState {
  static final AppStateManagerState shared = AppStateManagerState._internal();

  CurrentUser? UserData;

  factory AppStateManagerState() {
    return shared;
  }

  AppStateManagerState._internal() {
    //  getUserData();
  }

  Future<CurrentUser> getUserData() async {
    await UserPref.retrieveUserDate().then((value) {
      if ((value.email?.isNotEmpty ?? false)) {
        UserData = value;

        return value;
      }
    });
    return UserData ?? CurrentUser();
  }

  Future<void> deleteUser() async {
    await UserPref.removeUser().then((value) {
      UserData = null;
    });
  }
}
