import 'package:blood_synergy_app/network_helpers/serverSettings.dart';

class DoctorDetailModel {
  final int id;
  final String name;
  final String? email;
  final String? designation;
  final String? phone;
  final String? personalSite;
  final String? city;
  final String? image; // May be a full URL or an asset path
  final String? address;
  final String? description;
  final String? educationHtml;
  final String? experience;
  final String? createdAt;
  final String? updatedAt;

  DoctorDetailModel({
    required this.id,
    required this.name,
    this.email,
    this.designation,
    this.phone,
    this.personalSite,
    this.city,
    this.image,
    this.address,
    this.description,
    this.educationHtml,
    this.experience,
    this.createdAt,
    this.updatedAt,
  });

  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    String? rawImage = json['image']?.toString();
    String? resolvedImage;
    if (rawImage != null && rawImage.isNotEmpty) {
      if (rawImage.startsWith('http')) {
        resolvedImage = rawImage;
      }  else {
        resolvedImage = '${ServerSettings.uploadBaseURL}$rawImage';
      }
    }

    return DoctorDetailModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: (json['name'] ?? '').toString(),
      email: json['email']?.toString(),
      designation: json['designation']?.toString(),
      phone: json['phone']?.toString(),
      personalSite: json['personal_site']?.toString(),
      city: json['city']?.toString(),
      image: resolvedImage,
      address: json['address']?.toString(),
      description: json['description']?.toString(),
      educationHtml: json['education']?.toString(),
      experience: json['experience']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
