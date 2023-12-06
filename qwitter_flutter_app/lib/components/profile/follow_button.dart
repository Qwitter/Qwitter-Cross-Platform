
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget{
  const FollowButton({super.key,required this.isFollowed});
  final bool isFollowed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 117,
      height: 35,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          elevation:const MaterialStatePropertyAll(0),
          backgroundColor:  MaterialStatePropertyAll(isFollowed? Colors.white:Colors.black,),
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
         isFollowed? 'Following':"Follow",
          style: TextStyle(
              color:isFollowed? Colors.black:Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

}