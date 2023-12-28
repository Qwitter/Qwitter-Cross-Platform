import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_bottom_navigation.dart';
import 'package:qwitter_flutter_app/components/notifications/notification_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/notification.dart';
import 'package:qwitter_flutter_app/providers/notifications_provider.dart';
import 'package:qwitter_flutter_app/services/notifications_services.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';
import 'package:qwitter_flutter_app/utils/enums.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  IO.Socket socket =
      IO.io('http://back.qwitter.cloudns.org:3000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  @override
  void initState() {
    AppUser user = AppUser();
    user.getUserData();
    super.initState();
  }

  Future<void> displayNotification(QwitterNotification notification) async {
    AppUser user = AppUser();
    user.getUserData();
    String text = notification.type == NotificationType.follow_type
        ? "New Follow"
        : notification.type == NotificationType.login_type
            ? "Recent Login"
            : notification.type == NotificationType.like_type
                ? "Got New Likes"
                : notification.type == NotificationType.retweet_type
                    ? "New Retweet"
                    : " ";
    String desc = notification.type == NotificationType.follow_type
        ? "${notification.user!.fullName!} followed you"
        : notification.type == NotificationType.login_type
            ? "There was a recent login to your account @${user.username ?? ''}"
            : notification.type == NotificationType.like_type
                ? "${notification.user!.fullName!} liked your tweet"
                : notification.type == NotificationType.retweet_type
                    ? "${notification.user!.fullName!} reposted your post"
                    : " ";
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'qwitter_channel', // Replace with your own channel ID
      'Qwitter', // Replace with your own channel name
      channelDescription:
          'Qwitter App Notification', // Replace with your own channel description
      importance: Importance.max,
      priority: Priority.high,
      icon: 'qwitter',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      text,
      desc,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  Future<void> _onRefresh() async {
    AppUser user = AppUser();
    user.getUserData();
    setState(() {
      NotificationsServices.getNotifications().then((notifications) {
        ref.read(notificationsProvider.notifier)
            .resetNotifications(notifications);
      });
    });
    // socket.disconnect();
    // socket.connect();
    socket.connect();
    socket.emit('JOIN_ROOM', user.username);
    print("refreshed");
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
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
            RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationCard(
                    type: notifications[index].type!,
                    notification: notifications[index],
                  );
                },
              ),
            ),
            ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(
                  type: notifications[index].type!,
                  notification: notifications[index],
                );
              },
            ),
            ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(
                  type: notifications[index].type!,
                  notification: notifications[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
