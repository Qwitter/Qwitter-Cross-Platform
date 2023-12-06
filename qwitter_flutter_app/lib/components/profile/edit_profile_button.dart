import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/profile/edit_profile_screen.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  void _openEditProfileScreen(BuildContext context){
    Navigator.of(context).pop();
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditProfileScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 117,
      height: 35,
      child: ElevatedButton(
        onPressed: () {
          _openEditProfileScreen(context);
          
        },
        style: ButtonStyle(
          elevation: const MaterialStatePropertyAll(0),
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
