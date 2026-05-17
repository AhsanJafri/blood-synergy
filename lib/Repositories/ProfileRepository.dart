import 'dart:convert';

import 'package:blood_synergy_app/Models/UserModel.dart';
import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:blood_synergy_app/helpers/AppStateManager.dart';
import 'package:blood_synergy_app/helpers/BaseModel.dart';
import 'package:blood_synergy_app/helpers/Constants.dart';

import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/enumhoarder.dart';
import 'package:blood_synergy_app/network_helpers/NetworkEndpoint.dart';

import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class ProfileRepository {
  final NetworkClient _networkClient;

  ProfileRepository(this._networkClient);

  Future<AppResultState<String>> updateProfile(CurrentUser user) async {
    var data = FormData.fromMap({
      'image': [
        user.imagePath != null
            ? await MultipartFile.fromFile(user.imagePath!,
                filename: 'image.jpg')
            : MultipartFile.fromBytes(
                (await rootBundle.load('assets/images/profilePlaceHolder.jpg'))
                    .buffer
                    .asUint8List(),
                filename: 'image.jpg'),
      ],
      'gender': user.gender,
      'age': user.age,
      'medical_history': user.medicalHistory
    });
    try {
      final _response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.editProfile,
          headerWithAuth: true,
          parameter: data);

      final decodedResponse = BaseResponse.fromJson(jsonEncode(_response.data));
      if (decodedResponse.status == 200) {
        return await getProfile(fromUpdateMethod: true);
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<String>> getProfile(
      {bool fromUpdateMethod = false}) async {
    try {
      final _response = await _networkClient.request(
        requestType: RequestType.GET,
        path: NetworkEndPoints.getProfile,
        headerWithAuth: true,
      );
      final decodedResponse = BaseResponse.fromJson(_response.body);
      if (decodedResponse.status == 200) {
        // Do additional processing if needed
        String jsonString = jsonEncode(decodedResponse.jsonData);
        await AppStateManagerState.shared.getUserData();
        UserPref.persistUserData(jsonString);
        if (fromUpdateMethod) {
          return AppResultState.successNavigate('');
        } else {
          return AppResultState.success(decodedResponse.message);
        }
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }
}
