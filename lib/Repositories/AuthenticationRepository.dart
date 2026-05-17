import 'dart:convert';

import 'package:blood_synergy_app/Models/SignupReqModel.dart';
import 'package:blood_synergy_app/Models/SocialLoginRequestModel.dart';
import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:blood_synergy_app/helpers/BaseModel.dart';
import 'package:blood_synergy_app/helpers/Constants.dart';

import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/enumhoarder.dart';
import 'package:blood_synergy_app/network_helpers/NetworkEndpoint.dart';

import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:blood_synergy_app/network_helpers/serverSettings.dart';
import 'package:dio/dio.dart';

class AuthenticationRepository {
  final NetworkClient _networkClient;

  AuthenticationRepository(this._networkClient);

  Future<AppResultState<String>> login(
      String phoneEmail, String password) async {
    try {
      var data = FormData.fromMap({
        'phone': phoneEmail,
        'password': password,
        'fcm_token': 'sjcn',
        'device_id': 'sdkjcscsdjkcsnd',
        'device_type': 'IPhone'
      });
      final _response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.login,
          headerWithAuth: false,
          parameter: data);
      final decodedResponse = BaseResponse.fromJson(jsonEncode(_response.data));
      if (decodedResponse.status == 200) {
        if (decodedResponse.token != null) {
          // Do additional processing if needed
          String jsonString = jsonEncode(decodedResponse.jsonData);
          UserPref.persistUserToken(decodedResponse.token ?? '');
          UserPref.persistUserData(jsonString);
          Constants.token =
              await UserPref.getUserToken() ?? decodedResponse.token ?? '';
          return AppResultState.success(decodedResponse.message);
        } else {
          return AppResultState.error(decodedResponse.message);
        }
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }
    Future<AppResultState<String>> logout() async {
    try {
      final _response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.logoutCustomer,
          headerWithAuth: true,
          parameter: null);
      final decodedResponse = BaseResponse.fromJson(jsonEncode(_response.data));
      if (decodedResponse.status == 200) {
        // Do additional processing if needed
        UserPref.clearPrefs();

        return AppResultState.success(decodedResponse.message);
      } else {
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<String>> deleteAccount() async {
    try {
      final _response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.deleteAccount,
          headerWithAuth: true,
          parameter: null);
      final decodedResponse = BaseResponse.fromJson(jsonEncode(_response.data));
      if (decodedResponse.status == 200) {
        // Clear user preferences after successful account deletion
     await AppStateManagerState.shared.deleteUser();
          await  UserPref.clearPrefs();

        return AppResultState.success(decodedResponse.message);
      } else {
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }


  Future<AppResultState<String>> socialLogin(SocialLoginModel model) async {
    try {
      final _response = await _networkClient.request(
          requestType: RequestType.POST,
          path: NetworkEndPoints.socialLogin,
          headerWithAuth: false,
          parameter: model.toJson());
      final decodedResponse = BaseResponse.fromJson(_response.body);

      if (decodedResponse.status == 200) {
        // Signup was successful
        if (decodedResponse.token != null) {
          if (decodedResponse.jsonData?['image'] != null) {
            decodedResponse.jsonData?['image'] =
                '${ServerSettings.uploadBaseURL}${decodedResponse.jsonData?['image']}';
          }
          String jsonString = jsonEncode(decodedResponse.jsonData);

          UserPref.persistUserData(jsonString);

          return AppResultState.success(decodedResponse.message);
        }
      }
      return AppResultState.error(decodedResponse.message);
    } catch (error) {
      // Handle network or other errors

      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<String>> signup(SignupRequest signupData) async {
    try {
      final FormData formData = FormData.fromMap({
        'email': signupData.email,
        'first_name': signupData.firstName,
        'last_name': signupData.lastName,
        'phone': signupData.phone,
        'password': signupData.password,
        'device_id': '987675rdtcfvghbhn7867',
        'device_type': 'iPhone',
        'fcm_token': '09876ftyvghbhjnkoi8978g67t'
      });
      final _response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.register,
          headerWithAuth: false,
          parameter: formData);
      final decodedResponse = BaseResponse.fromJson(jsonEncode(_response.data));
      if (decodedResponse.status == 200) {
        if (decodedResponse.token != null) {
          // Do additional processing if needed
          String jsonString = jsonEncode(decodedResponse.jsonData);
          UserPref.persistUserToken(decodedResponse.token ?? '');
          await AppStateManagerState.shared.getUserData();
          UserPref.persistUserData(jsonString);
          Constants.token =
              await UserPref.getUserToken() ?? decodedResponse.token ?? '';
          return AppResultState.success(decodedResponse.message);
        } else {
          return AppResultState.error(decodedResponse.message);
        }
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<String>> reSendOTP() async {
    try {
      final _response = await _networkClient.request(
        requestType: RequestType.GET,
        path: NetworkEndPoints.resendOTP,
        headerWithAuth: true,
      );
      final decodedResponse = BaseResponse.fromJson(_response.body);
      if (decodedResponse.status == 200) {
        return AppResultState.success(decodedResponse.message);
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<String>> verifyOTP(String otp) async {
    try {
      final _response = await _networkClient.request(
        requestType: RequestType.POST,
        path: NetworkEndPoints.verifyOTP,
        headerWithAuth: true,
        parameter: {
          'code': otp,
        },
      );
      final decodedResponse = BaseResponse.fromJson(_response.body);
      if (decodedResponse.status == 200) {
        return AppResultState.successNavigate(decodedResponse.message);
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<String>> changePassword(
      String oldPassword, String password, bool isForgot) async {
    try {
      final _response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.changepassword,
          headerWithAuth: true,
          parameter: jsonEncode({
            'password': password,
            'old_password': oldPassword,
            'is_forgot': isForgot ? '1' : '0'
          }));
      final decodedResponse = BaseResponse.fromJson(jsonEncode(_response.data));
      if (decodedResponse.status == 200) {
        return AppResultState.successNavigate(decodedResponse.message);
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<String>> forgotPassword(String phone) async {
    try {
      final _response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.forgotPassword,
          headerWithAuth: false,
          parameter: jsonEncode({"phone": phone}));
      final decodedResponse = BaseResponse.fromJson(jsonEncode(_response.data));
      print(decodedResponse);
      if (decodedResponse.token != null) {
        // Do additional processing if needed
        UserPref.persistUserToken(decodedResponse.token ?? '');
        await AppStateManagerState.shared.getUserData();
        Constants.token =
            await UserPref.getUserToken() ?? decodedResponse.token ?? '';
        return AppResultState.successNavigate(decodedResponse.message);
      } else {
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }
}
