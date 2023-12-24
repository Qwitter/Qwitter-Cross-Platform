import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/conversation_widget.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_bottom_navigation.dart';
import 'package:qwitter_flutter_app/components/layout/sidebar/main_drawer.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/providers/conversations_provider.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/providers/user_search_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/create_conversation_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/services/Messaging_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});

  @override
  ConsumerState<ConversationScreen> createState() {
    return conversationScreenState();
  }
}

class conversationScreenState extends ConsumerState<ConversationScreen> {
  AppUser user = AppUser();
  int requestNumber = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // MessagingServices.connect("47a89388-ebc8-4e2f-af2f-b2c075b540ac");
    MessagingServices.initSocket();
    MessagingServices.getConversations().then((list) {
      ref.read(ConversationProvider.notifier).InitConversations(list);
    }).onError((error, stackTrace) {
      //print(error);
    });
  }

  Future<void> refresh() async {
    final int cur = requestNumber;
    requestNumber += 1;
    await MessagingServices.getConversations().then(
      (list) {
        print(cur);
        if (cur == requestNumber - 1) {
          ref.read(ConversationProvider.notifier).InitConversations(list);
        }
      },
    ).onError((error, stackTrace) {
      //print(error);
    });
  }

  void goToCreateConversationScreen() {
    ref.watch(selectedUserProvider.notifier).deleteHistory();
    ref.watch(userSearchProvider.notifier).deleteHistory();
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => CreateConversationScreen(onUpdate: () {}),
      ),
    )
        .then(
      (value) {
        print('popped');
        print(value);
        MessagingServices.getConversations().then(
          (list) {
            ref.read(ConversationProvider.notifier).InitConversations(list);
          },
        ).onError(
          (error, stackTrace) {
            //print(error);
          },
        );
      },
    );
    ;
  }

  void onUpdate(
    Conversation convo,
  ) {}
  List<Conversation> conversations = [];
  double radius = 15;
  @override
  Widget build(context) {
    conversations = ref.watch(ConversationProvider);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MainDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: QwitterAppBar(
          autoImplyLeading: false,
          scaffoldKey: _scaffoldKey,
        ),
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
      backgroundColor: Colors.black,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
        child: Container(
          height: 65,
          width: 65,
          child: FloatingActionButton(
            shape: CircleBorder(),
            onPressed: goToCreateConversationScreen,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
