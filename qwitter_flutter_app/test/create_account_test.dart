import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/create_account_screen.dart';

void main() {
  testWidgets('Create Account Widgets\' Test', (WidgetTester tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: CreateAccountScreen())));
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(QwitterNextBar), findsOneWidget);
  });

  testWidgets('Create Account Form Test', (WidgetTester tester) async {
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: CreateAccountScreen())));

    final titleText = find.text('Create your account');
    final nextButton = find.text('Next');

    expect(titleText, findsOneWidget);
    expect(nextButton, findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'TestUser');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');

    // Tap the date of birth field to open the date picker
    await tester.tap(find.text('Date of birth'));

    // Verify the date picker is displayed
    await tester.pumpAndSettle();

    // Now, you can interact with the date picker. For example, tap on a date.
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  });
}
