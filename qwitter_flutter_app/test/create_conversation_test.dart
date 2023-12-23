import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/create_conversation_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

void main() {
  testWidgets('CreateConversationScreen UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: CreateConversationScreen(onUpdate: () {}),
        ),
      ),
    );
    MockClient((request) async {
      return http.Response(jsonEncode([]), 200);
    });
    await tester.pumpAndSettle();

    // Find text elements on the screen
    final titleText = find.text('Create a conversation');

    // Find the search text field
    final searchTextfield = find.byType(TextField);

    // Find the "Create" button
    final createButton = find.text('Create');

    // Verify that the text elements are on the screen
    expect(titleText, findsOneWidget);
    expect(searchTextfield, findsOneWidget);
    expect(createButton, findsOneWidget);

    // Simulate entering text into the search field
    await tester.enterText(searchTextfield, 'TestUser');
    await tester.pumpAndSettle();

    // Verify that the selected user is displayed
    expect(find.text('TestUser'), findsOneWidget);
  });
}
