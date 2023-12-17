import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_media_viewer_screen.dart';
import 'package:qwitter_flutter_app/theme/theme_constants.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';

class MessageCard extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    AppUser user = AppUser();
    if (msg.media != null) {
      print(msg.media!.value);
    }
    return Column(
      crossAxisAlignment:
          msg.byMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                                ProfileDetailsScreen(username: msg.name),
                          ),
                        );
                      },
                      child: msg.byMe == false
                          ? (msg.profileImageUrl != null &&
                                  user.profilePicture?.path != '')
                              ? Container(
                                  width: radius * 2,
                                  child: CircleAvatar(
                                    radius: radius,
                                    backgroundImage: NetworkImage(
                                        user.profilePicture?.path ?? ""),
                                  ),
                                )
                              : ClipOval(
                                  child: Image.asset(
                                    "assets/images/def.jpg",
                                    width: 35,
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
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                constraints: const BoxConstraints(
                                    maxHeight: 800, maxWidth: 300),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Hero(
                                    tag: tag,
                                    child: Image.network(msg.media!.value,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        // Image has successfully loaded
                                        return child;
                                      } else {
                                        // Image is still loading
                                        return CircularProgressIndicator();
                                      }
                                    }, errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                                color: this.msg.name == user.username
                                    ? Colors.blue
                                    : Color.fromARGB(255, 50, 57, 64),
                                child: Column(
                                  crossAxisAlignment: msg.byMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text(
                                        this.msg.text,
                                        style: TextStyle(
                                            color:
                                                this.msg.name == user.username
                                                    ? white
                                                    : Color.fromARGB(
                                                        255, 232, 231, 231)),
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
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            (msg.byMe || isGroup == false ? "" : msg.name + ' . ') +
                DateFormat('h:mm a').format(msg.date),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
