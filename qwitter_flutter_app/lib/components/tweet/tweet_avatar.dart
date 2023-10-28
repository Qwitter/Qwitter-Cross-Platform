import 'package:flutter/material.dart';

class TweetAvatar extends StatelessWidget {
  
  final String avatar;
  final double radius;

  const TweetAvatar({Key? key, required this.avatar, this.radius = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: radius*0.8, horizontal: radius/2),
      width: radius*3,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(avatar),
      ),
    );
  }
}