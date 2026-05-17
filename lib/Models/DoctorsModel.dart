import 'dart:convert';

import 'package:blood_synergy_app/network_helpers/serverSettings.dart';

class DoctorModel {
  final int id;
  final String name;
  final String city;
  final String? image;

  DoctorModel({
    required this.id,
    required this.name,
    required this.city,
    required this.image,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final String? image =
        (json["image"] != null && !(json["image"] as String).contains("http"))
            ? "${ServerSettings.uploadBaseURL}${json["image"]}"
            : null;

    return DoctorModel(
      id: json["id"],
      name: json["name"],
      city: json["city"],
      image: image,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "city": city,
        "image": image,
      };
}

class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String hospital;
  final int experience; // in years
  final String contact;
  final String imageUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.hospital,
    required this.experience,
    required this.contact,
    required this.imageUrl,
  });

  // Convert a Doctor object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'hospital': hospital,
      'experience': experience,
      'contact': contact,
      'imageUrl': imageUrl,
    };
  }

  // Convert a JSON map to a Doctor object
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      hospital: json['hospital'] as String,
      experience: json['experience'] as int,
      contact: json['contact'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  // Optional: Convert a JSON string to a Doctor object
  static Doctor fromJsonString(String jsonString) {
    final jsonData = json.decode(jsonString);
    return Doctor.fromJson(jsonData);
  }

  // Optional: Convert a Doctor object to a JSON string
  String toJsonString() {
    final jsonData = toJson();
    return json.encode(jsonData);
  }
}

