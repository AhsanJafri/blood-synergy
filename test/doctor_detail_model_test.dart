import 'package:blood_synergy_app/Models/DoctorDetailModel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoctorDetailModel.fromJson', () {
    test('maps education to educationHtml and keeps contact fields', () {
      final model = DoctorDetailModel.fromJson({
        'id': 1,
        'name': 'Dr. Test',
        'email': 'doc@example.com',
        'phone': '+10000000000',
        'city': 'Chandler, AZ',
        'address': '123 Main St',
        'personal_site': 'example.com',
        'description': 'About the doctor',
        'education': '<h1>Education</h1><ul><li>MD</li></ul>',
        'experience': '<h1>Experience</h1><ul><li>10 years</li></ul>',
      });

      expect(model.id, 1);
      expect(model.name, 'Dr. Test');
      expect(model.email, 'doc@example.com');
      expect(model.city, 'Chandler, AZ');
      expect(model.educationHtml, contains('Education'));
      expect(model.experience, contains('Experience'));
      expect(model.personalSite, 'example.com');
    });

    test('allows missing education while city/contact remain', () {
      final model = DoctorDetailModel.fromJson({
        'id': 2,
        'name': 'Dr. No Education',
        'city': 'Dallas, TX',
        'email': 'noedu@example.com',
        'phone': '+12223334444',
        'description': 'Still has an about section',
      });

      expect(model.educationHtml, isNull);
      expect(model.experience, isNull);
      expect(model.city, 'Dallas, TX');
      expect(model.email, 'noedu@example.com');
      expect(model.phone, '+12223334444');
      expect(model.description, isNotEmpty);
    });

    test('parses string id', () {
      final model = DoctorDetailModel.fromJson({
        'id': '42',
        'name': 'Dr. Forty Two',
      });
      expect(model.id, 42);
    });
  });
}
