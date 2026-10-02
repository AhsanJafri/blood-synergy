import 'package:blood_synergy_app/views/screens/faqs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FAQs screen lists key App Store review topics', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, __) => const MaterialApp(home: FaqsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("FAQ's"), findsOneWidget);
    expect(find.text('What is Blood Synergy?'), findsOneWidget);
    expect(find.text('Is this medical advice?'), findsOneWidget);
    expect(find.text('What data do you collect?'), findsOneWidget);
    expect(find.text('How do I delete my account?'), findsOneWidget);
    expect(find.text('Where is the Privacy Policy?'), findsOneWidget);
    expect(find.text('Are there in-app purchases?'), findsOneWidget);

    await tester.tap(find.text('Are there in-app purchases?'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('does not sell digital goods'),
      findsOneWidget,
    );
  });
}
