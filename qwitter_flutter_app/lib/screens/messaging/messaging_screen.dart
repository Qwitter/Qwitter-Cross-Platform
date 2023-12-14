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
  MessagingScreen({
    super.key,
    required this.convo,
  });
  Conversation convo;

  @override
  ConsumerState<MessagingScreen> createState() => _MessagingScreenState();
}

List<MessageData> msgsss = [];

class _MessagingScreenState extends ConsumerState<MessagingScreen> {
  List<MessageData> msgs = [];
  final textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool _isFetching = false;
  bool allFetched = false;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    fecthMessages();
    MessagingServices.socket.on('ROOM_MESSAGE', (data) {
      print(data);
      print(data['text']);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
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

  void fecthMessages() async {
    _isFetching = true;
    await MessagingServices.fetchMessages(
            widget.convo.id, (msgs.length ~/ 15) + 1)
        .then((value) {
      if (value['statusCode'] == 200) {
        print(msgs.length);
        print('first');
        ref.watch(messagesProvider.notifier).addList(value['messages']);
        print(msgs.length);
        allFetched = (value['messages'].length == 0);
      }
    });
    _isFetching = false;
  }

  scrollListener() {
    print(scrollController.offset);
    if (scrollController.position.maxScrollExtent <=
        scrollController.offset + 150) {
      print(_isFetching);
      print(allFetched);
      if (_isFetching == false && allFetched == false) {
        print("starting to fetch");
        fecthMessages();
      }
    }
  }

  void sendMessage() {
    if (textController.text == "") return;

    MessagingServices.requestMessage(widget.convo.id, textController.text)
        .then((msg) {
      Map<String, dynamic> mp = {};
      mp['data'] = msg;
      mp['conversationId'] = widget.convo.id;
      print(jsonEncode(mp));
      ref
          .watch(messagesProvider.notifier)
          .addMessage(MessageData.fromJson(msg));
      MessagingServices.socket.emit(
        'SEND_ROOM_MESSAGE',
        jsonEncode(mp),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(
          milliseconds: 50,
        ),
      );
    });

    textController.clear();
    print('clear');
  }

  @override
  Widget build(context) {
    double radius = 17.5;
    MessagingServices.connectToConversation(widget.convo.id);
    msgs = ref.watch(messagesProvider);
    // msgs = msgsss;
    ref.listen(messagesProvider, (messagesProvider, messagesProvider2) {});
    // widget.convo.name='asfklnhnaklfasklfnasklfnasklfnasklfnasklfnasaksfna';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: black,
          automaticallyImplyLeading: true,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  print('pic');
                },
                splashColor: Colors.red,
                customBorder: CircleBorder(),
                child: (widget.convo.photo != null)
                    ? Container(
                        width: radius * 2,
                        child: CircleAvatar(
                          radius: radius,
                          backgroundImage:
                              NetworkImage(widget.convo.photo ?? ""),
                        ),
                      )
                    : ClipOval(
                        child: Image.asset(
                          "assets/images/def.jpg",
                          width: 35,
                        ),
                      ),
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  print('name');
                },
                child: SizedBox(
                  width: 200,
                  height: 35,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.convo.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
