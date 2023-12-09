
import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget{
  const FollowButton({super.key,required this.isFollowed,required this.onTap});
  final bool isFollowed;
  final Future<void> Function() onTap;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 117,
      height: 35,
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ButtonStyle(
          elevation:const MaterialStatePropertyAll(0),
          backgroundColor:  MaterialStatePropertyAll( Colors.white),
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(
                color: Colors.grey.shade500,
              ),
            ),
          ),
          padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        ),
        child:  Text(
         widget.isFollowed? 'Following':"Follow",
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}