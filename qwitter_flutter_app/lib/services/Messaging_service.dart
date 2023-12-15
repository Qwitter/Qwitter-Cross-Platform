import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/providers/user_search_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagingServices {
  static const String _baseUrl = 'http://qwitter.cloudns.org:3000';
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

  static void initSocket() {
    socket.onConnect((data) => print("Connected"));
  }

  static Future<http.Response> requestMessageResponse(
      String conversationId, String Message) async {
    final url = Uri.parse(
        'http://qwitterback.cloudns.org:3000/api/v1/conversation/$conversationId/message');

    Map<String, dynamic> fields = {
      'text': Message,
      'replyId': "",
      "media": "",
    };
    print(jsonEncode(fields));
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': 'Bearer ${AppUser().getToken}',
        },
        body: jsonEncode(fields));

    return response;
  }

  static Future<Map<String, dynamic>> requestMessage(
      String converstaionID, String Message) async {
    try {
      final response = await requestMessageResponse(converstaionID, Message);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201) {
        final jsonBody = jsonDecode(response.body);
        return jsonBody['createdMessage'];
      } else {
        return {};
      }
    } catch (e) {
      print("gettingConversationError");
      return {};
    }
  }

  static void reConnect() {
    socket.disconnect();
    socket.connect();
  }

  static void connectToConversation(String conversationId) {
    socket.emit('JOIN_ROOM', conversationId);

    // socket.emit(
    //   'ROOM_MESSAGE',
    //   (data) {
    //     // print(data);
    //     // final container = ProviderContainer();
    //     // container.read(messagesProvider.notifier).addMessage(
    //     //     MessageData(byMe: false, text: data['text'], date: DateTime.now()));
    //   },
    // );
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
        // for (var v in ConversationList) {
        //   print(v);
        // }

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
