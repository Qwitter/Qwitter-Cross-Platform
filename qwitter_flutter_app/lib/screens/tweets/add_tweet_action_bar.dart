import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/screens/tweets/add_tweet_circular_indicator.dart';

class AddTweetActionBar extends StatefulWidget {
  const AddTweetActionBar({super.key});

  @override
  State<AddTweetActionBar> createState() => _AddTweetActionBarState();
}

class _AddTweetActionBarState extends State<AddTweetActionBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Define your actions for each icon here
    // For example, you can navigate to a different page
    // or update the content of the current page.
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.blue,
      selectedIconTheme: const IconThemeData(size: 23),
      unselectedIconTheme: const IconThemeData(size: 22),
      selectedFontSize: 0,
      iconSize: 32,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.image),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.filetype_gif),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.bar_chart_line),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.geo_alt),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 22,
            width: 20,
            child: AddTweetCircularIndicator(
              progress: 0.9,
            ),
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
