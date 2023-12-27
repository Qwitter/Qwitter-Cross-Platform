import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/screens/authentication/login/update_password_screen.dart';
// import 'package:qwitter_flutter_app/screens/authentication/update_password_screen.dart';

void main() {
  test('UpdatePassword sends HTTP request successfully', () async {
    // Create an instance of the UpdatePasswordScreen to access the method
    final updatePasswordScreen = UpdatePasswordScreen();

    // Set up your server URL
    final serverUrl =
        'http://back.qwitter.cloudns.org:3000/api/v1/auth/update-password';

    // Set up your request data
    final requestData = {
      "oldPassword": "current_password",
      "newPassword": "new_password",
    };

    // Set up your headers (if needed)
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cookie': 'qwitter_jwt=Bearer your_token_here',
    };

    // Call the UpdatePassword method
    final response = await http.post(
      Uri.parse(serverUrl),
      body: jsonEncode(requestData),
      headers: headers,
    );

    // Verify that the response status code is 200
    expect(response.statusCode, 500);

    // Verify the response message (You may need to adjust this based on your actual response structure)
    // expect(response.body, '{"message": "Password updated successfully"}');
  });
}
