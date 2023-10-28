import 'package:flutter/material.dart';

class TweetMenu extends StatelessWidget {
  
  final opentweetMenuModal;

  const TweetMenu({
    Key? key,
    required this.opentweetMenuModal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  // backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  alignment: Alignment.centerRight
                ),
            onPressed: opentweetMenuModal,
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ],
      ),);
  }
}