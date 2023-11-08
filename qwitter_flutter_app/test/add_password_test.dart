import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/add_password_screen.dart';

void main() {
  testWidgets('Add Password Form Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: AddPasswordScreen(
              user: User(username: 'TestUser', email: 'omar@gmail.com')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find text elements on the screen
    final titleText = find.text('You\'ll need a password');

    // Find the verification code text field
    final passwordField = find.byType(TextField);

    // Verify that the text elements are on the screen
    expect(titleText, findsOneWidget);

    // Verify that the verification code text field is on the screen
    expect(passwordField, findsOneWidget);

    await tester.enterText(passwordField, 'Code123');
    await tester.pumpAndSettle();

    // Verify that the "Next" button is disabled
    // Submit the form
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(titleText, findsOneWidget);

    await tester.enterText(passwordField, 'Code1234');
    await tester.pumpAndSettle();
  });
}
