import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/utils/enums.dart';

class NotificationCard extends StatelessWidget {
  final NotificationType type;
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
  ];

  Icon getIcon() {
    switch (type) {
      case NotificationType.like_type:
        return icons[0];
      case NotificationType.follow_type:
        return icons[1];
      case NotificationType.retweet_type:
        return icons[2];
      default:
        return icons[0];
    }
  }

  NotificationCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                width: MediaQuery.of(context).size.width * 0.15,
                child: getIcon(),
              ),
              Expanded(
                  child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                // decoration: BoxDecoration(color: Colors.red),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                              "http://back.qwitter.cloudns.org:3000/imgs/user/profile_picture/user-118f3ab1-6895-4a4f-9afe-b99e973a8b531702736951732.jpeg"),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                              "http://back.qwitter.cloudns.org:3000/imgs/user/profile_picture/user-118f3ab1-6895-4a4f-9afe-b99e973a8b531702736951732.jpeg"),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                              "http://back.qwitter.cloudns.org:3000/imgs/user/profile_picture/user-118f3ab1-6895-4a4f-9afe-b99e973a8b531702736951732.jpeg"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Abdallah and 2 others likes your tweet",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "This is the tweet text",
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),
                    ),
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
