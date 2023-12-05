import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/conversation_widget.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_bottom_navigation.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() {
    return CconversationScreenState();
  }
}

class CconversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: ClipOval(
                    child: Image.asset(
                      "assets/images/abo.jpeg",
                      width: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              width: 300,
              child: TextButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 44, 43, 43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "  Search Driect Messages",
                      style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 197, 193, 193)),
                    )),
              )),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Container(
          height: double.infinity,
          child: const SingleChildScrollView(
            child: Column(
              children: [
                ConversationWidget(
                  imagePath: "assets/images/abo.jpeg",
                  name: "Abo asdjfdflsjljfasllfdjjsafdjl",
                  handle: "ahmedMohamed123",
                  lastMsg: "We will win ISA",
                  converstaionID: "1",
                ),
                ConversationWidget(
                  imagePath: "assets/images/abo.jpeg",
                  name: "Abo obeda",
                  handle: "ahmedMohamed123",
                  lastMsg: "We will win ISA",
                  converstaionID: "1",
                ),
                ConversationWidget(
                  imagePath: "assets/images/abo.jpeg",
                  name: "Abo obeda",
                  handle: "ahmedMohamed123",
                  lastMsg: "We will win ISA",
                  converstaionID: "1",
                ),
                ConversationWidget(
                  imagePath: "assets/images/abo.jpeg",
                  name: "Abo obeda",
                  handle: "ahmedMohamed123",
                  lastMsg: "We will win ISA",
                  converstaionID: "1",
                ),
                ConversationWidget(
                  imagePath: "assets/images/abo.jpeg",
                  name: "Abo obeda",
                  handle: "ahmedMohamed123",
                  lastMsg: "We will win ISA",
                  converstaionID: "1",
                ),
                ConversationWidget(
                  imagePath: "assets/images/abo.jpeg",
                  name: "Abo obeda",
                  handle: "ahmedMohamed123",
                  lastMsg: "We will win ISA",
                  converstaionID: "1",
                ),
                ConversationWidget(
                  imagePath: "assets/images/abo.jpeg",
                  name: "Abo obeda",
                  handle: "ahmedMohamed123",
                  lastMsg: "We will win ISA",
                  converstaionID: "1",
                ),
                ConversationWidget(
                  imagePath: "assets/images/abo.jpeg",
                  name: "Abo obeda",
                  handle: "ahmedMohamed123",
                  lastMsg: "We will win ISA",
                  converstaionID: "1",
                ),
                ConversationWidget(
                  imagePath: "assets/images/abo.jpeg",
                  name: "Abo obeda",
                  handle: "ahmedMohamed123",
                  lastMsg: "We will win ISA",
                  converstaionID: "1",
                ),
                ConversationWidget(
                  imagePath: "assets/images/abo.jpeg",
                  name: "Abo obeda",
                  handle: "ahmedMohamed123",
                  lastMsg: "We will win ISA",
                  converstaionID: "1",
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const QwitterBottomNavigationBar(),
        backgroundColor: Colors.black,
      ),
    );
  }
}
