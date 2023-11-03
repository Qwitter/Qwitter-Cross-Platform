import 'package:flutter/material.dart';

class QwitterAppBar extends StatelessWidget {
  const QwitterAppBar({
    super.key,
    this.isButton = false,
    this.onPressed,
    this.currentIcon = Icons.close,
    this.showLogoOnly = false,
  });
  final bool isButton;
  final VoidCallback? onPressed;
  final IconData currentIcon;
  final bool showLogoOnly;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      title: Stack(
        children: [
          showLogoOnly
              ? const SizedBox(
                  width: 1,
                )
              : !isButton
                  ? const CircleAvatar(
                      radius: 13,
                      backgroundImage: NetworkImage(
                          'https://ih1.redbubble.net/image.2967438346.0043/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.jpg'),
                    )
                  : IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        currentIcon,
                        color: Colors.white,
                      ),
                    ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                  'https://freelogopng.com/images/all_img/1690643777twitter-x%20logo-png-white.png',
                  width: 24,
                  height: 24),
              Text(''),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
