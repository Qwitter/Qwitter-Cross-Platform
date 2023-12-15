import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/conversation_widget.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_bottom_navigation.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/providers/conversations_provider.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/providers/user_search_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/create_conversation_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/services/Messaging_service.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});

  @override
  ConsumerState<ConversationScreen> createState() {
    return ConversationScreenState();
  }
}

class ConversationScreenState extends ConsumerState<ConversationScreen> {
  @override
  void initState() {
    super.initState();
    // MessagingServices.connect("47a89388-ebc8-4e2f-af2f-b2c075b540ac");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      MessagingServices.getConversations().then((list) {
        ref.read(ConversationProvider.notifier).InitConversations(list);
      }).onError((error, stackTrace) {
        //print(error);
      });
    });
  }

  Future<void> refresh() async {
    MessagingServices.test();
    MessagingServices.getConversations().then((list) {
      ref.read(ConversationProvider.notifier).InitConversations(list);
    }).onError((error, stackTrace) {
      //print(error);
    });
  }

  void goToCreateConversationScreen() {
    ref.watch(selectedUserProvider.notifier).deleteHistory();
    ref.watch(userSearchProvider.notifier).deleteHistory();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateConversationScreen(),
      ),
    );
  }

  List<Conversation> conversations = [];
  @override
  Widget build(context) {
    conversations = ref.watch(ConversationProvider);
    return Scaffold(
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 197, 193, 193)),
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
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (ctx, idx) {
            return ConversationWidget(convo: conversations[idx]);
          },
        ),
      ),
      bottomNavigationBar: const QwitterBottomNavigationBar(),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: goToCreateConversationScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
