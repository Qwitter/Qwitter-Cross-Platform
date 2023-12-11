import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/providers/conversations_provider.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweets_feed_screen.dart';
import 'package:qwitter_flutter_app/services/Messaging_service.dart';

class ConversationWidget extends ConsumerWidget {
  const ConversationWidget({super.key, required this.convo});
  final Conversation convo;
  @override
  Widget build(BuildContext context, ref) {
    String date = "";

    void switchToMessagingScreen() {
      print("hello world");
      ref.read(messagesProvider.notifier).DeleteHistory();
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => MessagingScreen(
                  converstaionID: convo.id,
                )),
      );
    }

    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: switchToMessagingScreen,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            children: [
              Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () {},
                    child: Ink.image(
                      image:
                          AssetImage( "assets/images/def.jpg"),
                      height: 60,
                      width: 60,
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      text: convo.name + " ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                      children: [
                        TextSpan(
                          text: "@" + convo.name,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    convo.lastMsg?.text ?? " ",
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
