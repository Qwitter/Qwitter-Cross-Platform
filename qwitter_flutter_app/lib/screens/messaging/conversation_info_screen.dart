import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/conversation_widget.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/conversations_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversation_users_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/create_conversation_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/edit_conversation_screen.dart';
import 'package:http/http.dart' as http;

class ConversationInfoScreen extends ConsumerStatefulWidget {
  ConversationInfoScreen({
    super.key,
    required this.convo,
    required this.updateConvo,
  });
  Conversation convo;
  Function(List<User>) updateConvo;
  @override
  ConsumerState<ConversationInfoScreen> createState() =>
      _ConversationInfoScreenState();
}

class _ConversationInfoScreenState
    extends ConsumerState<ConversationInfoScreen> {
  void leave() async {
    String conversationId = widget.convo.id;
    AppUser user = AppUser();
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/conversation/$conversationId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': 'Bearer ${user.token}',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      ref.read(ConversationProvider.notifier).removeConvo(
            widget.convo,
          );
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = "";
    if (widget.convo.isGroup) {
      imageUrl = widget.convo.photo ?? "";
    } else if (widget.convo.users.isNotEmpty) {
      imageUrl = widget.convo.users.first.profilePicture?.path ?? "";
    }
    print(imageUrl);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, widget.convo);
        return Future(() => false);
      },
      child: Scaffold(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditConversationScreen(
                              convo: widget.convo,
                              f: (Conversation convo) {
                                setState(() {
                                  widget.convo = convo;
                                });
                              },
                            ),
                          ),
                        ).then(
                          (value) {
                            if (value != null) {
                              setState(() {
                                widget.convo = value!;
                              });
                            }
                          },
                        );
                      },
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
                      imageUrl != "" ? imageUrl : '',
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
                        return Image.asset(
                          "assets/images/def.jpg",
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
                        onUpdate: widget.updateConvo,
                      ),
                    ),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        widget.convo = value!;
                      });
                    }
                  });
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
                ),
              ),
              Divider(
                height: 5,
              ),
              InkWell(
                  onTap: leave,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 60,
                    width: double.infinity,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Leave Conversation",
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      ),
                    ),
                  ))
            ],
          ],
        ),
      ),
    );
  }
}
