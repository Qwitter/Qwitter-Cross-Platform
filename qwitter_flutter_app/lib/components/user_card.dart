import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button_outlined.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';

class UserCard extends StatefulWidget {
  UserCard({super.key, this.onPressed, this.isFollowed = false, this.userData});
  final VoidCallback? onPressed;
  bool isFollowed;
  final Map<String, dynamic>? userData;
  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Future<http.Response> followUser() async {
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/user/follow/${widget.userData?['userName']}');
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

    print('username: ${widget.userData?['userName']}');

    return response;
  }

  Future<http.Response> unFollowUser() async {
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/user/follow/${widget.userData?['userName']}');

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

    print('username: ${widget.userData?['userName']}');

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ProfileDetailsScreen(
                    username: widget.userData?['userName'])),
          );
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0,
          minVerticalPadding: 0,
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.userData?['profileImageUrl'] ??
                'https://i.stack.imgur.com/l60Hf.png'),
          ),
          title: Text(
            widget.userData?['name'],
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
              '@${widget.userData?['userName']}',
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
            child: widget.userData?['userName'] == AppUser().username
                ? const SizedBox(width: 1)
                : widget.isFollowed
                    ? SecondaryButtonOutlined(
                        text: 'Following',
                        onPressed: () {
                          unFollowUser().then((value) {
                            print(value.reasonPhrase);
                            print(value.body);
                          });
                          setState(() {
                            widget.isFollowed = false;
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
                            widget.isFollowed = true;
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
                widget.userData?['description'] ??
                    'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                        .substring(0, 90),
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
