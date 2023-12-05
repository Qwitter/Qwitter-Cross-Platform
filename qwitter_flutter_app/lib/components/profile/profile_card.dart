import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/profile/follow_button.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard(
      {super.key,
      required this.isFollowed,
      required this.isVerified,
      required this.profileBackgroundImage,
      required this.profileImage,
      required this.name,
      required this.username,
      required this.bio});
  final bool isFollowed;
  final bool isVerified;
  final String profileImage;
  final String profileBackgroundImage;
  final String name;
  final String username;
  final String bio;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(25),
          color: Colors.white),
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
      height: 300,
      width: 340,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Image.network(
              widget.profileBackgroundImage,
              fit: BoxFit.cover,
              height: 120,
            ),
          ),
          Positioned(
            top: 77,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 43,
              child: CircleAvatar(
                radius: 38,
                backgroundImage: NetworkImage(
                  widget.profileImage,
                ),
              ),
            ),
          ),
          Positioned(
            top: 130,
            right: 20,
            child: Row(
              children: [FollowButton(isFollowed: widget.isFollowed)],
            ),
          ),
          Positioned(
            top: 170,
            left: 15,
            right: 15,
            child: Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (widget.isVerified)
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 18,
                        )
                    ],
                  ),
                  Text(
                    widget.username,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.bio,
                    softWrap: true,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
