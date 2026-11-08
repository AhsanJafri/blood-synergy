import 'package:blood_synergy_app/views/screens/sources_citations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Sources screen lists foundations and pattern research',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, __) => const MaterialApp(home: SourcesCitationsScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Sources & Citations'), findsWidgets);
    expect(find.text('General foundations'), findsOneWidget);
    expect(find.textContaining('MedlinePlus'), findsWidgets);
    expect(find.text('Pattern research'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Hepatic'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Energy'), findsWidgets);
    expect(find.text('Hepatic'), findsOneWidget);
  });
}
