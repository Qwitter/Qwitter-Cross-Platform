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
    String imageUrl = "";
    if (widget.convo.isGroup) {
      imageUrl = widget.convo.photo ?? "";
    } else if (widget.convo.users.isNotEmpty) {
      imageUrl = widget.convo.users.first.profilePicture?.path ?? "";
    }
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
              child: (imageUrl != "")
                  ? Container(
                      width: 80,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                        "assets/images/def.jpg",
                        width: 80,
                      ),
                    ),
            ),
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
