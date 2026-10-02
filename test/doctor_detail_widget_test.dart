import 'package:blood_synergy_app/views/screens/Find%20Doctor/doctor_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(360, 690),
    builder: (_, __) => MaterialApp(
      theme: ThemeData(primaryColor: Colors.green),
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DoctorDetail UI', () {
    testWidgets('shows city/contact when education is missing', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DoctorDetail(
            doctor: {
              'id': 1,
              'name': 'Dr. Janine Crifasi',
              'city': 'Chandler, AZ',
              'email': 'janine@example.com',
              'phone': '+15551234567',
              'address': '100 Wellness Ave',
              'description': 'Integrative practitioner',
              // no education / experience on purpose
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dr. Janine Crifasi'), findsWidgets);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Integrative practitioner'), findsOneWidget);
      expect(find.text('Chandler, AZ'), findsOneWidget);
      expect(find.text('janine@example.com'), findsOneWidget);
      expect(find.text('+15551234567'), findsOneWidget);
      expect(find.text('100 Wellness Ave'), findsOneWidget);
    });

    testWidgets('shows education and experience when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DoctorDetail(
            doctor: {
              'id': 2,
              'name': 'Dr. With Education',
              'city': 'Dallas, TX',
              'description': 'Experienced clinician',
              'education':
                  '<h1>Education</h1><ul><li>Medical School</li></ul>',
              'experience':
                  '<h1>Experience</h1><ul><li>Clinic Lead</li></ul>',
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dr. With Education'), findsWidgets);
      expect(find.text('Dallas, TX'), findsOneWidget);
      expect(find.textContaining('Medical School'), findsOneWidget);
      expect(find.textContaining('Clinic Lead'), findsOneWidget);
    });

    testWidgets('shows message when doctorId is missing', (tester) async {
      await tester.pumpWidget(_wrap(const DoctorDetail()));
      await tester.pumpAndSettle();
      expect(find.text('No doctor id provided'), findsOneWidget);
    });
  });
}
