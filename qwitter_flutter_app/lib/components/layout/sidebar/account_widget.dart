import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';

class AccountWidget extends StatelessWidget {
  const AccountWidget(
      {super.key,required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage:(user.profilePicture!.path.isEmpty
                      ? const AssetImage("assets/images/def.jpg")
                      : NetworkImage(
                              user.profilePicture!.path.startsWith("http")
                                  ? user.profilePicture!.path
                                  : "http://" + user.profilePicture!.path)
                          as ImageProvider),
          radius: 22,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.fullName}",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
              Text(
                "${user.username}",
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              )
            ],
          ),
        ),
        const Spacer(),
        if (user.username ==AppUser().username)
          const Icon(
            Icons.check_circle_sharp,
            size: 20,
            color: Color.fromARGB(255, 9, 255, 22),
          )
      ],
    );
  }
}
