import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/confirmation_code_screen.dart';

void main() {
  testWidgets('ConfirmationCodeScreen Form Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ConfirmationCodeScreen(
              user: User(username: 'TestUser', email: 'omar@gmail.com')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find text elements on the screen
    final titleText = find.text('We sent you a code');

    // Find the verification code text field
    final verificationCodeField = find.byType(TextField);

    // Find the "Resend Email" button
    final resendEmailButton = find.text('Didn\'t receive an email?');

    // Verify that the text elements are on the screen
    expect(titleText, findsOneWidget);

    // Verify that the verification code text field is on the screen
    expect(verificationCodeField, findsOneWidget);

    // Verify that the "Resend Email" button is on the screen
    expect(resendEmailButton, findsOneWidget);

    await tester.enterText(verificationCodeField, 'Code');
    await tester.pumpAndSettle();

    // Verify that the "Next" button is enabled
    // Submit the form
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(titleText, findsOneWidget);

    await tester.enterText(verificationCodeField, 'Codein');
    await tester.pumpAndSettle();

    // Verify that the "Next" button is enabled
    // Submit the form
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    // Verify the confirmation screen is displayed
    expect(find.text('You\'ll need a password'), findsOneWidget);
  });
}
