import 'package:flutter/material.dart';

class TweetBottomActionBar extends StatelessWidget {
  int comments_count;
  int reposts_count;
  int likes_count;

  final bool reposted;
  final bool liked;

  final makeFollow;
  final openRepostModal;
  final makeLike;

  TweetBottomActionBar({
    required this.comments_count,
    required this.reposts_count,
    required this.likes_count,
    required this.makeFollow,
    required this.openRepostModal,
    required this.makeLike,
    required this.reposted,
    required this.liked,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 65,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextButton.icon(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  alignment: Alignment.centerLeft),
              onPressed: () {},
              icon: Icon(
                Icons.chat_bubble_outline,
                color: Colors.grey[600],
                size: 16,
              ),
              label: FittedBox(
                child: Text(
                  comments_count.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextButton.icon(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  alignment: Alignment.centerLeft),
              onPressed: openRepostModal,
              icon: Icon(
                Icons.repeat_outlined,
                color: reposted ? Colors.green : Colors.grey[600],
                size: 18,
              ),
              label: FittedBox(
                child: Text(
                  reposts_count.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: reposted ? Colors.green : Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextButton.icon(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  alignment: Alignment.centerLeft),
              onPressed: makeLike,
              icon: Icon(
                liked ? Icons.favorite : Icons.favorite_border,
                color: liked ? Colors.pink : Colors.grey[600],
                size: 16,
              ),
              label: FittedBox(
                child: Text(
                  likes_count.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: liked ? Colors.pink : Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  alignment: Alignment.centerLeft),
              onPressed: () {},
              icon: Icon(
                Icons.share_outlined,
                color: Colors.grey[600],
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
