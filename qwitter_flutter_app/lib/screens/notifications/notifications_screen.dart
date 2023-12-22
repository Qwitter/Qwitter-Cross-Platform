import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_bottom_navigation.dart';
import 'package:qwitter_flutter_app/components/notifications/notification_card.dart';
import 'package:qwitter_flutter_app/utils/enums.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: QwitterAppBar(
            autoImplyLeading: false,
            scaffoldKey: _scaffoldKey,
            bottomWidget: const TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "All",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Verified",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Mentions",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Column(children: [
              NotificationCard(type: NotificationType.like_type),
              NotificationCard(type: NotificationType.follow_type),
              NotificationCard(type: NotificationType.retweet_type),
            ],),
            NotificationCard(type: NotificationType.like_type),
            NotificationCard(type: NotificationType.like_type),
          ],
        ),
        bottomNavigationBar: QwitterBottomNavigationBar(),

      ),
    );
  }
}
