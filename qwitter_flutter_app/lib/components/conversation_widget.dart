import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/providers/conversations_provider.dart';
import 'package:qwitter_flutter_app/providers/image_provider.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversation_users_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweets_feed_screen.dart';
import 'package:qwitter_flutter_app/services/Messaging_service.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';

class ConversationWidget extends ConsumerWidget {
  const ConversationWidget({super.key, required this.convo});
  final Conversation convo;
  static double radius = 30;

  @override
  Widget build(BuildContext context, ref) {
    String date = "";

    void switchToMessagingScreen() {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => MessagingScreen(
            convo: convo,
          ),
        ),
      )
          .then(
        (value) {
          print('popped');
          MessagingServices.getConversations().then(
            (list) {
              ref.read(ConversationProvider.notifier).InitConversations(list);
            },
          ).onError(
            (error, stackTrace) {
              //print(error);
            },
          );
        },
      );
      ;
    }

    String imageUrl = "";
    if (convo.isGroup) {
      imageUrl = convo.photo ?? "";
    } else if (convo.users.isNotEmpty) {
      imageUrl = convo.users.first.profilePicture?.path ?? "";
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
              InkWell(
                onTap: convo.isGroup
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConversationUsersScreen(
                              users: convo.users,
                            ),
                          ),
                        ).then(
                          (value) {
                            print('popped');
                            MessagingServices.getConversations().then(
                              (list) {
                                ref
                                    .read(ConversationProvider.notifier)
                                    .InitConversations(list);
                              },
                            ).onError(
                              (error, stackTrace) {
                                //print(error);
                              },
                            );
                          },
                        );
                      }
                    : () {
                        if (convo.users.isNotEmpty &&
                            convo.users.first.username != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileDetailsScreen(
                                  username: convo.users.first.username!),
                            ),
                          ).then(
                            (value) {
                              print('popped');
                              MessagingServices.getConversations().then(
                                (list) {
                                  ref
                                      .read(ConversationProvider.notifier)
                                      .InitConversations(list);
                                },
                              ).onError(
                                (error, stackTrace) {
                                  //print(error);
                                },
                              );
                            },
                          );
                        }
                      },
                customBorder: const CircleBorder(),
                child: ClipOval(
                  // borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
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
                        child: Image.asset(
                          "assets/images/def.jpg",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
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
                          text: !convo.isGroup && convo.users.isNotEmpty
                              ? "@" + convo.users.first.username!
                              : "",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: " . " +
                              (convo.lastMsg != null
                                  ? DateHelper.formatDateString(
                                      convo.lastMsg!.date.add(-DateTime.now().timeZoneOffset).toString())
                                  : ""),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        )
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
