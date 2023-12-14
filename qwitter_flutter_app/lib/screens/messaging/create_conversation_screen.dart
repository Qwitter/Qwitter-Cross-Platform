import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/search_user_widget.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/providers/user_search_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversations_screen.dart';
import 'package:qwitter_flutter_app/screens/messaging/messaging_screen.dart';
import 'package:qwitter_flutter_app/theme/theme_constants.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class CreateConversationScreen extends ConsumerStatefulWidget {
  const CreateConversationScreen({
    super.key,
  });
  @override
  ConsumerState<CreateConversationScreen> createState() =>
      _CreateConversationScreenState();
}

class _CreateConversationScreenState
    extends ConsumerState<CreateConversationScreen> {
  List<User> selectedUsers = [];
  List<User> users = [];
  String fetching = "";
  bool isFetching = false;
  bool createPushed = false;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(textLisetner);
    searchUser("").then(
      (users) => {ref.watch(userSearchProvider.notifier).initData(users)},
    );
    //call CreateConversation api get latest page;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  static Future<http.Response> searchUserRespone(String data) async {
    final url = Uri.parse(
        'http://qwitter.cloudns.org:3000/api/v1/conversation/user?q=$data');

    AppUser user = AppUser();

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${user.token}',
    });

    return response;
  }

  static Future<List<User>> searchUser(String data) async {
    try {
      final response = await searchUserRespone(data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> userList = jsonBody['users'] as List<dynamic>;

        List<User> users = userList.map((user) => User.fromJson(user)).toList();
        print(users.length);
        print("doneU");
        return users;
      } else {
        return [];
      }
    } catch (e) {
      print("Searching User Error");
      return [];
    }
  }

  Future<void> getUsers(String data) async {
    fetching = textController.text;
    isFetching = true;
    List<User> users = await searchUser(data);
    ref.watch(userSearchProvider.notifier).initData(users);
    isFetching = false;
  }

  textLisetner() {
    if ((isFetching && textController.text == fetching)) return;
    getUsers(textController.text);
  }

  cardButtonFunction(User user) {
    ref.watch(selectedUserProvider.notifier).removeUser(user);
  }

  Future<http.Response> createConversationResponse() async {
    final url =
        Uri.parse('http://qwitter.cloudns.org:3000/api/v1/conversation');

    Map<String, dynamic> fields = {
      'conversation_name': 'name',
      'users': selectedUsers.map((user) => user.username ?? "").toList()
    };
    print(jsonEncode(fields));
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'authorization': 'Bearer ${AppUser().getToken}',
        },
        body: jsonEncode(fields));

    return response;
  }

  Future<void> createConverstaion() async {
    if (createPushed == true) return;
    print(createPushed);
    print(selectedUsers.length);
    if (selectedUsers.isEmpty) {
      Fluttertoast.showToast(
        msg: "You didn't select any user",
        backgroundColor: Colors.grey[700],
      );
      return;
    }
    try {
      createPushed = true;
      final response = await createConversationResponse();
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        Conversation convo = Conversation.fromJson(jsonBody);

        Navigator.of(context).pop();
        ref.watch(messagesProvider.notifier).DeleteHistory();
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => MessagingScreen(convo: convo)),
        );
        Fluttertoast.showToast(
          msg: "conversation Created successfully",
          backgroundColor: Colors.grey[700],
        );
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "Bad request",
          backgroundColor: Colors.grey[700],
        );
      } else if (response.statusCode == 409) {
        Fluttertoast.showToast(
          msg: "conflict",
          backgroundColor: Colors.grey[700],
        );
      }
    } catch (e) {
      print("creating converstaion error");
    }
    createPushed = false;
  }

  @override
  Widget build(context) {
    selectedUsers = ref.watch(selectedUserProvider);
    users = ref.watch(userSearchProvider);

    // selectedUsers = ref.watch(selectedUserProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
            backgroundColor: black,
            automaticallyImplyLeading: true,
            title: const Text("Create a conversation"),
            actions: [
              ElevatedButton(
                onPressed: createConverstaion,
                style: ElevatedButton.styleFrom(backgroundColor: black),
                child: const Text(
                  "Create",
                  style: TextStyle(color: white),
                ),
              ),
            ]),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(children: [
          // Divider(R
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(color: Colors.black),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedUsers.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    cardButtonFunction(selectedUsers[index]);
                  },
                  child: Card(
                    color: const Color.fromARGB(255, 56, 56, 56),
                    child: Center(
                      widthFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(selectedUsers[index].fullName ?? ""),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return SearchUserWidget(
                    user: users[index],
                    selected: selectedUsers
                        .where((element) =>
                            element.username == users[index].username)
                        .isNotEmpty);
              },
            ),
          )
        ]),
      ),
    );
  }
}
