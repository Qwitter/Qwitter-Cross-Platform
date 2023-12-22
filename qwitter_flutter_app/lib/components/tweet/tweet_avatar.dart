import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';

class TweetAvatar extends StatelessWidget {
  final String username;
  final String avatar;
  final double radius;

  TweetAvatar(
      {Key? key,
      required this.avatar,
      this.radius = 20,
      required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileDetailsScreen(username: username),
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: radius * 0.8, horizontal: radius / 2),
        width: radius * 3,
        child: CircleAvatar(
            radius: radius,
            // backgroundImage: NetworkImage(avatar),
            child: ClipOval(
              child: Image.network(
                avatar,
                width: radius *
                    2, // Set width and height to match the diameter of the circle
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // print("error");
                  // print(exception);
                  // print(stackTrace);
                  // print(avatar);
                  return Center(
                    child: Text(
                      username[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }
}
