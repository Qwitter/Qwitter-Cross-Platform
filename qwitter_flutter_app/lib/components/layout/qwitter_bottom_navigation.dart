import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/notification.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversations_screen.dart';
import 'package:qwitter_flutter_app/screens/notifications/notifications_screen.dart';
import 'package:qwitter_flutter_app/screens/searching/search_screen.dart';
import 'package:qwitter_flutter_app/utils/enums.dart';
import 'package:qwitter_flutter_app/screens/trends/trends_screen.dart';
// import 'package:qwitter_flutter_app/screens/notifications/notifications_screen.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweets_feed_screen.dart';
import 'package:qwitter_flutter_app/services/socket_manager.dart';

class QwitterBottomNavigationBar extends StatefulWidget {
  QwitterBottomNavigationBar({
    super.key,
    this.currentIndex = 0,
  });
  int currentIndex = 0;

  @override
  State<QwitterBottomNavigationBar> createState() =>
      _QwitterBottomNavigationBarState();
}

class _QwitterBottomNavigationBarState
    extends State<QwitterBottomNavigationBar> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final socketManager = SocketManager();
  int currentPageIndex = 0;

  @override
  void initState() {
    AppUser user = AppUser();
    user.getUserData();
    super.initState();
    if (!socketManager.isConnected) {
      socketManager.initializeSocket();
    }
    // socketManager.initializeSocket();
  }

  @override
  void dispose() {
    socketManager.disposeSocket();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        backgroundColor: Colors.black,
        indicatorColor: Colors.transparent,
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(1)),
        ),
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: currentPageIndex == 0
                ? const Icon(BootstrapIcons.house_fill, color: Colors.white)
                : const Icon(BootstrapIcons.house),
            label: '',
          ),
          NavigationDestination(
            icon: currentPageIndex == 1
                ? const Icon(BootstrapIcons.search, color: Colors.white)
                : const Icon(BootstrapIcons.search),
            label: '',
          ),
          NavigationDestination(
            icon: currentPageIndex == 2
                ? const Icon(BootstrapIcons.bell_fill, color: Colors.white)
                : const Icon(BootstrapIcons.bell),
            label: '',
          ),
          NavigationDestination(
            icon: currentPageIndex == 3
                ? const Icon(BootstrapIcons.envelope_fill, color: Colors.white)
                : const Icon(BootstrapIcons.envelope),
            label: '',
          ),
        ],
      ),
      body: [
        const TweetFeedScreen(),
        TrendsScreen(),
        const NotificationsScreen(),
        const ConversationScreen(),
      ][currentPageIndex],
    );
  }
}
