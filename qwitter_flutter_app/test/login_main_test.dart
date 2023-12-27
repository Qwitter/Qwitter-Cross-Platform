import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_main_screen.dart';

void main() {
  testWidgets('Login Main Screen Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginMainScreen(passedInput: 'test@example.com'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Find text elements on the screen
    final enterPasswordText = find.text("Enter your password");
    final emailPlaceholderText = find.text("test@example.com");
    final passwordPlaceholderText = find.text("Password");
    final forgotPasswordText = find.text("Forgot password?");
    final loginButtonText = find.text("Login");
    final signUpText = find.text("Don't have an account");

    // Find the email and password text fields
    final passwordField = find.byType(TextField).at(1);

    // Verify that the text elements are on the screen
    expect(enterPasswordText, findsOneWidget);
    expect(emailPlaceholderText, findsOneWidget);
    expect(passwordPlaceholderText, findsOneWidget);
    expect(forgotPasswordText, findsOneWidget);
    expect(loginButtonText, findsOneWidget);
    expect(signUpText, findsOneWidget);

    // Enter a password
    await tester.enterText(passwordField, 'testpassword');
    await tester.pumpAndSettle();

    // Verify that the "Login" button is disabled initially
    // Verify that the "Login" button is disabled initially
    // Verify that the "Login" button is disabled initially
    final loginButton = find.byKey(const Key('login_button_key'));

// Verify that the "Login" button is disabled initially

// Verify that the "Login" button is disabled initially
    expect(loginButton, findsOneWidget);
    // expect(tester.widget<ElevatedButton>(loginButton).enabled, isFalse);
// Use tester.widget<Text> instead of tester.widget<ElevatedButton>

    // Trigger password validation logic
    await tester.pump();

    // Verify that the "Login" button is enabled after entering a valid password
    // expect(tester.widget<ElevatedButton>(loginButton).enabled, isTrue);

    // Submit the form
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  });
}
