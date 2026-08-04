import 'dart:convert';

import 'package:blood_synergy_app/Models/SignupReqModel.dart';
import 'package:blood_synergy_app/Models/SocialLoginRequestModel.dart';
import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:blood_synergy_app/helpers/BaseModel.dart';
import 'package:blood_synergy_app/helpers/Constants.dart';

import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/enumhoarder.dart';
import 'package:blood_synergy_app/helpers/password_reset_storage.dart';
import 'package:blood_synergy_app/network_helpers/NetworkEndpoint.dart';

import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:blood_synergy_app/network_helpers/serverSettings.dart';
import 'package:dio/dio.dart';

class AuthenticationRepository {
  final NetworkClient _networkClient;

  AuthenticationRepository(this._networkClient);

  FormData _cloneFormData(FormData source) {
    return FormData.fromMap({
      for (final field in source.fields) field.key: field.value,
      for (final file in source.files) file.key: file.value,
    });
  }

  String? _extractWebAuthToken(dynamic data) {
    Map<String, dynamic>? json;
    if (data is Map<String, dynamic>) {
      json = data;
    } else if (data is Map) {
      json = Map<String, dynamic>.from(data);
    } else if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          json = decoded;
        } else if (decoded is Map) {
          json = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }
    if (json == null || json['success'] != true) return null;

    return json['auth_token']?.toString() ??
        json['token']?.toString() ??
        json['webAuthToken']?.toString() ??
        json['access_token']?.toString();
  }

  Future<void> _syncWebAuth({
    required FormData formData,
    required String mainPath,
  }) async {
    try {
      final response = await _networkClient.dioMainApiRequest(
        path: mainPath,
        parameter: _cloneFormData(formData),
      );
      print('Web auth response: ${response.data}');
      final webToken = _extractWebAuthToken(response.data);
      if (webToken != null && webToken.isNotEmpty) {
        print("Web Token: $webToken");
        UserPref.persistWebUserToken(webToken);
      }
    } catch (e) {
      print('Web auth sync failed: $e');
    }
  }

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
          String jsonString = jsonEncode(decodedResponse.jsonData);
          UserPref.persistUserToken(decodedResponse.token ?? '');
          UserPref.persistUserData(jsonString);
          Constants.token =
              await UserPref.getUserToken() ?? decodedResponse.token ?? '';

          final webFormFields = {
            for (final field in data.fields) field.key: field.value,
          };
          final email = decodedResponse.jsonData?['email']?.toString();
          if (email != null && email.isNotEmpty) {
            webFormFields['email'] = email;
          }
          await _syncWebAuth(
            formData: FormData.fromMap(webFormFields),
            mainPath: NetworkEndPoints.mainLogin,
          );

          return AppResultState.success(decodedResponse.message);
        } else {
          return AppResultState.error(decodedResponse.message);
        }
      } else {
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
      print('DEBUG: Starting signup...');
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
      print('DEBUG: Calling register API...');
      final _response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.register,
          headerWithAuth: false,
          parameter: formData);
      print('DEBUG: Got response: ${_response.data}');
      final decodedResponse = BaseResponse.fromJson(jsonEncode(_response.data));
      print('DEBUG: Decoded response status: ${decodedResponse.status}');
      if (decodedResponse.status == 200) {
        if (decodedResponse.token != null) {
          print('DEBUG: Token received, saving user data...');
          String jsonString = jsonEncode(decodedResponse.jsonData);
          UserPref.persistUserToken(decodedResponse.token ?? '');
          await AppStateManagerState.shared.getUserData();
          UserPref.persistUserData(jsonString);
          Constants.token =
              await UserPref.getUserToken() ?? decodedResponse.token ?? '';

          print('DEBUG: Starting web auth sync (non-blocking)...');
          // Don't await - run in background so it doesn't block signup
          _syncWebAuth(
            formData: formData,
            mainPath: NetworkEndPoints.mainRegister,
          );

          print('DEBUG: Signup successful!');
          return AppResultState.success(decodedResponse.message);
        } else {
          print('DEBUG: No token in response');
          return AppResultState.error(decodedResponse.message ?? 'Registration failed');
        }
      } else {
        print('DEBUG: Non-200 status: ${decodedResponse.status}');
        return AppResultState.error(decodedResponse.message ?? 'Registration failed');
      }
    } catch (error) {
      print('DEBUG: Signup error: $error');
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
      String? resetToken;
      if (isForgot) {
        if (!PasswordResetStorage.isOtpVerified) {
          return AppResultState.error(
              'Please verify the email code before changing your password.');
        }

        resetToken = PasswordResetStorage.resetToken;
        if (resetToken == null || resetToken.isEmpty) {
          return AppResultState.error(
              'Password reset session expired. Please try again.');
        }
      }

      final _response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.changepassword,
          headerWithAuth: true,
          bearerToken: resetToken,
          parameter: jsonEncode({
            'password': password,
            'old_password': oldPassword,
            'is_forgot': isForgot ? '1' : '0'
          }));
      final decodedResponse = BaseResponse.fromJson(jsonEncode(_response.data));
      if (decodedResponse.status == 200) {
        if (isForgot) {
          await PasswordResetStorage.clear();
        }
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
      final url =
          '${ServerSettings.baseURL}${NetworkEndPoints.forgotPassword}';
      final requestBody = jsonEncode({'phone': phone});

      print('[FORGOT_PASSWORD] API URL: $url');
      print('[FORGOT_PASSWORD] Request body: $requestBody');

      final _response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.forgotPassword,
          headerWithAuth: false,
          parameter: requestBody);

      print('[FORGOT_PASSWORD] HTTP status: ${_response.statusCode}');
      print('[FORGOT_PASSWORD] Raw response: ${_response.data}');

      final decodedResponse = BaseResponse.fromJson(jsonEncode(_response.data));
      print('[FORGOT_PASSWORD] Parsed status: ${decodedResponse.status}');
      print('[FORGOT_PASSWORD] Parsed message: ${decodedResponse.message}');
      print('[FORGOT_PASSWORD] Reset token: ${decodedResponse.token}');

      final email = decodedResponse.jsonData?['email']?.toString().trim();
      print('[FORGOT_PASSWORD] Reset email: $email');

      if (decodedResponse.status == 200 &&
          decodedResponse.token != null &&
          decodedResponse.token!.isNotEmpty &&
          email != null &&
          email.isNotEmpty) {
        await PasswordResetStorage.saveSession(
          resetToken: decodedResponse.token!,
          email: email,
        );
        return AppResultState.successNavigate(email);
      } else {
        return AppResultState.error(
            decodedResponse.message ?? 'Could not start password reset.');
      }
    } catch (error) {
      print('[FORGOT_PASSWORD] Request failed: $error');
      return AppResultState.error(error.toString());
    }
  }
}
