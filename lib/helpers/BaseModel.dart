import 'dart:convert';

class BaseResponse<T> {
  final int status;
  final String message;
  final Map<String, dynamic>? jsonData; // jsonData can be null
  final String? token; // token can be null
  final Pagination? pagination; // Include pagination

  BaseResponse({
    required this.status,
    required this.message,
    required this.jsonData,
    required this.token,
    required this.pagination,
  });

  factory BaseResponse.fromJson(
    String jsonString,
  ) {
    print('hi this is string');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    Map<String, dynamic>? jsonData;
    String? token;
    Pagination? pagination;

    if (json.containsKey('data')) {
      jsonData = json['data'];
    }

    if (json.containsKey('token')) {
      token = json['token'];
    }
    if (json.containsKey('pagination')) {
      pagination = Pagination.fromJson(json['pagination']);
    }
    return BaseResponse(
      status: json['status'],
      message: json['message'],
      jsonData: jsonData,
      token: token,
      pagination: pagination,
    );
  }
}

class BaseListResponse<T> {
  final int status;
  final String message;
  final List<Map<String, dynamic>>? jsonData;
  final String? token;
  final Pagination? pagination;

  BaseListResponse({
    required this.status,
    required this.message,
    required this.jsonData,
    required this.token,
    required this.pagination,
  });

  static List<Map<String, dynamic>> convertListToMapList(
      List<dynamic> dynamicList) {
    List<Map<String, dynamic>> mapList = [];

    for (dynamic item in dynamicList) {
      if (item is Map<String, dynamic>) {
        mapList.add(item);
      }
    }
    return mapList;
  }

  factory BaseListResponse.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    List<Map<String, dynamic>>? jsonData;
    String? token;
    Pagination? pagination;

    if (json.containsKey('data')) {
      List<dynamic> list = json['data'];
      jsonData = convertListToMapList(list);
    }

    if (json.containsKey('token')) {
      token = json['token'];
    }

    if (json.containsKey('pagination')) {
      pagination = Pagination.fromJson(json['pagination']);
    }

    return BaseListResponse(
      status: json['status'],
      message: json['message'],
      jsonData: jsonData,
      token: token,
      pagination: pagination,
    );
  }
}

class Pagination {
  final int? totalPages;
  final int? pageNumber;

  Pagination({
    this.totalPages,
    this.pageNumber,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalPages: json["total_pages"],
        pageNumber: json["page_number"],
      );

  Map<String, dynamic> toJson() => {
        "total_pages": totalPages,
        "page_number": pageNumber,
      };
}
