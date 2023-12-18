import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/user_profile_search_provider.dart';

class CustomSearchField extends ConsumerStatefulWidget {
  const CustomSearchField({
    super.key,
    required this.controller,
  });
  final TextEditingController? controller;

  @override
  ConsumerState<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends ConsumerState<CustomSearchField> {
  // bool _isSelected = false;

  bool isIconShowed = false;

  void searchUser(String data) async {
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/user/search?q=$data');

    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${AppUser().getToken}',
    };

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
    });

    if (response.statusCode == 200) {
      List<User> users = [];
      var result = jsonDecode(response.body);
      result = result['users'];

      for (var user in result) {
        users.add(User.fromJson(user));
      }
      print("Iam here");
      ref.read(userSearchProfileProvider.notifier).setUsers(users);
    } else {
      //print('response status code : ${response.statusCode}');
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              isIconShowed = true;
            });
            searchUser(value);
          } else {
            setState(() {
              isIconShowed = false;
            });
            ref.read(userSearchProfileProvider.notifier).remove();
          }
        },
        style: const TextStyle(color: Color.fromARGB(255, 29, 155, 240)),
        decoration: InputDecoration(
          hintText: 'Search Qwitter',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: isIconShowed
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.controller!.clear();
                      isIconShowed = false;
                    });
                    ref.read(userSearchProfileProvider.notifier).remove();
                  },
                  icon: const Icon(Icons.clear))
              : const SizedBox(),
        ));
  }
}
