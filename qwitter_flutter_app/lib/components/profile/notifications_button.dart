import 'package:flutter/material.dart';

class NotificationsButton extends StatefulWidget {
  const NotificationsButton(
      {super.key,
      required this.isNotificationsEnabled,
      required this.toggleMuteState});
  final isNotificationsEnabled;
  final Function toggleMuteState;

  @override
  State<NotificationsButton> createState() => _NotificationsButtonState();
}

class _NotificationsButtonState extends State<NotificationsButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 35,
        child: IconButton(
          icon: Icon(
            widget.isNotificationsEnabled
                ? Icons.notification_add_outlined
                : Icons.notifications_active,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            widget.toggleMuteState();
          },
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.zero),
            shape: MaterialStatePropertyAll(
              CircleBorder(
                eccentricity: 0,
                side: BorderSide(
                    color: Colors.grey.shade600,
                    style: BorderStyle.solid,
                    width: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
