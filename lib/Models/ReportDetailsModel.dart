// To parse this JSON data, do
//
//     final reportsModel = reportsModelFromJson(jsonString);

import 'dart:convert';

class ReportDetail {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<FormAnswer>? formAnswers;
  final AllPatterns? allPatterns;

  ReportDetail({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.formAnswers,
    this.allPatterns,
  });

  factory ReportDetail.fromJson(Map<String, dynamic> json) => ReportDetail(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        formAnswers: json["form_answers"] == null
            ? []
            : List<FormAnswer>.from(
                json["form_answers"]!.map((x) => FormAnswer.fromJson(x))),
        allPatterns: json["patterns"] == null
            ? null
            : AllPatterns.fromJson(json["patterns"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "form_answers": formAnswers == null
            ? []
            : List<dynamic>.from(formAnswers!.map((x) => x.toJson())),
        "patterns": allPatterns?.toJson(),
      };
}

class AllPatterns {
  final List<Pattern>? primary;
  final List<Pattern>? secondary;
  final List<Pattern>? tertiary;

  AllPatterns({
    this.primary,
    this.secondary,
    this.tertiary,
  });

  factory AllPatterns.fromJson(Map<String, dynamic> json) => AllPatterns(
        primary: json["primary"] == null
            ? []
            : List<Pattern>.from(
                json["primary"]!.map((x) => Pattern.fromJson(x))),
        secondary: json["secondary"] == null
            ? []
            : List<Pattern>.from(
                json["secondary"]!.map((x) => Pattern.fromJson(x))),
        tertiary: json["tertiary"] == null
            ? []
            : List<Pattern>.from(
                json["tertiary"]!.map((x) => Pattern.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pattern": primary == null
            ? []
            : List<dynamic>.from(primary!.map((x) => x.toJson())),
        "secondary": secondary == null
            ? []
            : List<dynamic>.from(secondary!.map((x) => x.toJson())),
        "pattern2": tertiary == null
            ? []
            : List<dynamic>.from(tertiary!.map((x) => x.toJson())),
      };
}

class Pattern {
  final int? id;
  final String? title;
  final String? color;
  final String? remarks;
  final String? symptoms;
  final String? result;
  final String? patternColor;

  Pattern({
    this.id,
    this.title,
    this.color,
    this.remarks,
    this.symptoms,
    this.result,
    this.patternColor,
  });

  factory Pattern.fromJson(Map<String, dynamic> json) => Pattern(
        id: json["id"],
        title: json["title"],
        color: json["color"],
        remarks: json["remarks"],
        symptoms: json["symptoms"],
        result: json["result"],
        patternColor: json["pattern_color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "color": color,
        "remarks": remarks,
        "symptoms": symptoms,
        "result": result,
        "pattern_color": patternColor,
      };
}

class FormAnswer {
  final int? formId;
  final String? answer;
  final int? categoryId;
  final int? customerId;
  final int? isPositive;
  final String? label;
  final String? shortCode;
  final String? unit;
  final String? range;

  FormAnswer({
    this.formId,
    this.answer,
    this.categoryId,
    this.customerId,
    this.isPositive,
    this.label,
    this.shortCode,
    this.unit,
    this.range,
  });

  factory FormAnswer.fromJson(Map<String, dynamic> json) => FormAnswer(
        formId: json["form_id"],
        answer: json["answer"],
        categoryId: json["category_id"],
        customerId: json["customer_id"],
        isPositive: json["is_positive"],
        label: json["label"],
        shortCode: json["short_code"],
        unit: json["unit"],
        range: json["range"],
      );

  Map<String, dynamic> toJson() => {
        "form_id": formId,
        "answer": answer,
        "category_id": categoryId,
        "customer_id": customerId,
        "is_positive": isPositive,
        "label": label,
        "short_code": shortCode,
        "unit": unit,
        "range": range,
      };
}
