import 'package:blood_synergy_app/network_helpers/serverSettings.dart';

class CurrentUser {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? image;
  String? imagePath;

  String? gender;
  String? age;
  String? month;
  String? day;
  String? year;
  String? medicalHistory;
  String? fcmToken;
  String? stripeToken;
  String? deviceId;
  String? deviceType;
  int? isVerify;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  Settings? settings;

  CurrentUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.image,
    this.gender,
    this.age,
    this.month,
    this.imagePath,
    this.day,
    this.year,
    this.medicalHistory,
    this.fcmToken,
    this.stripeToken,
    this.deviceId,
    this.deviceType,
    this.isVerify,
    this.isActive,
    this.createdAt,
    this.settings,
    this.updatedAt,
    this.deletedAt,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    final String? image =
        (json["image"] != null && (json["image"] as String).isNotEmpty)
            ? (json["image"] as String).contains("http")
                ? json["image"]
                : "${ServerSettings.uploadBaseURL}${json["image"]}"
            : null;
    return CurrentUser(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      phone: json["phone"],
      image: image,
      gender: json["gender"],
      age: json["age"],
      month: json["month"],
      day: json["day"],
      year: json["year"],
      medicalHistory: json["medical_history"],
      fcmToken: json["fcm_token"],
      stripeToken: json["stripe_token"],
      deviceId: json["device_id"],
      deviceType: json["device_type"],
      isVerify: json["is_verify"],
      isActive: json["is_active"],
      settings:
          json["settings"] == null ? null : Settings.fromJson(json["settings"]),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      deletedAt: json["deleted_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "image": image,
        "gender": gender,
        "age": age,
        "month": month,
        "day": day,
        "year": year,
        "medical_history": medicalHistory,
        "fcm_token": fcmToken,
        "stripe_token": stripeToken,
        "device_id": deviceId,
        "device_type": deviceType,
        "is_verify": isVerify,
        "is_active": isActive,
        "settings": settings?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Settings {
  int? pushNotification;

  Settings({
    this.pushNotification,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        pushNotification: json["push_notification"],
      );

  Map<String, dynamic> toJson() => {
        "push_notification": pushNotification,
      };
}
