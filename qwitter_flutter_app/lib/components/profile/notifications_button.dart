import 'package:flutter/material.dart';

class NotificationsButton extends StatefulWidget {
  const NotificationsButton({super.key, required this.isNotificationsEnabled});
  final isNotificationsEnabled;

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
                ? Icons.notifications_active
                : Icons.notification_add_outlined,
            color: Colors.black,
            size: 25,
          ),
          onPressed: () {},
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.zero),
            shape: MaterialStatePropertyAll(
              CircleBorder(
                eccentricity: 0,
                side: BorderSide(
                  color: Colors.grey.shade600,
                  style: BorderStyle.solid,
                  width: 1

                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
