import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';

class QwitterAppBar extends StatelessWidget {
  final bool isButton;
  final VoidCallback? onPressed;
  final IconData currentIcon;
  final bool showLogo;
  final bool showLogoOnly;
  final bool autoImplyLeading;
  final TabBar? bottomWidget;
  final bool includeActions;
  final Widget actionButton;
  const QwitterAppBar({
    super.key,
    this.bottomWidget,
    this.isButton = false,
    this.onPressed,
    this.currentIcon = Icons.close,
    this.showLogoOnly = false,
    this.autoImplyLeading = true,
    this.showLogo = true,
    this.includeActions = false,
    this.actionButton = const SizedBox(width: 1),
  });

  @override
  Widget build(BuildContext context) {
    AppUser user = AppUser();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: AppBar(
        toolbarHeight: 75,
        automaticallyImplyLeading: autoImplyLeading,
        centerTitle: showLogoOnly ? true : false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: includeActions ? actionButton : const SizedBox(width: 1),
          )
        ],
        title: Stack(
          children: [
            showLogoOnly
                ? const SizedBox(
                    width: 1,
                  )
                : !isButton
                    ? CircleAvatar(
                        radius: 13,
                        backgroundImage: (user.profilePicture!.path.isEmpty
                            ? const AssetImage("assets/images/def.jpg")
                            : NetworkImage(
                                    user.profilePicture!.path.startsWith("http")
                                        ? user.profilePicture!.path
                                        : "http://" + user.profilePicture!.path)
                                as ImageProvider),
                      )
                    : IconButton(
                        onPressed: onPressed,
                        icon: Icon(
                          currentIcon,
                          color: Colors.white,
                        ),
                      ),
            showLogo
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize:
                        showLogoOnly ? MainAxisSize.min : MainAxisSize.max,
                    children: [
                      Image.asset('assets/images/x_logo.png',
                          width: 24, height: 24),
                    ],
                  )
                : const SizedBox(width: 1),
          ],
        ),
        backgroundColor: Colors.black,
        bottom: bottomWidget,
      ),
    );
  }
}
