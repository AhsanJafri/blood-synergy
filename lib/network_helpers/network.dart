import 'dart:convert';
import 'dart:io';

import 'package:blood_synergy_app/helpers/enumhoarder.dart';
import 'package:blood_synergy_app/helpers/nothing.dart';
import 'package:blood_synergy_app/network_helpers/serverSettings.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:blood_synergy_app/helpers/Constants.dart';
import 'package:http/http.dart';

class NetworkClient {
  final Client _client;
  final Dio.Dio dio;
  String buildQueryString(Map<String, dynamic> parameters) {
    return parameters.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
  }

  NetworkClient(this._client, {required this.dio});
  Future<Response> request(
      {required RequestType requestType,
      String? path,
      bool? headerWithAuth,
      dynamic parameter = Nothing}) async {
    switch (requestType) {
      case RequestType.GET:
        print("Path of the request: ${'${ServerSettings.baseURL}$path'}");

        if (parameter == Nothing) {
          print('${ServerSettings.baseURL}$path');

          return _client.get(Uri.parse('${ServerSettings.baseURL}$path'),
              headers: headerWithAuth == true
                  ? (ServerSettings.headerWithAuth(Constants.token))
                  : (ServerSettings.headers));
        } else {
          String queryString =
              parameter.isNotEmpty ? '?${buildQueryString(parameter)}' : '';
          print('${ServerSettings.baseURL}$path$queryString');

          print(queryString);
          return _client.get(
              Uri.parse('${ServerSettings.baseURL}$path$queryString'),
              headers: headerWithAuth == true
                  ? (ServerSettings.headerWithAuth(Constants.token))
                  : (ServerSettings.headers));
        }
      case RequestType.POST:
        print(parameter);

        print("'${ServerSettings.baseURL}$path'");
        print(headerWithAuth == true
            ? (ServerSettings.headerWithAuth(Constants.token))
            : (ServerSettings.headers));
        return _client.post(Uri.parse('${ServerSettings.baseURL}$path'),
            headers: headerWithAuth == true
                ? ServerSettings.headerWithAuth(Constants.token)
                : {},
            body: jsonEncode(parameter));
      case RequestType.PUT:
        print("'${ServerSettings.baseURL}$path'");
        print(headerWithAuth == true
            ? (ServerSettings.headerWithAuth(Constants.token))
            : (ServerSettings.headers));
        print(parameter);
        return _client.put(Uri.parse('${ServerSettings.baseURL}$path'),
            headers: headerWithAuth == true
                ? ServerSettings.headerWithAuth(Constants.token)
                : ServerSettings.headers,
            body: parameter);
      case RequestType.DELETE:
        print("'${ServerSettings.baseURL}$path'");
        print(headerWithAuth == true
            ? (ServerSettings.headerWithAuth(Constants.token))
            : (ServerSettings.headers));
        return _client.delete(Uri.parse('${ServerSettings.baseURL}$path'),
            headers: headerWithAuth == true
                ? (ServerSettings.headerWithAuth(Constants.token))
                : (ServerSettings.headers));
    }
  }

  Future<Dio.Response> dioRequest(
      {required requestType,
      String? path,
      bool? headerWithAuth,
      dynamic parameter = Nothing}) async {
    // switch(requestType){
    // case RequestType.POST:
    print("'${ServerSettings.baseURL}$path'");
    print(headerWithAuth == true
        ? (ServerSettings.headerWithAuth(Constants.token))
        : (ServerSettings.headers));
    return dio.post('${ServerSettings.baseURL}$path',
        data: parameter,
        options: Dio.Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headerWithAuth == true
              ? ServerSettings.dioHeaderWithAuth(Constants.token)
              : {
                  "contentType": 'multipart/form-data',
                },
        ));
    //}
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
