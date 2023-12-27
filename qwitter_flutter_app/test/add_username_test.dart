import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/add_username_screen.dart';

// Import the AddUsernameScreen and any other dependencies.

void main() {
  // Initialize the mock providers and other test setup as needed.

  testWidgets('Test AddUsernameScreen', (WidgetTester tester) async {
    // Build the widget with the mocked providers.

    final User user = User(
        username: 'testUsername',
        email: 'omar@gmail.com',
        password: 'Code1234',
        usernameSuggestions: ['Omar', 'Mahmoud', 'Maestro']);
    // Pump the widget.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: AddUsernameScreen(
            user: user,
          ),
        ),
      ),
    );

    // Now, you can write your test cases.

    // For example, you can test if the widget displays correctly.
    expect(find.text('What should we call you?'), findsOneWidget);
    expect(
        find.text(
            'Your @username is your unique identifier on X. You can always change it later.'),
        findsOneWidget);

    // Simulate user interactions, e.g., entering text into the username field.
    await tester.enterText(find.byType(TextField), 'testUsername');

    // Pump the widget again to reflect the changes.
    await tester.pump();

    // Verify that no suggestions are initially in the text box.

    expect(find.text(user.usernameSuggestions![0]), findsOneWidget);

    // Simulate user interactions, e.g., tapping on a suggestion.
    await tester.tap(find.text(user.usernameSuggestions![0]));
    await tester.pump();
    expect(find.text(user.usernameSuggestions![0]), findsNWidgets(2));

    expect(find.text(user.usernameSuggestions![1]), findsOneWidget);

    // Simulate user interactions, e.g., tapping on a suggestion.
    await tester.tap(find.text(user.usernameSuggestions![1]));
    await tester.pump();
    expect(find.text(user.usernameSuggestions![1]), findsNWidgets(2));

    expect(find.text(user.usernameSuggestions![2]), findsOneWidget);

    // Simulate user interactions, e.g., tapping on a suggestion.
    await tester.tap(find.text(user.usernameSuggestions![2]));
    await tester.pump();
    expect(find.text(user.usernameSuggestions![2]), findsNWidgets(2));

    // Verify that the "Next" button is enabled.
    expect(find.text('Next'), findsOneWidget);
  });
}
