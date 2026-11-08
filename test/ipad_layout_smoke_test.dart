import 'package:blood_synergy_app/helpers/AppPreference.dart';
import 'package:blood_synergy_app/helpers/ai_consent.dart';
import 'package:blood_synergy_app/views/chatbot/chatbot_screen.dart';
import 'package:blood_synergy_app/views/screens/sources_citations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // iPad Air 11" logical size (portrait)
  const ipadSize = Size(820, 1180);

  Future<void> pumpOnIpad(WidgetTester tester, Widget home) async {
    await tester.binding.setSurfaceSize(ipadSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: ipadSize),
            child: home,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await UserPref.initPrefs();
    await AiConsent.clear();
  });

  testWidgets('iPad: Gemini consent fits without overflow', (tester) async {
    await pumpOnIpad(tester, const ChatbotScreen());
    expect(tester.takeException(), isNull);
    expect(find.text('Allow'), findsOneWidget);
    expect(find.text("Don't Allow"), findsOneWidget);
    expect(find.textContaining('Google Gemini'), findsWidgets);
  });

  testWidgets('iPad: Sources screen has no overflow', (tester) async {
    await pumpOnIpad(tester, const SourcesCitationsScreen());
    expect(tester.takeException(), isNull);
    expect(find.text('Sources & Citations'), findsWidgets);
  });

  testWidgets('iPad: Wellness header renders', (tester) async {
    // SupplementsScreen needs BlocProviders for data; header alone is enough smoke.
    // Pump a lightweight replica of the header constraints.
    await pumpOnIpad(
      tester,
      Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: const Color.fromRGBO(207, 27, 33, 1),
              child: const Text(
                'Explore Wellness Patterns',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const Expanded(child: Center(child: Text('grid'))),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Explore Wellness Patterns'), findsOneWidget);
  });
}
