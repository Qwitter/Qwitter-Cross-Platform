import 'package:flutter/material.dart';

class QwitterTitleAppBar extends StatelessWidget {
  const QwitterTitleAppBar({
    super.key,
    required this.title,
    required this.extraTitle,
  });

  final String? title;
  final String? extraTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      title: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                extraTitle!,
                style: TextStyle(color: Colors.grey[300], fontSize: 14),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
      elevation: 1,
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 1),
        child: Divider(
          color: Colors.grey[900],
        ),
      ),
    );
  }
}
