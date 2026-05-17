import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:blood_synergy_app/helpers/BaseModel.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/enumhoarder.dart';
import 'package:blood_synergy_app/network_helpers/NetworkEndpoint.dart';

import 'package:blood_synergy_app/network_helpers/network.dart';

// import '../helpers/AppNavigator.dart';

class HomeRepository {
  final NetworkClient _networkClient;

  HomeRepository(this._networkClient);

  Future<AppResultState<dynamic>> getCategories() async {
    try {
      final response = await _networkClient.request(
        requestType: RequestType.GET,
        path: NetworkEndPoints.getCatergories,
        headerWithAuth: true,
      );
      print(response.body);
      final decodedResponse = BaseListResponse.fromJson(response.body);
      print(decodedResponse);
      // return AppResultState.error(response.body);
      if (decodedResponse.status == 200) {
        return AppResultState.successWithData(decodedResponse.jsonData);
      } else if (decodedResponse.status == 401) {
        UserPref.clearPrefs();
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      } else {
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<dynamic>> getDoctors() async {
    try {
      final response = await _networkClient.request(
        requestType: RequestType.GET,
        path: NetworkEndPoints.getDoctors,
        headerWithAuth: true,
      );
      print(response.body);
      final decodedResponse = BaseListResponse.fromJson(response.body);
      print(decodedResponse);
      // return AppResultState.error(response.body);
      if (decodedResponse.status == 200) {
        return AppResultState.successWithData(decodedResponse.jsonData);
      } else if (decodedResponse.status == 401) {
        UserPref.clearPrefs();
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      } else {
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<dynamic>> getSupplements() async {
    try {
      final response = await _networkClient.request(
        requestType: RequestType.GET,
        path: NetworkEndPoints.getSupplements,
        headerWithAuth: true,
      );
      print(response.body);
      final decodedResponse = BaseListResponse.fromJson(response.body);
      print(decodedResponse);
      // return AppResultState.error(response.body);
      if (decodedResponse.status == 200) {
        return AppResultState.successWithData(decodedResponse.jsonData);
      } else if (decodedResponse.status == 401) {
        UserPref.clearPrefs();
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      } else {
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<dynamic>> getDoctorDetail(int doctorId) async {
    try {
      final response = await _networkClient.request(
        requestType: RequestType.GET,
        path: NetworkEndPoints.getDoctorDetail,
        headerWithAuth: true,
        parameter: {"doctor_id": doctorId},
      );
      final decodedResponse = BaseResponse.fromJson(response.body);
      if (decodedResponse.status == 200) {
        return AppResultState.successWithData(decodedResponse.jsonData);
      } else if (decodedResponse.status == 401) {
        UserPref.clearPrefs();
        return AppResultState.error(decodedResponse.message);
      } else {
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }
}
