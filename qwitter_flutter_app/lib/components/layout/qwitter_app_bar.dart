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
      centerTitle: showLogoOnly ? true : false,
      title: Stack(
        children: [
          showLogoOnly
              ? const SizedBox(
                  width: 1,
                )
              : !isButton
                  ? const CircleAvatar(
                      radius: 13,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
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
            mainAxisSize: showLogoOnly ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Image.asset('assets/images/x_logo.png', width: 24, height: 24),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
