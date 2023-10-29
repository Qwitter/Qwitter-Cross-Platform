import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class QwitterBottomNavigationBar extends StatefulWidget {
  const QwitterBottomNavigationBar({super.key});

  @override
  State<QwitterBottomNavigationBar> createState() =>
      _QwitterBottomNavigationBarState();
}

class _QwitterBottomNavigationBarState
    extends State<QwitterBottomNavigationBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey, // Border color
            width: 0.05, // Border width
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(size: 23),
        unselectedIconTheme: const IconThemeData(size: 22),
        selectedFontSize: 0,
        iconSize: 32,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _currentIndex == 0
                ? const Icon(BootstrapIcons.house_fill)
                : const Icon(BootstrapIcons.house),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? const Icon(BootstrapIcons.search)
                : const Icon(BootstrapIcons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 2
                ? const Icon(BootstrapIcons.people_fill)
                : const Icon(BootstrapIcons.people),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 3
                ? const Icon(BootstrapIcons.bell_fill)
                : const Icon(BootstrapIcons.bell),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 4
                ? const Icon(BootstrapIcons.envelope_fill)
                : const Icon(BootstrapIcons.envelope),
            label: '',
          ),
        ],
      ),
    );
  }
}
