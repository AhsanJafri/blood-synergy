import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:blood_synergy_app/helpers/ai_consent.dart';
import 'package:blood_synergy_app/views/chatbot/chatbot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await UserPref.initPrefs();
    await AiConsent.clear();
  });

  testWidgets('Chatbot shows Gemini consent before loading', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, __) => const MaterialApp(home: ChatbotScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Google Gemini'), findsWidgets);
    expect(find.text('Allow'), findsOneWidget);
    expect(find.text("Don't Allow"), findsOneWidget);
    expect(find.text('Read Privacy Policy'), findsOneWidget);
  });
}
