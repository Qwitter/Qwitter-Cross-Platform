import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart'; // You'll need this to mock the provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/profile_picture_screen.dart'; // Import the widget you want to test

// ignore: subtype_of_sealed_class
class MockProviderContainer extends Mock implements ProviderContainer {}

void main() {
  testWidgets('ProfilePictureScreen widget test', (WidgetTester tester) async {
    // Initialize the mock provider container
    final container = MockProviderContainer();

    // Use the container to mock the behavior of nextBarProvider
    when(container.read(nextBarProvider)).thenReturn(null);

    // Create a user for testing
    final user = User(
      username: 'TestUser',
      email: 'omar@gmail.com',
      password: 'Code1234',
    ); // You can initialize user data as needed

    // Build the ProfilePictureScreen widget
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ProfilePictureScreen(user: user),
        ),
      ),
    );

    // Perform widget interaction tests
    // For example, you can use `expect(find.text('Pick a profile picture'), findsOneWidget);`.
    expect(find.text('Pick a profile picture'), findsOneWidget);

    // Additional test cases can be added to test different aspects of the widget

    // Test 1: Verify the initial state without an image selected
    expect(find.text('Pick a profile picture'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // Test 2: Verify that the "Next" button is enabled
    final nextButton = find.text('Next');
    expect(nextButton, findsOneWidget);

    // Test 3: Simulate tapping the "Next" button
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
  });
}
