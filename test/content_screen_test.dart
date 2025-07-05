import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:royal_wiki/content_screen.dart';

void main() {
  testWidgets('Content screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ContentScreen(),
      ),
    );

    await tester.enterText(find.byKey(Key('First name')), "admin");
    expect(find.text("admin"), findsOneWidget);

    await tester.enterText(find.byKey(Key('Last name')), "admin");
    expect(find.text("admin"), findsAtLeast(2));

    expect(find.text('Submit'), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit'));
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
