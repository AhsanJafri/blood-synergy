import 'package:blood_synergy_app/network_helpers/serverSettings.dart';

class Categories {
  int id;
  String? name;
  String? shortCode;
  String? icon;
  String? shortDescription;

  Categories({
    required this.id,
    required this.name,
    required this.shortCode,
    required this.icon,
    required this.shortDescription,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    final String? image =
        json["icon"] != null && (json["icon"] as String).isNotEmpty
            ? "${ServerSettings.uploadBaseURL}${json["icon"]}"
            : null;

    return Categories(
      id: json["id"],
      name: json["name"],
      shortCode: json["short_code"],
      icon: image,
      shortDescription: json["short_description"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_code": shortCode,
        "icon": icon,
        "short_description": shortDescription,
      };
}
