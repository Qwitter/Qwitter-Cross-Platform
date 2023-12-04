import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/messaging_text_field.dart';
import 'package:qwitter_flutter_app/components/scrollable_messages.dart';
import 'package:qwitter_flutter_app/models/messeage.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() {
    return _MessagingScreenState();
  }
}

class _MessagingScreenState extends State<MessagingScreen> {
  final textController = TextEditingController();

  List<Message> msgs = [
    Message(
        text: "hello",
        date: DateTime.now().subtract(const Duration(days: 5, minutes: 10)),
        byMe: true),
    Message(
        text: "hi how are ya?",
        date: DateTime.now().subtract(const Duration(days: 5, minutes: 9)),
        byMe: false),
    Message(
        text: "I am actually doing good",
        date: DateTime.now().subtract(const Duration(days: 5, minutes: 8)),
        byMe: true),
    Message(
        text: "how is your family",
        date: DateTime.now().subtract(const Duration(days: 5, minutes: 8)),
        byMe: true),
    Message(
        text: "they are doing well ",
        date: DateTime.now().subtract(const Duration(days: 5, minutes: 7)),
        byMe: false),
    Message(
        text: "how has school been",
        date: DateTime.now().subtract(const Duration(days: 5, minutes: 7)),
        byMe: false),
    Message(
        text: "nothing that exciting to be honest",
        date: DateTime.now().subtract(const Duration(days: 5, minutes: 5)),
        byMe: true),
    Message(
        text: "there's a quiz tomorrow don't forget",
        date: DateTime.now().subtract(const Duration(days: 3, minutes: 2)),
        byMe: false),
    Message(
        text: "thakn you for reminding me",
        date: DateTime.now().subtract(const Duration(days: 2, hours: 20)),
        byMe: true),
    Message(
        text: "are you going to school tomorrow ?",
        date: DateTime.now()
            .subtract(const Duration(days: 1, hours: 5, minutes: 8)),
        byMe: true),
    Message(
        text:
            "yeah, let's meet at 9 am\nyeah, let's meet at 9 am,yeah, let's meet at 9 am,yeah, let's meet at 9 am,yeah, let's meet at 9 am,yeah, let's meet at 9 am,yeah, let's meet at 9 am",
        date: DateTime.now()
            .subtract(const Duration(days: 1, hours: 3, minutes: 50)),
        byMe: false),
    Message(
        text: "that looks great 1",
        date: DateTime.now()
            .subtract(const Duration(days: 1, hours: 1, minutes: 20)),
        byMe: true),
    Message(
        text: "that looks great 2",
        date: DateTime.now()
            .subtract(const Duration(days: 1, hours: 1, minutes: 5)),
        byMe: true),
    Message(
        text: "that looks great 3",
        date: DateTime.now()
            .subtract(const Duration(days: 1, hours: 1, minutes: 5)),
        byMe: true),
    Message(
        text: "that looks great 4",
        date: DateTime.now()
            .subtract(const Duration(days: 1, hours: 1, minutes: 5)),
        byMe: true),
  ];

  void sendMessage() {
    final newMessage = Message(
      text: textController.text,
      date: DateTime.now(),
      byMe: true,
    );
    setState(() => msgs.add(newMessage));
    textController.text = "";
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          title: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/abo.jpeg",
                  width: 35,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              const SizedBox(
                width: 175,
                child: Text(
                  "User Name sdfs d fsd f sd f sd ",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_outlined,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            ScrollableMessages(msgs: msgs),
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MessagingTextField(textController: textController),
                    const SizedBox(
                      width: 10,
                    ), // Add some spacing between the TextField and the button

                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.send),
                        onPressed: sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
