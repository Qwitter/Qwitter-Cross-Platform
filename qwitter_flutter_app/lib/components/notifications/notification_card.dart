import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/components/tweet_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/notification.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/utils/enums.dart';

class NotificationCard extends StatelessWidget {
  final NotificationType type;
  final QwitterNotification notification;
  final List<Icon> icons = [
    const Icon(
      Icons.favorite,
      color: Colors.pink,
      size: 25,
    ),
    const Icon(
      Icons.person,
      color: Colors.blue,
      size: 25,
    ),
    const Icon(
      Icons.repeat_outlined,
      color: Colors.green,
      size: 25,
    ),
    const Icon(
      Icons.login,
      color: Colors.blue,
      size: 25,
    ),
  ];

  Icon getIcon() {
    switch (type) {
      case NotificationType.like_type:
        return icons[0];
      case NotificationType.follow_type:
        return icons[1];
      case NotificationType.retweet_type:
        return icons[2];
      case NotificationType.login_type:
        return icons[3];
      default:
        return icons[0];
    }
  }

  NotificationCard({super.key, required this.type, required this.notification});

  @override
  Widget build(BuildContext context) {
    AppUser? user = AppUser();
    user.getUserData();
    return notification.type == NotificationType.reply_type || notification.type == NotificationType.post_type
        ? TweetCard(tweet: notification.tweet!)
        : Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[600]!, // Border color
                  width: 0.15, // Border width
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // constraints: BoxConstraints(
                      //   maxHeight: 100, // Set your maximum height value here
                      // ),
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: getIcon(),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      // decoration: BoxDecoration(color: Colors.red),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              notification.type ==
                                          NotificationType.follow_type ||
                                      notification.type ==
                                          NotificationType.like_type ||
                                      notification.type ==
                                          NotificationType.retweet_type
                                  ? CircleAvatar(
                                      radius: 18,
                                      backgroundImage: (notification.user !=
                                                  null &&
                                              notification
                                                      .user!.profilePicture !=
                                                  null &&
                                              notification.user!.profilePicture!
                                                      .path !=
                                                  null)
                                          ? NetworkImage(notification
                                              .user!.profilePicture!.path)
                                          : const AssetImage(
                                                  'assets/images/def.jpg')
                                              as ImageProvider,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          SizedBox(
                            height: notification.type ==
                                        NotificationType.follow_type ||
                                    notification.type ==
                                        NotificationType.like_type ||
                                    notification.type ==
                                        NotificationType.retweet_type
                                ? 10
                                : 0,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: RichText(
                                text: TextSpan(children: [
                                  notification.type ==
                                              NotificationType.follow_type ||
                                          notification.type ==
                                              NotificationType.like_type ||
                                          notification.type ==
                                              NotificationType.retweet_type
                                      ? TextSpan(
                                          text: notification.user!.fullName!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // Handle button press
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileDetailsScreen(
                                                    username: notification
                                                        .user!.username!,
                                                  ),
                                                ),
                                              );
                                            },
                                        )
                                      : const TextSpan(),
                                  TextSpan(
                                    text: notification.type ==
                                            NotificationType.follow_type
                                        ? " followed you"
                                        : notification.type ==
                                                NotificationType.login_type
                                            ? "There was a recent login to your account @${user.username ?? ''}"
                                            : notification.type ==
                                                    NotificationType.like_type
                                                ? " liked your tweet"
                                                : notification.type ==
                                                        NotificationType
                                                            .retweet_type
                                                    ? " reposted your post"
                                                    : " ",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ]),
                              )),
                          notification.type == NotificationType.like_type ||
                                  notification.type ==
                                      NotificationType.retweet_type
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    notification.tweetText ?? "",
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 14),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ))
                  ],
                ),
              ],
            ),
          );
  }
}