final List<Doctor> dummyDoctors = [
  Doctor(
    id: '1',
    name: 'Dr. John Smith',
    specialization: 'Nutritionist',
    hospital: 'City Heart Center',
    experience: 15,
    contact: '+1-123-456-7890',
    imageUrl:
    'https://s3-alpha-sig.figma.com/img/1c61/0a8c/b8fcfe06ce5766161269d399938c2cd4?Expires=1725235200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=bqBnk4pDEKPkkrlmrBioABqlnCDJeu0l5yc8Ia9UU73rSUyqSGq4FEhQpLgBxbH2QwNtXS0hQ0KAOMSzrFJdj7t86cjLYG9kX3RNI9YZf5IwZJoo4OS3n~DjKY~L11HsVavteN~yIgA0kCQarP3kR5DSSu4F~Bvh7kv3ujAtj0QA1ZwFGpi9Gcu4gUZO9WgFyvU~tY9Gf0eyJgLbexPmx1I1XaObnnhUh0yZ38NNq5uRJjtKAC-u66dLmXoGPw8LAGlYMlupH9nMXG8V-w0oyfOy0AZMrpxtFVsWC6KJjzpNIVQIFFXHPWZPBacj3nlSJ1OuzY-0jmT7hpJkrQOq0w__',
  ),
  // Doctor(
  //   id: '1',
  //   name: 'Dr. John Smith',
  //   specialization: 'Nutritionist',
  //   hospital: 'City Heart Center',
  //   experience: 15,
  //   contact: '+1-123-456-7890',
  //   imageUrl:
  //       'https://s3-alpha-sig.figma.com/img/1c61/0a8c/b8fcfe06ce5766161269d399938c2cd4?Expires=1725235200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=bqBnk4pDEKPkkrlmrBioABqlnCDJeu0l5yc8Ia9UU73rSUyqSGq4FEhQpLgBxbH2QwNtXS0hQ0KAOMSzrFJdj7t86cjLYG9kX3RNI9YZf5IwZJoo4OS3n~DjKY~L11HsVavteN~yIgA0kCQarP3kR5DSSu4F~Bvh7kv3ujAtj0QA1ZwFGpi9Gcu4gUZO9WgFyvU~tY9Gf0eyJgLbexPmx1I1XaObnnhUh0yZ38NNq5uRJjtKAC-u66dLmXoGPw8LAGlYMlupH9nMXG8V-w0oyfOy0AZMrpxtFVsWC6KJjzpNIVQIFFXHPWZPBacj3nlSJ1OuzY-0jmT7hpJkrQOq0w__',
  // ),
  // Doctor(
  //   id: '2',
  //   name: 'Dr. Emily Watson',
  //   specialization: 'Nutritionist',
  //   hospital: 'Sunrise Children Hospital',
  //   experience: 10,
  //   contact: '+1-987-654-3210',
  //   imageUrl:
  //       'https://www.figma.com/file/KtK2xGzjHufkwJYkA1yvWv/image/efd8fb48d9a55aea568720f38067c02cb11aa3c4',
  // ),
  // Doctor(
  //   id: '3',
  //   name: 'Dr. Robert Brown',
  //   specialization: 'Nutritionist',
  //   hospital: 'Brain Health Clinic',
  //   experience: 20,
  //   contact: '+1-555-123-4567',
  //   imageUrl:
  //       'https://s3-alpha-sig.figma.com/img/1c52/7fd4/e2583d14759c76eb45c7180ba964c2b3?Expires=1725235200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=hGzVFctv1AEnDOzdOcwi80WEuD0j~xSHjvoBUhcHNZbRdsVpAgHFYeZGq88B5-~65ixBdBzcJiM8dM-HH3KLB5m7ZV89sp2LOxSZVxD4RVAnhSsc58hb2vovOw4fY~opGDKf6iFromkof7OZ8y9SDemmBwHlMUwYvVBBocYB1s3ulpnvKMHqbz3hLGVDBL~fDBsnuqOtREjCIC8L1okfzyPXnGgjs1QPZwcGMJyKh3RigmJ7GACTVywyfDCgIT9YV6pdAWNah8kOSgMlUl7lGOQ-BEO6iF17LdVPSpHYiG35M757Ac2TBmFEcr3QMbhLsYSJGvrKk~jJhgQuGkOP3w__',
  // ),
  // Doctor(
  //   id: '4',
  //   name: 'Dr. Sarah Taylor',
  //   specialization: 'Nutritionist',
  //   hospital: 'Skin Care Center',
  //   experience: 8,
  //   contact: '+1-444-987-6543',
  //   imageUrl:
  //       'https://s3-alpha-sig.figma.com/img/ffde/5add/3f8810e5e06d86c7a38d67c0cf601038?Expires=1725235200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=mALC0IlT1rLoeiTbMsRtndKRm0aqnh4LDVlbUKxJx6ZTTx74~pvJ4aRfBUT78P3KNLHH8jrueOIIawI42UJ9DRV~pQzbK~d2A-MS~nSheghGoQPPqqZ32Ih8UWhTA~uK62U1Lheo-e4j6vJtg5dOGcw5yQqOdGXaD5ZJ6ZclLhA6I6zZeaRAOJSZsbG0-MVwyU0-5TM5whdL4am~RurF3dEfG~yT-yq6VOFcCtr3HXjwFfGWkSmtF7E-yM6diMdEpFf-lCbAN-X0e8FI2VqB6lQK0aHyQ4joNG-QZ~SJy8JskTZYtKtr8YGd5Fb44MGSVJF~xfjDGFPkNxOcIcNTRA__',
  // ),
  // Doctor(
  //   id: '5',
  //   name: 'Dr. Michael Johnson',
  //   specialization: 'Nutritionist',
  //   hospital: 'Joint Relief Hospital',
  //   experience: 12,
  //   contact: '+1-666-234-5678',
  //   imageUrl:
  //       'https://www.figma.com/file/KtK2xGzjHufkwJYkA1yvWv/image/3a7ee9ce169566d9cb54c1c121b8b1bf68568e38',
  // ),
  // Doctor(
  //   id: '6',
  //   name: 'Dr. Angela Green',
  //   specialization: 'Nutritionist',
  //   hospital: 'Vision Care Center',
  //   experience: 18,
  //   contact: '+1-777-345-6789',
  //   imageUrl:
  //       'https://www.figma.com/file/KtK2xGzjHufkwJYkA1yvWv/image/efd8fb48d9a55aea568720f38067c02cb11aa3c4',
  // ),
  // Doctor(
  //   id: '7',
  //   name: 'Dr. William Davis',
  //   specialization: 'Nutritionist',
  //   hospital: 'Cancer Treatment Institute',
  //   experience: 22,
  //   contact: '+1-888-456-7890',
  //   imageUrl:
  //       'https://s3-alpha-sig.figma.com/img/15cd/367a/ef91a9fc7278637c5e18ea4a76b4312e?Expires=1725235200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=g0e0BA9x44iUBd6-YeeXdStA8dX5OEXUeGfZsCpNQt97fGKC-3vGSI3KxI6NOx6-NiMLgx2PbSFCoDbtpUu5AIIqVr9CMlYuEhCQSDzhy7DIck2VIBWqPocSk1JFEVUOdfvIIjbkfLW8M2NcoDVr1KL~0Qo~~hWoehwpr2~48zqjNl0V1xhioKyitfwqBRizhtCl0zWNJDLZRz3vkW0omlw3UUoF0E4QtoZwJLhHZtrvfODsVNnUd63mxCDc~3Klv2CkSZuqxISzGkSwejdfvro02BWAG7zaCaddhDNwbZrvSC705P08s4GW~lnhc1gpoX~RLtZKdLMcqo05gaxhxQ__',
  // ),
];
