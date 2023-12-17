import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
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
  static const String _baseUrl = 'http://back.qwitter.cloudns.org:3000';
  static IO.Socket socket = IO.io(
    'http://back.qwitter.cloudns.org:3000',
    IO.OptionBuilder().setTransports(['websocket']).build(),
  );
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

  static Future<http.StreamedResponse> requestMessageResponse(
      String conversationId, String Message, File? imageFile) async {
    final url =
        Uri.parse('$_baseUrl/api/v1/conversation/$conversationId/message');

    Map<String, String> fields = {
      'text': Message,
      'replyId': "",
    };
    print(jsonEncode(fields));

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${AppUser().getToken}',
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
      print(request.files.first);
    }
    final response = await request.send();
    print("message request done");
    return response;
  }

  static Future<Map<String, dynamic>> requestMessage(
      String converstaionID, String Message, File? imageFile) async {
    try {
      final response = await http.Response.fromStream(
        await requestMessageResponse(
          converstaionID,
          Message,
          imageFile,
        ),
      );
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

  static Future<http.Response> fetchMessagesResponse(
      String conversationId, int page) async {
    final url = Uri.parse(
        '$_baseUrl/api/v1/conversation/$conversationId?page=$page&limit=15');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer ${AppUser().getToken}',
      },
    );

    return response;
  }

  static Future<Map<String, dynamic>> fetchMessages(
      String converstaionID, int page) async {
    try {
      final response = await fetchMessagesResponse(converstaionID, page);
      // print(response.statusCode);
      // print(jsonDecode(response.body)['messages']);

      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body)['messages'];
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
      return {
        'statusCode': 'error',
        'messages': [],
      };
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
