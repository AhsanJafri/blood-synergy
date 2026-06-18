import 'package:blood_synergy_app/helpers/env_config.dart';

class ServerSettings {
  static String get baseURL => EnvConfig.baseUrl;
  static String get uploadBaseURL => EnvConfig.uploadBaseUrl;
  static String get mainBaseURL => EnvConfig.mainBaseUrl;

  static String mainApiUrl(String path) {
    final base = mainBaseURL.endsWith('/')
        ? mainBaseURL.substring(0, mainBaseURL.length - 1)
        : mainBaseURL;
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return '$base/$normalizedPath';
  }
  static String get socketURL => EnvConfig.socketUrl;
  static String get IMAGE_URL => EnvConfig.imageUrl;

  static var headers = {
    //"Content-Type": "application/x-www-form-urlencoded",
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    'Accept': '*/*',
  };

  static Map<String, String> headerWithAuth(String bearerToken) {
    var headerWithAuth = {
      'Authorization': 'Bearer ${bearerToken}',
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };
    return headerWithAuth;
  }

  static Map<String, String> dioHeaderWithAuth(String bearerToken) {
    var headerWithAuth = {
      "contentType": 'multipart/form-data',
      'Authorization': 'Bearer ${bearerToken}',
      "Accept": "application/json"
    };
    return headerWithAuth;
  }

  static Map<String, String> headerWithAuthJson(String bearerToken) {
    var headerWithAuth = {
      'Authorization': 'Bearer ${bearerToken}',
    };
    return headerWithAuth;
  }
}
