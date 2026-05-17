import 'package:blood_synergy_app/helpers/Constants.dart';
import 'package:blood_synergy_app/network_helpers/serverSettings.dart';

class ReportsModel {
  int categoryId;
  int reportId;
  String reportName;
  int isPositive;
  String createdAt;
  User user;

  ReportsModel({
    required this.categoryId,
    required this.reportId,
    required this.reportName,
    required this.isPositive,
    required this.createdAt,
    required this.user,
  });

  factory ReportsModel.fromJson(Map<String, dynamic> json) => ReportsModel(
        categoryId: json["category_id"],
        reportId: json["report_id"],
        reportName: json["report_name"],
        isPositive: json["is_positive"],
        createdAt: json["created_at"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "report_id": reportId,
        "report_name": reportName,
        "is_positive": isPositive,
        "created_at": createdAt,
        "user": user.toJson(),
      };
}

class User {
  int id;
  String image;

  User({
    required this.id,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final String? image =
        (json["image"] != null && !(json["image"] as String).contains("http"))
            ? "${ServerSettings.uploadBaseURL}${json["image"]}"
            : null;
    return User(
      id: json["id"],
      image: image ?? Constants.placeHolderImage,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}
