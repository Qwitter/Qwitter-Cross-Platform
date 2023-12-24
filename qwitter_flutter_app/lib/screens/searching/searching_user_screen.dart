import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/custom_search_field.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/search_profile_widget.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/hashtag_search_provider.dart';
import 'package:qwitter_flutter_app/providers/user_profile_search_provider.dart';
import 'package:qwitter_flutter_app/screens/searching/search_screen.dart';

class SearchUserScreen extends ConsumerStatefulWidget {
  const SearchUserScreen({super.key, this.token});
  final String? token;

  @override
  ConsumerState<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends ConsumerState<SearchUserScreen> {
  List<User> search = [];
  List<String> hashSearch = [];
  final searchController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userSearchProfileProvider.notifier).remove();
      ref.read(hastagSearchProvider.notifier).remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        ref.read(userSearchProfileProvider.notifier).remove();
        ref.read(hastagSearchProvider.notifier).remove();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: CustomSearchField(controller: searchController),
          ),
          body: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
            search = ref.watch(userSearchProfileProvider);
            hashSearch = ref.watch(hastagSearchProvider);
            return Center(
                child: (search.isNotEmpty || hashSearch.isNotEmpty)
                    ? CustomScrollView(
                        slivers: <Widget>[
                          hashSearch.isNotEmpty
                              ? SliverList.builder(
                                  itemCount: hashSearch.length > 3
                                      ? 3
                                      : hashSearch.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        width: double.infinity,
                                        child: Text(
                                          hashSearch[index],
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return SearchScreen(
                                            hastag: hashSearch[index],
                                            query: "",
                                          );
                                        }));
                                      },
                                    );
                                  },
                                )
                              : const SliverToBoxAdapter(
                                  child: SizedBox(),
                                ),
                          search.isNotEmpty
                              ? SliverList.builder(
                                  itemCount: search.length,
                                  itemBuilder: (context, index) {
                                    return SearchProfileWidget(
                                      mainName: search[index].fullName,
                                      littleText: search[index].username,
                                      photLink:
                                          search[index].profilePicture!.path,
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return ProfileDetailsScreen(
                                              username: search[index].username!,
                                            );
                                          },
                                        ));
                                      },
                                    );
                                  },
                                )
                              : const SliverToBoxAdapter(
                                  child: SizedBox(),
                                ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          "Search for users or hashtags",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ));
          })),
    );
  }
}
