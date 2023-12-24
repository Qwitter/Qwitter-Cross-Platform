import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversations_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/services/Messaging_service.dart';
import 'package:socket_io_client/socket_io_client.dart'; // Import the screen
import 'package:http/http.dart' as http;

// Import any necessary mocking/stubbing libraries
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../mockSocket.dart';

class MyHttpClient implements HttpClient {
  MyHttpClient(SecurityContext? c);

  @override
  noSuchMethod(Invocation invocation) {
    // your implementation here
  }
}

class MockSocket extends Mock implements IO.Socket {}

class MockClient extends Mock implements http.Client {}

void main() {
  testWidgets(
    'Initial messages are displayed correctly',
    (WidgetTester tester) async {
      // Set up any mocks/stubs
      // Build the MessagingScreen widget
      final MockSocket mock = MockSocket();
      MessagingServices.socket = mock;
      AppUser user = AppUser();
      user.copyUserData(User(profilePicture: File('path')));
      final mockClient = MockClient();
      // when(mockClient.get(Uri.parse(
      //         "")))
      //     .thenAnswer((_) async =>
      //         http.Response(jsonEncode({"your": "mocked response"}), 404));

      await mockNetworkImagesFor(() => tester.pumpWidget(
            // var v= MockClient();
            ProviderScope(
              child: MaterialApp(
                home: MessagingScreen(
                  convo: Conversation(
                      id: 'id',
                      isGroup: true,
                      name: 'name',
                      fullName: 'fullName',
                      lastMsg: MessageData(
                          id: 'id',
                          date: DateTime.now(),
                          text: ' text',
                          name: ' name',
                          profileImageUrl: 'profileImageUrl',
                          media: null,
                          byMe: false),
                      users: [User(), User()]),
                ),
              ),
            ),
          ));
      // await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();
      // expect(find.text('fullName'), findsOneWidget);

      // Verify that initial messages are displayed as expected
    },
  );

  // Write more test cases for other functionalities
}
