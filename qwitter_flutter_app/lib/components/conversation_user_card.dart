import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button_outlined.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/profile_tweets_provider.dart';

class ConversationUserCard extends StatefulWidget {
  const ConversationUserCard({
    super.key,
    this.onPressed,
    required this.userData,
  });
  final VoidCallback? onPressed;
  final User userData;
  @override
  State<ConversationUserCard> createState() => _UserCardState();
}

class _UserCardState extends State<ConversationUserCard> {
  Future<http.Response> followUser() async {
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/user/follow/${widget.userData.username}');
    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${AppUser().getToken}',
    };

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Cookie': cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; '),
      },
    );

    print('username: ${widget.userData.username}');

    return response;
  }

  Future<http.Response> unFollowUser() async {
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/user/follow/${widget.userData?.username}');

    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${AppUser().getToken}',
    };

    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Cookie': cookies.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join('; '),
      },
    );

    print('username: ${widget.userData?.username}');

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    ProfileDetailsScreen(username: widget.userData.username!)),
          );
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0,
          minVerticalPadding: 0,
          leading: ClipOval(
            // borderRadius: BorderRadius.circular(30),
            child: Image.network(
              widget.userData.profilePicture?.path ?? "",
              width: 40,
              height: 40,
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
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                // Handle image loading errors
                return ClipOval(
                  child: Image.asset(
                    "assets/images/def.jpg",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          title: Text(
            widget.userData.fullName!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 222, 222, 222),
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Transform.translate(
            offset: const Offset(0, -5),
            child: Text(
              '@${widget.userData.username}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 132, 132, 132),
              ),
            ),
          ),
          trailing: Transform.translate(
            offset: const Offset(0, -5),
            child: widget.userData.username == AppUser().username
                ? const SizedBox(width: 1)
                : widget.userData.isFollowed ?? false
                    ? SecondaryButtonOutlined(
                        text: 'Following',
                        onPressed: () {
                          unFollowUser().then((value) {
                            print(value.reasonPhrase);
                            print(value.body);
                          });
                          setState(() {
                            widget.userData.isFollowed = false;
                          });
                        },
                        paddingValue: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 35),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : SecondaryButton(
                        text: 'Follow',
                        onPressed: () {
                          followUser().then((value) {
                            print(value.reasonPhrase);
                            print(value.body);
                          });
                          setState(() {
                            widget.userData.isFollowed = true;
                          });
                        },
                        paddingValue: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 35),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
          ),
        ),
      ),
      Transform.translate(
        offset: const Offset(0, -15),
        child: Row(
          children: [
            const SizedBox(width: 57),
            Expanded(
              child: Text(
                widget.userData.description ??'',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 222, 222, 222),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
