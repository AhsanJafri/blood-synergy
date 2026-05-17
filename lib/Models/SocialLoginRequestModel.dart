class SocialLoginModel {
  final String id;
  final String name;
  final String nickname;
  final String email;
  final String avatar;
  final String type;

  SocialLoginModel({
    required this.id,
    required this.name,
    required this.nickname,
    required this.email,
    required this.avatar,
    required this.type,
  });

  factory SocialLoginModel.fromJson(Map<String, dynamic> json) {
    return SocialLoginModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'email': email,
      'avatar': avatar,
      'type': type,
    };
  }
}
