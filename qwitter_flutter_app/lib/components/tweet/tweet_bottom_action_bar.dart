import 'package:flutter/material.dart';

class TweetBottomActionBar extends StatelessWidget {
  final int commentsCount;
  final int repostsCount;
  final int likesCount;

  final bool reposted;
  final bool liked;

  final makeFollow;
  final makeComment;
  final openRepostModal;
  final makeLike;

  TweetBottomActionBar({
    required this.commentsCount,
    required this.repostsCount,
    required this.likesCount,
    required this.makeFollow,
    required this.makeComment,
    required this.openRepostModal,
    required this.makeLike,
    required this.reposted,
    required this.liked,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 65,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextButton.icon(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  alignment: Alignment.centerLeft),
              onPressed: makeComment,
              icon: Icon(
                Icons.chat_bubble_outline,
                color: Colors.grey[600],
                size: 16,
              ),
              label: FittedBox(
                child: Text(
                  commentsCount.toString(),
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
                  repostsCount.toString(),
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
                  likesCount.toString(),
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
