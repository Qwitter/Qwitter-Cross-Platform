import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweets_feed_screen.dart';

class ConversationWidget extends StatelessWidget {
  const ConversationWidget({
    super.key,
    required this.imagePath,
    required this.name,
    required this.handle,
    required this.lastMsg,
    required this.converstaionID,
  });
  final String imagePath;
  final String name;
  final String handle;
  final String lastMsg;
  final String converstaionID;
  @override
  Widget build(BuildContext context) {
    String date = "";

    void switchToMessagingScreen() {
      print("hello world");
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => MessagingScreen(
                  converstaionID: converstaionID,
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
                      image: AssetImage(imagePath),
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
                  Row(
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        style: const TextStyle(
                            overflow: TextOverflow.clip,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          "@ $handle",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    lastMsg,
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
