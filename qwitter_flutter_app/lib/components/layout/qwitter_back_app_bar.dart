import 'package:flutter/material.dart';

class QwitterBackAppBar extends StatelessWidget {
  const QwitterBackAppBar(
      {super.key,
      this.onPressed,
      this.currentIcon = Icons.arrow_back,
      required this.title,
      this.extraTitle = ""});
  final VoidCallback? onPressed;
  final IconData currentIcon;
  final String title;
  final String extraTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      title: Stack(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              currentIcon,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  extraTitle,
                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                ),
              ],
            ),
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
