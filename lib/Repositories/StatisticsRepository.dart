import 'dart:convert';

import 'package:blood_synergy_app/Models/StatisticsModel.dart';
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

class StatisticsRepository {
  final NetworkClient _networkClient;
  List<ChartData> chartData = [];
  StatisticsRepository(this._networkClient);

  Future<AppResultState<dynamic>> getStats(String type) async {
    try {
      final _response = await _networkClient.request(
          requestType: RequestType.GET,
          path: NetworkEndPoints.getStats,
          headerWithAuth: true,
          parameter: {'type': type});
      var jsn = jsonDecode(_response.body);
      final decodedResponse = StatisticsModel.fromJson(jsn);
      if (decodedResponse.status == 200) {
        if (decodedResponse.data != null) {
          return AppResultState.successWithData(decodedResponse);
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
}
