import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/messaging_text_field.dart';
import 'package:qwitter_flutter_app/components/scrollable_messages.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/services/Messaging_service.dart';
import 'package:qwitter_flutter_app/theme/theme_constants.dart';

class MessagingScreen extends ConsumerStatefulWidget {
  const MessagingScreen({
    super.key,
    required this.converstaionID,
  });
  final String converstaionID;

  @override
  ConsumerState<MessagingScreen> createState() => _MessagingScreenState();
}

List<MessageData> msgsss = [
  MessageData(
      text: "hello",
      date: DateTime.now().subtract(const Duration(days: 5, minutes: 10)),
      byMe: true),
  MessageData(
      text: "hi how are ya?",
      date: DateTime.now().subtract(const Duration(days: 5, minutes: 9)),
      byMe: false),
  MessageData(
      text: "I am actually doing good",
      date: DateTime.now().subtract(const Duration(days: 5, minutes: 8)),
      byMe: true),
  MessageData(
      text: "how is your family",
      date: DateTime.now().subtract(const Duration(days: 5, minutes: 8)),
      byMe: true),
  MessageData(
      text: "they are doing well ",
      date: DateTime.now().subtract(const Duration(days: 5, minutes: 7)),
      byMe: false),
  MessageData(
      text: "how has school been",
      date: DateTime.now().subtract(const Duration(days: 5, minutes: 7)),
      byMe: false),
  MessageData(
      text: "nothing that exciting to be honest",
      date: DateTime.now().subtract(const Duration(days: 5, minutes: 5)),
      byMe: true),
  MessageData(
      text: "there's a quiz tomorrow don't forget",
      date: DateTime.now().subtract(const Duration(days: 3, minutes: 2)),
      byMe: false),
  MessageData(
      text: "thakn you for reminding me",
      date: DateTime.now().subtract(const Duration(days: 2, hours: 20)),
      byMe: true),
  MessageData(
      text: "are you going to school tomorrow ?",
      date: DateTime.now()
          .subtract(const Duration(days: 1, hours: 5, minutes: 8)),
      byMe: true),
  MessageData(
      text:
          "yeah, let's meet at 9 am\nyeah, let's meet at 9 am,yeah, let's meet at 9 am,yeah, let's meet at 9 am,yeah, let's meet at 9 am,yeah, let's meet at 9 am,yeah, let's meet at 9 am",
      date: DateTime.now()
          .subtract(const Duration(days: 1, hours: 3, minutes: 50)),
      byMe: false),
  MessageData(
      text: "that looks great 1",
      date: DateTime.now()
          .subtract(const Duration(days: 1, hours: 1, minutes: 20)),
      byMe: true),
  MessageData(
      text: "that looks great 2",
      date: DateTime.now()
          .subtract(const Duration(days: 1, hours: 1, minutes: 5)),
      byMe: true),
  MessageData(
      text: "that looks great 3",
      date: DateTime.now()
          .subtract(const Duration(days: 1, hours: 1, minutes: 5)),
      byMe: true),
  MessageData(
      text: "that looks great 4",
      date: DateTime.now()
          .subtract(const Duration(days: 1, hours: 1, minutes: 5)),
      byMe: true),
];

class _MessagingScreenState extends ConsumerState<MessagingScreen> {
  List<MessageData> msgs = [];
  final textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    MessagingServices.socket.on('ROOM_MESSAGE', (data) {
      print(data);
      print(data['text']);
      ref.watch(messagesProvider.notifier).addMessage(
          MessageData(text: data['text'], date: DateTime.now(), byMe: false));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(
            milliseconds: 50,
          ),
        );
      });
    });
    //call messaging api get latest page;
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    MessagingServices.socket.off('ROOM_MESSAGE');
    super.dispose();
  }

  scrollListener() {}

  void sendMessage() {
    if (textController.text == "") return;

    // ref.read(messagesProvider.notifier).DeleteHistory();
    MessagingServices.requestMessage(widget.converstaionID, textController.text)
        .then((msg) {
      Map<String, dynamic> mp = {};
      mp['data'] = msg;
      mp['conversationId'] = widget.converstaionID;
      print(jsonEncode(mp));
      MessagingServices.socket.emit(
        'SEND_ROOM_MESSAGE',
        jsonEncode(mp),
      );
    });

    // ref.read(messagesProvider.notifier).insertOldMessages(msgsss);
    final newMessage = MessageData(
      text: textController.text,
      date: DateTime.now(),
      byMe: true,
    );
    print("first");
    // print(scrollController.)
    ref.read(messagesProvider.notifier).addMessage(newMessage);

    // ref.read(messagesProvider.notifier).printState();
    print(msgs[msgs.length - 1].text);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(
          milliseconds: 50,
        ),
      );
    });

    // setState(() => msgs.add(newMessage));
    textController.text = "";
  }

  @override
  Widget build(context) {
    MessagingServices.connectToConversation(widget.converstaionID);
    msgs = ref.watch(messagesProvider);
    ref.listen(messagesProvider, (messagesProvider, messagesProvider2) {});
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: black,
          automaticallyImplyLeading: true,
          title: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/abo.jpeg",
                  width: 35,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              const SizedBox(
                width: 175,
                child: Text(
                  "User Name sdfs d fsd f sd f sd ",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {},
            )
          ],
        ),
      ),
      body: Column(
        children: [
          ScrollableMessages(
            msgs: msgs,
            scrollController: scrollController,
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MessagingTextField(textController: textController),
                  const SizedBox(
                    width: 10,
                  ), // Add some spacing between the TextField and the button

                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.send),
                      onPressed: sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
