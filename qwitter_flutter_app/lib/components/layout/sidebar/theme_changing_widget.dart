import 'package:flutter/material.dart';

class ThemeChangingWidget extends StatefulWidget {
  const ThemeChangingWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ThemeChangingWidget();
  }
}

class _ThemeChangingWidget extends State<ThemeChangingWidget> {
  String darkMode = 'off';
  String darkTheme = 'lights out';

  void _onChangeDarkMode(String value) {
    setState(() {
      darkMode = value;
    });
  }
  void _onChangeDarkTheme(String value){
    setState(() {
      darkTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, top: 40),
            child: const Text(
              'Dark mode',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
          ),
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black),
            child: RadioListTile(
              contentPadding: const EdgeInsets.only(left: 30,right: 30),
              title: const Text(
                'Off',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
              value: 'off',
              groupValue: darkMode,
              onChanged: (value) {
                _onChangeDarkMode(value!);
              },
              activeColor: Colors.black,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          ),
          Theme(
            data:ThemeData(unselectedWidgetColor: Colors.black),
            child: RadioListTile(
              contentPadding: const EdgeInsets.only(left: 30,right: 30),

              title: const Text(
                'On',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
              value: 'on',
              groupValue: darkMode,
              onChanged: (value) {
                _onChangeDarkMode(value!);
              },
              activeColor: Colors.black,
              controlAffinity: ListTileControlAffinity.trailing,
          
            ),
          ),
          Theme(
            data:ThemeData(unselectedWidgetColor: Colors.black),
            child: RadioListTile(
              contentPadding: const EdgeInsets.only(left: 30,right: 30),

              title: const Text(
                'Use device settings',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
              value: 'use device settings',
              groupValue: darkMode,
              onChanged: (value) {
                _onChangeDarkMode(value!);
              },
              activeColor: Colors.black,
              controlAffinity: ListTileControlAffinity.trailing,
          
            ),
          ),
          Divider(
            color: Colors.grey.shade300,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              bottom: 10,
            ),
            child: const Text(
              'Dark theme',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Theme(
            data:ThemeData(unselectedWidgetColor: Colors.black),
            child: RadioListTile(
              contentPadding: const EdgeInsets.only(left: 30,right: 30),

              title: const Text(
                'Lights out',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
              value: 'lights out',
              groupValue: darkTheme,
              onChanged: (value) {
                _onChangeDarkTheme(value!);
              },
              activeColor: Colors.black,
              controlAffinity: ListTileControlAffinity.trailing,
          
            ),
          ),
          Theme(
            data:ThemeData(unselectedWidgetColor: Colors.black),
            child: RadioListTile(
              contentPadding: const EdgeInsets.only(left: 30,right: 30),

              title: const Text(
                'Dim',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
              value: 'dim',
              groupValue: darkTheme,
              onChanged: (value) {
                _onChangeDarkTheme(value!);
              },
              activeColor: Colors.black,
              controlAffinity: ListTileControlAffinity.trailing,
          
            ),
          ),
        ],
      ),
    );
  }
}
