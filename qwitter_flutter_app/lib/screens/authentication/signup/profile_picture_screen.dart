import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/add_username_screen.dart';

class ProfilePictureScreen extends ConsumerStatefulWidget {
  const ProfilePictureScreen({super.key, required this.user});

  final User? user;

  @override
  ConsumerState<ProfilePictureScreen> createState() =>
      _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends ConsumerState<ProfilePictureScreen> {
  File? _selectedImage;
  void Function(BuildContext)? buttonFunction;

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

    if (pickedFile == null) {
      buttonFunction = null;
      ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      return;
    }
    buttonFunction = (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddUsernameScreen(
            user: widget.user,
          ),
        ),
      );
    };
    widget.user!.setProfilePicture(File(pickedFile.path));
    ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nextBarProvider.notifier).setNextBarFunction(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    buttonFunction = ref.watch(nextBarProvider);

    if (_selectedImage != null) {
      content = Image.file(
        _selectedImage!,
        height: 200,
        width: 180,
        fit: BoxFit.cover,
      );
    }

    return WillPopScope(
      onWillPop: () {
        buttonFunction = (context) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfilePictureScreen(
                user: widget.user,
              ),
            ),
          );
        };
        ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: QwitterAppBar(
            showLogoOnly: true,
          ),
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
        bottomNavigationBar: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
          buttonFunction = ref.watch(nextBarProvider);
          return QwitterNextBar(
            buttonFunction: () {
              buttonFunction!(context);
            },
            useProvider: true,
          );
        }),
      ),
    );
  }
}
