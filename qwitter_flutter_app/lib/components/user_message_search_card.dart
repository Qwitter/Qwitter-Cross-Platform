import 'package:flutter/material.dart';

class UserMessageSearchCard extends StatelessWidget {
  const UserMessageSearchCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.userName  ,
    required this.isFollowing,
    required this.isFollowed,
    required this.inConversation,
  });
  final String? imagePath;
  final String name;
  final String userName;
  final bool isFollowing;
  final bool isFollowed;
  final bool inConversation;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          print(name);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
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
                    child: Ink.image(
                      image: AssetImage(imagePath ?? "assets/images/abo.jpeg"),
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
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "@$userName",
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                    maxLines: 1,
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
