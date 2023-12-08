import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideDropDownMenu extends StatelessWidget {
  const SideDropDownMenu({
    super.key,
  });

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
              onPressed: () {},
              child: Text(
                'Share',
                style: style,
              ),
            ),
            TextButton(onPressed: () {}, child: Text('Add/remove from Lists',style: style,)),
            TextButton(onPressed: () {}, child: Text('View Lists',style: style,)),
            TextButton(onPressed: () {}, child: Text('Lists they\'re on',style: style,)),
            TextButton(onPressed: () {}, child: Text('Mute',style: style,)),
            TextButton(onPressed: () {}, child: Text('Block',style: style,)),
            TextButton(onPressed: () {}, child: Text('Report',style: style,)),
          ],
        ),
      ),
    );
  }
}
