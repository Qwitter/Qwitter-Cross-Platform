import 'package:flutter/material.dart';

class AccountWidget extends StatelessWidget {
  const AccountWidget(
      {super.key,
      required this.name,
      required this.username,
      required this.imgURL,
      required this.isSignedIn});
  final String name;
  final String username;
  final String imgURL;
  final String isSignedIn;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imgURL),
          radius: 22,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
              Text(
                username,
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              )
            ],
          ),
        ),
        const Spacer(),
        if (isSignedIn == "true")
          const Icon(
            Icons.check_circle_sharp,
            size: 20,
            color: Color.fromARGB(255, 9, 255, 22),
          )
      ],
    );
  }
}
