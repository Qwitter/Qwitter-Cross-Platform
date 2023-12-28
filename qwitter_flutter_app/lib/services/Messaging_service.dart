import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/providers/user_search_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/providers/user_search_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagingServices {
  static AppUser user = AppUser();

  static Map<String, String> cookies = {
    'qwitter_jwt': 'Bearer ${user.getToken}',
  };
  static const String _baseUrl = 'http://back.qwitter.cloudns.org:3000';
  static IO.Socket socket = IO.io(
    _baseUrl,
    IO.OptionBuilder().setTransports(['websocket']).build(),
  );

  static Future<http.Response> getSingleConversationsRespone(
      String conversationId) async {
    final url = Uri.parse('$_baseUrl/api/v1/conversation/$conversationId');
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });
    return response;
  }

  static Future<Conversation?> getSingleConversations(
      String conversationId) async {
    try {
      final response = await getSingleConversationsRespone(conversationId);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        Conversation conversation = Conversation.fromJson(jsonBody);
        return conversation;
      } else {
        return null;
      }
    } catch (e) {
      print("gettingConversationError");
      return null;
    }
  }

  static Future<http.Response> getConversationsRespone() async {
    AppUser user = AppUser();
    final url = Uri.parse('$_baseUrl/api/v1/conversation/?limit=100');
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });
    print(user.token);
    return response;
  }

  static Future<List<Conversation>> getConversations() async {
    try {
      print("getting convo");
      final response = await getConversationsRespone();
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> ConversationList = jsonBody as List<dynamic>;
        List<Conversation> conversations = ConversationList.map(
            (conversation) => Conversation.fromJson(conversation)).toList();
        print("done");
        return conversations;
      } else {
        return [];
      }
    } catch (e) {
      print("gettingConversationError");
      return [];
    }
  }

  static void initSocket() {
    socket.onConnect((data) => print("Connected"));
    socket.onDisconnect((data) => print("socket Disconnected"));
  }

  static Future<http.StreamedResponse> requestMessageResponse(
      String conversationId,
      String Message,
      File? imageFile,
      String replyId) async {
    final url =
        Uri.parse('$_baseUrl/api/v1/conversation/$conversationId/message');

    Map<String, String> fields = {
      'text': Message,
      'replyId': replyId,
    };
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${AppUser().getToken}',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });
    request.fields.addAll(fields);
    if (imageFile != null) {
      final fileName = basename(imageFile.path);

      final stream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();
      final imgType = lookupMimeType(imageFile.path);
      final contentType = imgType!.split('/');

      final multipartFile = http.MultipartFile(
        'media', // Use the same field name for all files
        stream,
        length,
        filename: fileName,
        contentType: MediaType(contentType[0], contentType[1]),
      );

      request.files.add(multipartFile);
    }

    final response = await request.send();
    return response;
  }

  static Future<Map<String, dynamic>> requestMessage(String converstaionID,
      String Message, File? imageFile, String replyId) async {
    try {
      final response = await http.Response.fromStream(
        await requestMessageResponse(
          converstaionID,
          Message,
          imageFile,
          replyId,
        ),
      );
      print('replyId is ' + replyId);
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

  static Future<http.Response> fetchMessagesResponse(
      String conversationId, int page) async {
    final url = Uri.parse(
        '$_baseUrl/api/v1/conversation/$conversationId?page=$page&limit=25');
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer ${AppUser().getToken}',
        'Cookie': cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; '),
      },
    );

    return response;
  }

  static Future<Map<String, dynamic>> fetchMessages(
      String converstaionID, int page) async {
    try {
      final response = await fetchMessagesResponse(converstaionID, page);
      print('messages'+response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body)['messages'];
        // log(response.body);
        List<MessageData> msgs =
            jsonBody.map((msg) => MessageData.fromJson(msg)).toList();
        return {
          'statusCode': response.statusCode,
          'messages': msgs,
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'messages': [],
        };
      }
    } catch (e) {
      print("fetching Messages Error");
      print(e);
      return {
        'statusCode': 'error',
        'messages': [],
      };
    }
  }

  static Future<http.Response> deleteMessageResponse(
      String conversationId, String messageId) async {
    final url =
        Uri.parse('$_baseUrl/api/v1/conversation/$conversationId/message');

    Map<String, String> fields = {'message_id': messageId};
    cookies = {
      'qwitter_jwt': 'Bearer ${user.getToken}',
    };
    final response = http.delete(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': 'Bearer ${AppUser().getToken}',
          'Cookie': cookies.entries
              .map((entry) => '${entry.key}=${entry.value}')
              .join('; '),
        },
        body: jsonEncode(fields));
    return response;
  }

  static Future<int> deleteMessage(
      String converstaionID, String messageId) async {
    try {
      // print('deleting');
      final response = await await deleteMessageResponse(
        converstaionID,
        messageId,
      );
      // print(response.body);
      // print(response.statusCode);
      return response.statusCode;
    } catch (e) {
      print("deleting message error");
      return -1;
    }
  }

  static void reConnect() {
    if (!socket.connected) {
      print('reconnecting');
      socket.disconnect();
      socket.connect();
    } else
      print('connected');
  }

  static void connectToConversation(String conversationId) {
    socket.emit('JOIN_ROOM', conversationId);
  }
}
