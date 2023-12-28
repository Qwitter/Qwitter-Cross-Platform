import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/reply.dart';
import 'package:qwitter_flutter_app/providers/reply_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_media_viewer_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_video_screen.dart';
import 'package:qwitter_flutter_app/screens/searching/search_screen.dart';
import 'package:qwitter_flutter_app/theme/theme_constants.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';

class MessageCard extends ConsumerWidget {
  const MessageCard({
    super.key,
    required this.msg,
    required this.tag,
    required this.longHold,
    required this.isGroup,
  });
  final MessageData msg;
  final String tag;
  final longHold;
  final bool isGroup;
  static const double radius = 15;
  List<InlineSpan> buildTextWithButton(context, String text, bool byMe) {
    final List<InlineSpan> textWithButtons = [];
    final RegExp wordBoundaryRegex = RegExp(r'\s+');
    final List<String> splitBySpace = text.split(wordBoundaryRegex);
    List<String> result = [];

    text.splitMapJoin(wordBoundaryRegex, onMatch: (value) {
      result.add(value.group(0)!);
      return value.group(0)!;
    }, onNonMatch: (value) {
      result.add(value);
      return value;
    });
    final RegExp mentionRegex = RegExp(r'@[\w\u0600-\u06FF]+');
    final RegExp hashtagRegex = RegExp(r'#[\w\u0600-\u06FF]+');

    for (String segment in result) {
      if (mentionRegex.hasMatch(segment)) {
        textWithButtons.add(TextSpan(
          text: segment,
          style: TextStyle(
            color: byMe ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileDetailsScreen(
                        username: segment.trim().replaceAll('@', '')),
                  ));
              print("Mention");
            },
        ));
      } else if (hashtagRegex.hasMatch(segment)) {
        textWithButtons.add(
          TextSpan(
            text: segment,
            style: TextStyle(
              color: byMe ? Colors.white : Colors.blue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(
                        hastag: segment.trim(),
                        query: "",
                      ),
                    ));
                print("Hashtag");
              },
          ),
        );
      } else {
        textWithButtons.add(
          TextSpan(
            text:
                segment, // Add space after each segment except the last one
            style: const TextStyle(
              height: 1.2,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );
      }
    }

    return textWithButtons;
  }

  @override
  Widget build(BuildContext context, ref) {
    // log(msg.text);
    // log(msg.reply == null ? "null" : "not null");
    // if (msg.media != null) {
    //   log(msg.media!.value);
    //   log(msg.media!.type);
    // }
    AppUser user = AppUser();
    return msg.isMessage != null && msg.isMessage
        ? Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            movementDuration: const Duration(milliseconds: 100),
            confirmDismiss: (a) async {
              print('dismissing');
              ref.read(replyProvider.notifier).set(
                    Reply(
                      replyId: msg.id,
                      replyText: msg.text,
                      replyName: msg.name,
                      replyMedia: msg.media,
                    ),
                  );

              return false;
            },
            child: Column(
              crossAxisAlignment:
                  msg.byMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (msg.reply != null && msg.reply!.text != '') ...[
                  const Text(
                    'Replying to',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                    color: const Color.fromARGB(255, 23, 23, 26),
                    child: Column(
                      crossAxisAlignment: msg.reply!.byMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                          child: Text(
                            msg.reply!.text,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 232, 231, 231)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(0, msg.reply == null ? 5 : 0, 0, 5),
                  child: Column(
                    crossAxisAlignment: msg.byMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: isGroup == true
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileDetailsScreen(
                                                  username: msg.name),
                                        ),
                                      );
                                    },
                                    child: msg.byMe == false
                                        ? ClipOval(
                                            child: Image.network(
                                              msg.profileImageUrl ?? "",
                                              width: 35,
                                              height: 35,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  // Image has successfully loaded
                                                  return child;
                                                } else {
                                                  // Image is still loading
                                                  return CircularProgressIndicator();
                                                }
                                              },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                // Handle image loading errors
                                                return ClipOval(
                                                  child: Image.asset(
                                                    "assets/images/def.jpg",
                                                    width: 35,
                                                    height: 35,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : const SizedBox(
                                            height: 0,
                                          ),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: msg.byMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                if (msg.media != null &&
                                    msg.media!.type == 'video') ...[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MessagingVideoScreen(
                                            video: msg.media!.value,
                                          ),
                                        ),
                                      );
                                    },
                                    onLongPress: () {
                                      print('hold');
                                      longHold(msg);
                                    },
                                    child: const Icon(
                                      Icons.play_circle_outlined,
                                      size: 100,
                                    ),
                                  ),
                                ],
                                msg.media != null
                                    ? (msg.media!.type == 'image'
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MessagingMediaViewerScreen(
                                                    imageUrl: msg.media!.value,
                                                    tag: tag,
                                                  ),
                                                ),
                                              );
                                            },
                                            onLongPress: () {
                                              print('hold');
                                              longHold(msg);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              constraints: const BoxConstraints(
                                                  maxHeight: 800,
                                                  maxWidth: 300),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Hero(
                                                  tag: tag,
                                                  child: Image.network(
                                                      msg.media!.value,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      // Image has successfully loaded
                                                      return child;
                                                    } else {
                                                      // Image is still loading
                                                      return CircularProgressIndicator();
                                                    }
                                                  }, errorBuilder:
                                                          (BuildContext context,
                                                              Object error,
                                                              StackTrace?
                                                                  stackTrace) {
                                                    // Handle image loading errors
                                                    return const SizedBox(
                                                      height: 0,
                                                    );
                                                  }),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 0,
                                          ))
                                    : Container(
                                        height: 0,
                                      ),
                                Column(
                                  crossAxisAlignment: msg.byMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    msg.text != ""
                                        ? GestureDetector(
                                            onLongPress: () {
                                              longHold(msg);
                                            },
                                            child: Card(
                                              margin: EdgeInsets.fromLTRB(
                                                  4,
                                                  msg.reply == null ? 4 : 0,
                                                  4,
                                                  4),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              elevation: 0,
                                              color:
                                                  this.msg.name == user.username
                                                      ? Colors.blue
                                                      : Color.fromARGB(
                                                          255, 50, 57, 64),
                                              child: Column(
                                                crossAxisAlignment: msg.byMe
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: RichText(
                                                      textAlign: Bidi.hasAnyRtl(
                                                              msg.text)
                                                          ? TextAlign.end
                                                          : TextAlign.start,
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                            color: msg.name ==
                                                                    user
                                                                        .username
                                                                ? white
                                                                : const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    232,
                                                                    231,
                                                                    231)),
                                                        children:
                                                            buildTextWithButton(
                                                          context,
                                                          msg.text,
                                                          msg.byMe,
                                                        ),
                                                      ),
                                                      softWrap:
                                                          true, // Allow text to wrap within the specified width
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 0,
                                          ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      msg.text != "" ||
                              msg.media != null ||
                              msg.media != 'video'
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(3, 0, 10, 0),
                              child: Text(
                                (msg.byMe || isGroup == false
                                        ? ""
                                        : msg.name + ' . ') +
                                    DateFormat('h:mm a').format(msg.date),
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 0,
          );
  }
}
