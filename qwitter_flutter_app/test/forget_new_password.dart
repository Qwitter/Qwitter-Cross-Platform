import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/forget_new_password_screen.dart';

void main() {
  testWidgets('Forget New Password Screen Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ForgetNewPasswordScreen(token: 'testToken'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find text elements on the screen
    final choosePasswordText = find.text("Choose a new password");
    final newPasswordPlaceholderText = find.text("Enter a new password");
    final confirmPasswordPlaceholderText = find.text("Confirm your password");
    final strongPasswordText = find.text("strong password");

    // Find the new password and confirm password text fields
    final newPasswordField = find.byType(TextField).at(0);
    final confirmPasswordField = find.byType(TextField).at(1);

    // Verify that the text elements are on the screen
    expect(choosePasswordText, findsOneWidget);
    expect(newPasswordPlaceholderText, findsOneWidget);
    expect(confirmPasswordPlaceholderText, findsOneWidget);
    expect(strongPasswordText, findsOneWidget);

    // Enter a new password
    await tester.enterText(newPasswordField, 'testpassword');
    await tester.pumpAndSettle();

    // Verify that the "Next" button is disabled initially
    final nextButton = find.text('Next');
    expect(nextButton, findsOneWidget);
    expect(tester.widget<ElevatedButton>(nextButton).enabled, isFalse);

    // Enter a matching confirm password
    await tester.enterText(confirmPasswordField, 'testpassword');
    await tester.pumpAndSettle();

    // Verify that the "Next" button is enabled after entering valid passwords
    expect(tester.widget<ElevatedButton>(nextButton).enabled, isTrue);

    // Submit the form
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Add assertions for the expected behavior after submitting the form
    // For example, check if the Fluttertoast message appears

    // Additional test scenarios can be added based on your requirements
  });
}
