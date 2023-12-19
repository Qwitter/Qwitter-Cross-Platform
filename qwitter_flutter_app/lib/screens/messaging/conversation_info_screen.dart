import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/conversation_widget.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversation_users_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/create_conversation_screen.dart';

class ConversationInfoScreen extends StatefulWidget {
  ConversationInfoScreen({
    super.key,
    required this.convo,
  });
  Conversation convo;

  @override
  State<ConversationInfoScreen> createState() => _ConversationInfoScreenState();
}

class _ConversationInfoScreenState extends State<ConversationInfoScreen> {
  void updateConvo(List<User> list) {
    setState(() {
      widget.convo.users.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        "https://img.freepik.com/premium-vector/flat-instagram-icons-notifications_619991-50.jpg?size=626&ext=jpg";
    if (widget.convo.isGroup) {
      imageUrl = widget.convo.photo ??
          "https://img.freepik.com/premium-vector/flat-instagram-icons-notifications_619991-50.jpg?size=626&ext=jpg";
    } else if (widget.convo.users.isNotEmpty) {
      imageUrl = widget.convo.users.first.profilePicture?.path ??
          "https://img.freepik.com/premium-vector/flat-instagram-icons-notifications_619991-50.jpg?size=626&ext=jpg";
    }
    print(imageUrl);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: AppBar(
          title: Text(
            widget.convo.isGroup
                ? "Group information"
                : "Conversation information",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            widget.convo.isGroup
                ? TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue),
                    ))
                : const SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipOval(
                  child: Image.network(
                    imageUrl != ""
                        ? imageUrl
                        : 'https://img.freepik.com/premium-vector/flat-instagram-icons-notifications_619991-50.jpg?size=626&ext=jpg',
                    width: 80,
                    height: 80,
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
                      return Image.network(
                        "https://img.freepik.com/premium-vector/flat-instagram-icons-notifications_619991-50.jpg?size=626&ext=jpg",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                widget.convo.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 2,
          ),
          if (widget.convo.isGroup) ...[
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "People",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              child: Container(
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text.rich(
                    TextSpan(
                      text: "People\n",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                            text: widget.convo.users.length.toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  print(widget.convo);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateConversationScreen(
                        convo: widget.convo,
                        onUpdate: updateConvo,
                      ),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 60,
                  width: double.infinity,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Add people",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  ),
                ))
          ],
        ],
      ),
    );
  }
}
