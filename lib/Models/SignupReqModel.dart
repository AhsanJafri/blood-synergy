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

  factory SignupRequest.fromJson(Map<String, dynamic> json) {
    return SignupRequest(
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      deviceId: json['device_id'] as String?,
      deviceType: json['device_type'] as String?,
      fcmToken: json['fcm_token'] as String?,
    );
  }
}
