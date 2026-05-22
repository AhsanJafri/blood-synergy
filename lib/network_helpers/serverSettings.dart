class ServerSettings {
  //dev url
  static const String baseURL =
      "https://bloodsynergybackend.trangotech.dev/api/";
  static const String uploadBaseURL =
      "https://bloodsynergybackend.trangotech.dev/";

  static const String mainBaseURL = "https://web.blood-synergy.com";

  static String mainApiUrl(String path) {
    final base = mainBaseURL.endsWith('/')
        ? mainBaseURL.substring(0, mainBaseURL.length - 1)
        : mainBaseURL;
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return '$base/$normalizedPath';
  }
  //dev socket
  static const socketURL = "http://31.186.241.24:3016/";
  //Dev Image Url
  static const IMAGE_URL = "https://netubiebackend.trangotech.dev/";

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
