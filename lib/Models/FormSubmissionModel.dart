class FormSubmissionModel {
  int? id;
  String? value;
  int? categoryId;

  FormSubmissionModel({
    this.id,
    this.value,
    this.categoryId,
  });

  factory FormSubmissionModel.fromJson(Map<String, dynamic> json) =>
      FormSubmissionModel(
        id: json["id"],
        value: json["value"],
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "value": value.toString(),
        "category_id": categoryId.toString(),
      };
}
