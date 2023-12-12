import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/custom_search_field.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/search_profile_widget.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/providers/user_profile_search_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/login/login_email_screen.dart';

class SearchUserScreen extends ConsumerStatefulWidget {
  const SearchUserScreen({super.key, this.token});
  final String? token;

  @override
  ConsumerState<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends ConsumerState<SearchUserScreen> {
  List<User> search = [];
  final searchController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    ref.read(userSearchProfileProvider.notifier).remove();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userSearchProfileProvider.notifier).remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomSearchField(controller: searchController),
        ),
        body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
          search = ref.watch(userSearchProfileProvider);
          return search.isNotEmpty
              ? Center(
                  child: ListView.builder(
                    itemCount: search.length,
                    itemBuilder: (context, index) {
                      return SearchProfileWidget(
                        mainName: search[index].fullName,
                        littleText: search[index].username,
                        photLink: search[index].profilePicture!.path,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ProfileDetailsScreen(
                                username: search[index].username!,
                              );
                            },
                          ));
                        },
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text("Searching for the result"),
                );
        }));
  }
}
