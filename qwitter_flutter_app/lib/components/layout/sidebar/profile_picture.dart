import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String imageURL;
  final String username;
  final String name;

  const ProfilePicture(
      {super.key,
      required this.imageURL,
      required this.name,
      required this.username});
  void onTap() {
    print("object");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(imageURL), fit: BoxFit.cover),
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '@$username',
                style: TextStyle(
                    color: Colors.grey.shade800, fontSize: 15, height: 0.9),
              )
            ],
          ),
        ),
        const SizedBox(height: 20,),
        Row(children: [Text('2 Following 0 Follwers',style: TextStyle(color: Colors.grey.shade800,fontSize: 17),)],)
      ],
    );
  }
}
