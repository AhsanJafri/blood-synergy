class SignupRequest {
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? password;
  String? deviceId;
  String? deviceType;
  String? fcmToken;

  SignupRequest({
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.password,
    this.deviceId,
    this.deviceType,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'password': password,
      'device_id': deviceId,
      'device_type': deviceType,
      'fcm_token': fcmToken,
    };
  }
}
