import 'package:flutter/material.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 117,
      height: 35,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          elevation:const MaterialStatePropertyAll(0),
          backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          foregroundColor: const MaterialStatePropertyAll(Colors.black),
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
        child: const Text(
          'Edit profile',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
