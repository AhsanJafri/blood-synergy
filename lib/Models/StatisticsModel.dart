import 'dart:developer';

import 'package:flutter/material.dart';

class StatisticsModel {
  final int? status;
  final String? message;
  final Map<String, List<Stats>>? data;

  StatisticsModel({
    this.status,
    this.message,
    this.data,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    print(json);

    return StatisticsModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] != null
          ? Map.from(json["data"]!).map(
              (k, v) => MapEntry<String, List<Stats>>(
                k,
                List<Stats>.from(v.map((x) => Stats.fromJson(x))),
              ),
            )
          : null, // Handle the case where "data" key is absent
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data != null
            ? Map.from(data!).map(
                (k, v) => MapEntry<String, dynamic>(
                  k,
                  List<dynamic>.from(v.map((x) => x.toJson())),
                ),
              )
            : null, // Handle the case where "data" is null
      };
}

class Stats {
  final int? patternId;
  final int? reportId;
  final String? result;
  final DateTime? createdAt;
  final String? patternColor;
  final String? patternRangeColor;
  final String? title;

  Stats({
    this.patternId,
    this.reportId,
    this.title,
    this.result,
    this.createdAt,
    this.patternColor,
    this.patternRangeColor,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        patternId: json["pattern_id"],
        reportId: json["report_id"],
        result: json["result"],
        title: json["title"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        patternColor: json["pattern_color"],
        patternRangeColor: json["pattern_range_color"],
      );

  Map<String, dynamic> toJson() => {
        "pattern_id": patternId,
        "report_id": reportId,
        "result": result,
        "title": title,
        "created_at": createdAt?.toIso8601String(),
        "pattern_color": patternColor,
        "pattern_range_color": patternRangeColor,
      };
}

class ChartData {
  final String category;
  final List<double> values;
  final List<Color> colr;
  final List<double> realValues;
  final List<String> patternColorNames;
  final List<String> titles;

  ChartData(this.category, this.values, this.colr, this.realValues,
      this.patternColorNames, this.titles);
}
