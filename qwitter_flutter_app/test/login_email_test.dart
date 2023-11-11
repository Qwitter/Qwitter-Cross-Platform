import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_email_screen.dart';

void main() {
  testWidgets('Login Email Screen Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginEmailScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find text elements on the screen
    final hintText = find.text(
        "To get started, first enter your phone, email address or @username");
    final placeholderText = find.text("email");

    // Find the email text field
    final emailField = find.byType(TextField);

    // Verify that the text elements are on the screen
    expect(hintText, findsOneWidget);
    expect(placeholderText, findsOneWidget);

    // Verify that the email text field is on the screen
    expect(emailField, findsOneWidget);

    // Enter an email address
    await tester.enterText(emailField, 'test@example.com');
    await tester.pumpAndSettle();

    // Verify that the "Next" button is disabled initially
    final nextButton = find.text('Next');
    expect(nextButton, findsOneWidget);
    expect(tester.widget<ElevatedButton>(nextButton).enabled, isFalse);

    // Trigger email validation logic
    await tester.pump();

    // Verify that the "Next" button is enabled after entering a valid email
    expect(tester.widget<ElevatedButton>(nextButton).enabled, isTrue);

    // Submit the form
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
  });
}
