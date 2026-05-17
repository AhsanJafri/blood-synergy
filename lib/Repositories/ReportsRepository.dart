import 'dart:convert';

import 'package:blood_synergy_app/helpers/BaseModel.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';
import 'package:blood_synergy_app/helpers/enumhoarder.dart';
import 'package:blood_synergy_app/network_helpers/NetworkEndpoint.dart';

import 'package:blood_synergy_app/network_helpers/network.dart';

class ReportsRepository {
  final NetworkClient _networkClient;

  ReportsRepository(this._networkClient);

  Future<AppResultState<dynamic>> getReports(int categoryID) async {
    try {
      final response = await _networkClient.request(
          requestType: RequestType.GET,
          path: NetworkEndPoints.getReports,
          headerWithAuth: true,
          parameter: {"category_id": categoryID});
      final decodedResponse = BaseListResponse.fromJson(response.body);
      print(decodedResponse);
      if (decodedResponse.status == 200) {
        return AppResultState.successWithData(decodedResponse.jsonData);
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<dynamic>> getReportDetails(
      int categoryID, int reportID) async {
    try {
      final response = await _networkClient.request(
          requestType: RequestType.GET,
          path: NetworkEndPoints.showReports,
          headerWithAuth: true,
          parameter: {"category_id": categoryID, "report_id": reportID});
      final decodedResponse = BaseResponse.fromJson(response.body);
      print(decodedResponse);
      if (decodedResponse.status == 200) {
        return AppResultState.successWithData(decodedResponse.jsonData);
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<dynamic>> getForms(int categoryID) async {
    try {
      final response = await _networkClient.request(
          requestType: RequestType.GET,
          path: NetworkEndPoints.getForms,
          headerWithAuth: true,
          parameter: {"category_id": categoryID});
      final decodedResponse = BaseResponse.fromJson(response.body);
      print(decodedResponse);
      if (decodedResponse.status == 200) {
        return AppResultState.successWithData(decodedResponse.jsonData);
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }

  Future<AppResultState<dynamic>> createReport(
      List<Map<String, dynamic>> model) async {
    try {
      final response = await _networkClient.dioRequest(
          requestType: RequestType.POST,
          path: NetworkEndPoints.createReport,
          headerWithAuth: true,
          parameter: jsonEncode(model));
      final decodedResponse = BaseResponse.fromJson(jsonEncode(response.data));
      print(decodedResponse);
      if (decodedResponse.status == 200) {
        return AppResultState.successNavigate(decodedResponse.jsonData);
      } else {
        // Return an error state with a Failure object
        return AppResultState.error(decodedResponse.message);
      }
    } catch (error) {
      return AppResultState.error(error.toString());
    }
  }
}
