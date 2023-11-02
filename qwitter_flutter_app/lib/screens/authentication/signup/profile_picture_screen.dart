import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key, this.email = 'omarmahmoud@gmail.com'});

  final String email;

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _selectedImage;
  Widget content = Container(
    height: 200,
    width: 180,
    color: Colors.transparent,
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo_rounded,
          size: 70,
          color: Colors.blue,
        ),
        SizedBox(height: 15),
        Text(
          'Upload',
          style: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w600),
        )
      ],
    ),
  );

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedImage != null) {
      content = Image.file(
        _selectedImage!,
        height: 200,
        width: 180,
        fit: BoxFit.cover,
      );
    }
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Pick a profile picture',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 222, 222, 222),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Have a favorite selfie? Upload it now.',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 132, 132, 132),
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DottedBorder(
                  dashPattern: const [8],
                  borderType: BorderType.RRect,
                  color: Colors.blue,
                  radius: const Radius.circular(12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _pickImage(ImageSource.gallery); // Open the gallery
                      },
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: content,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
      bottomNavigationBar: const QwitterNextBar(
        buttonFunction: null,
      ),
    );
  }
}
