import 'package:flutter/material.dart';

class SideDropDownMenu extends StatelessWidget {
  const SideDropDownMenu(
      {super.key, required this.isBlocked, required this.toggleBlockState});
  final bool isBlocked;
  final Function toggleBlockState;
  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w400,
    );

    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(5.0, 5.0),
              blurRadius: 10.0,
              spreadRadius: 3.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  toggleBlockState();
                },
                child: Text(
                  isBlocked ? "unblock" : "Block",
                  style: style,
                )),
          ],
        ),
      ),
    );
  }
}
