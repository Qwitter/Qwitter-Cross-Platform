import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/conversation_user_card.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/messaging_text_field.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/components/scrollable_messages.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/providers/image_provider.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversation_info_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversation_users_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversations_screen.dart';
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
  File? imageFile;
  final messagesProvider = messagesProviderFamily(id);
  static int id = 0;
  @override
  void initState() {
    id += 1;
    print(id);
    super.initState();
    scrollController.addListener(scrollListener);
    fecthMessages();
    MessagingServices.socket.on('ROOM_MESSAGE', (data) {
      print(data);
      print(data['text']);
      ref
          .read(messagesProvider.notifier)
          .addMessage(MessageData.fromJson(data));
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

    // ref.read(messagesProvider.notifier).DeleteHistory();
  }

  void fecthMessages() async {
    _isFetching = true;
    await MessagingServices.fetchMessages(
            widget.convo.id, (msgs.length ~/ 15) + 1)
        .then((value) {
      if (value['statusCode'] == 200) {
        print(msgs.length);
        print('first');

        print(value['messages'].length);
        ref.watch(messagesProvider.notifier).addList(value['messages']);
        print(msgs.length);
        allFetched = (value['messages'].length == 0);
      }
    });
    _isFetching = false;
  }

  scrollListener() {
    // print(scrollController.offset);
    if (scrollController.position.maxScrollExtent <=
        scrollController.offset + 150) {
      // print(_isFetching);
      // print(allFetched);
      if (_isFetching == false && allFetched == false) {
        print("starting to fetch");
        fecthMessages();
      }
    }
  }

  void sendMessage() {
    print('widget length');
    print(msgs.length);
    if (textController.text == "" && imageFile == null) return;
    MessagingServices.requestMessage(
            widget.convo.id, textController.text, imageFile)
        .then((msg) {
      Map<String, dynamic> mp = {};
      mp['data'] = msg;
      mp['conversationId'] = widget.convo.id;
      print(jsonEncode(mp));
      ref
          .watch(messagesProvider.notifier)
          .addMessage(MessageData.fromJson(msg));
      print(MessagingServices.socket.connected);
      MessagingServices.socket.emit(
        'SEND_ROOM_MESSAGE',
        jsonEncode(mp),
      );
    });

    ref.read(imageProvider.notifier).setImage(null);
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
    imageFile = ref.watch(imageProvider);
    MessagingServices.connectToConversation(widget.convo.id);

    msgs = ref.watch(messagesProvider);
    // widget.convo.name='asfklnhnaklfasklfnasklfnasklfnasklfnasklfnasaksfna';
    String imageUrl =
        "https://img.freepik.com/premium-vector/flat-instagram-icons-notifications_619991-50.jpg?size=626&ext=jpg";
    if (widget.convo.isGroup) {
      imageUrl = widget.convo.photo ??
          "https://img.freepik.com/premium-vector/flat-instagram-icons-notifications_619991-50.jpg?size=626&ext=jpg";
    } else if (widget.convo.users.isNotEmpty) {
      imageUrl = widget.convo.users.first.profilePicture?.path ??
          "https://img.freepik.com/premium-vector/flat-instagram-icons-notifications_619991-50.jpg?size=626&ext=jpg";
    }

    return ProviderScope(
      child: WillPopScope(
        onWillPop: () {
          // ref.read(messagesProvider.notifier).DeleteHistory();
          ref.read(imageProvider.notifier).setImage(null);
          Navigator.pop(context,'popped');
          return Future(() => false);
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              backgroundColor: black,
              surfaceTintColor: black,
              automaticallyImplyLeading: true,
              title: Row(
                children: [
                  InkWell(
                    onTap: widget.convo.isGroup == false
                        ? () {
                            if (widget.convo.users.isNotEmpty &&
                                widget.convo.users.first.username != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileDetailsScreen(
                                      username:
                                          widget.convo.users.first.username!),
                                ),
                              );
                            }
                          }
                        : null,
                    splashColor: Colors.red,
                    customBorder: CircleBorder(),
                    child: ClipOval(
                      // borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        imageUrl != ""
                            ? imageUrl
                            : "https://img.freepik.com/premium-vector/flat-instagram-icons-notifications_619991-50.jpg?size=626&ext=jpg",
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            // Image has successfully loaded
                            return child;
                          } else {
                            // Image is still loading
                            return CircularProgressIndicator();
                          }
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          // Handle image loading errors
                          return ClipOval(
                            child: Image.network(
                              "https://img.freepik.com/premium-vector/flat-instagram-icons-notifications_619991-50.jpg?size=626&ext=jpg",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationUsersScreen(
                            users: widget.convo.users,
                          ),
                        ),
                      );
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationInfoScreen(
                          convo: widget.convo,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          body: Column(
            children: [
              ScrollableMessages(
                msgs: msgs,
                scrollController: scrollController,
                isGroup: widget.convo.isGroup,
              ),
              MessagingTextField(
                textController: textController,
                sendMessage: sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
