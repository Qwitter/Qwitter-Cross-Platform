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
