import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessagingServices {
  static const String _baseUrl = 'http://qwitterback.cloudns.org:3000';
  static IO.Socket socket = IO.io(_baseUrl);

  static Future<http.Response> getConversationsRespone() async {
    AppUser user = AppUser();
    final url = Uri.parse('$_baseUrl/api/v1/conversation/');

    //print(user.token);

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
    });

    return response;
  }

  static void connect(String conversationId) {
    socket.connect();
    socket.emit('JOIN_ROOM', conversationId);
  }

  static void test() {
    print(socket.connected);
  }

  static Future<List<Conversation>> getConversations() async {
    try {
      final response = await getConversationsRespone();
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        // int unseen = jsonBody['unseen'];
        final List<dynamic> ConversationList = jsonBody as List<dynamic>;

        List<Conversation> conversations = ConversationList.map(
            (conversation) => Conversation.fromJson(conversation)).toList();
        print("doneS");
        return conversations;
      } else {
        return [];
      }
    } catch (e) {
      print("gettingConversationError");
      return [];
    }
  }
}
