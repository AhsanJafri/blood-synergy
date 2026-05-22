import 'dart:convert';
import 'package:blood_synergy_app/Models/UserModel.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:blood_synergy_app/helpers/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPref {
  static late SharedPreferences prefs;

  // Create a method to initialize the SharedPreferences instance if not already initialized
  static Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }
    static Future<void> firstLoad(bool value) async {
    // Implement your logic here, e.g., save a preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstLoad', value);
  }

  static void persistUserData(String str) async {
    prefs.setString('user', str);
    await AppStateManagerState.shared.getUserData();
  }

  static void persistUserToken(String str) async {
    prefs.setString('authToken', str);
  }

  static void persistWebUserToken(String str) async {
    prefs.setString('webAuthToken', str);
  }

  static Future<String?> getUserToken() async {
    return prefs.getString('authToken');
  }

  static Future<String?> getWebUserToken() async {
    return prefs.getString('webAuthToken');
  }

  static Future<bool> isLogin() async {
    CurrentUser u = await retrieveUserDate();

    if (u.email == null || (u.email?.isEmpty ?? true)) {
      return false;
    } else {
      AppStateManagerState.shared.UserData = u;
      return true;
    }
  }

  static Future<void> removeUser() async {
    prefs.remove("user");
  }

  static Future<void> clearPrefs() async {
    prefs.remove("user");
    prefs.remove("authToken");
    prefs.remove("webAuthToken");
  }

  static Future<CurrentUser> retrieveUserDate() async {
    final userJsonString = prefs.getString('user') ?? '0';
    Constants.token = prefs.getString('authToken') ?? '';

    print(userJsonString);
    if (userJsonString != "0" && Constants.token.isNotEmpty) {
      //final res = jsonDecode(userJsonString);
      // final apiresponse = BaseResponse.fromJson(userJsonString);
      var jsn = jsonDecode(userJsonString);

      final userModel = CurrentUser.fromJson(jsn);

      return userModel;
    } else {
      return CurrentUser();
    }
  }
}
