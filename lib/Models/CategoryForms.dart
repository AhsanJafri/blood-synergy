import 'package:flutter/material.dart';

class CategoryForm {
  int id;
  String? name;
  String? shortDescription;
  List<TestForm>? forms;

  CategoryForm({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.forms,
  });

  factory CategoryForm.fromJson(Map<String, dynamic> json) => CategoryForm(
        id: json["id"],
        name: json["name"],
        shortDescription: json["short_description"],
        forms: json["forms"] == null
            ? []
            : List<TestForm>.from(
                json["forms"]!.map((x) => TestForm.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_description": shortDescription,
        "forms": forms == null
            ? []
            : List<dynamic>.from(forms!.map((x) => x.toJson())),
      };
}

class TestForm {
  int id;
  int? categoryId;
  String? label;
  String? unit;
  int? isRatio;
  TextEditingController controller = TextEditingController();

  TestForm({
    required this.id,
    required this.categoryId,
    required this.label,
    required this.unit,
    controller,
    required this.isRatio,
  });

  factory TestForm.fromJson(Map<String, dynamic> json) => TestForm(
        id: json["id"],
        categoryId: json["category_id"],
        label: json["label"],
        unit: json["unit"],
        isRatio: json["is_ratio"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "label": label,
        "unit": unit,
        "is_ratio": isRatio,
      };
}
