import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/add_username_screen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

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

  Future<bool> uploadProfilePicture(File imageFile) async {
    final url = Uri.parse(
        'http://qwitterback.cloudns.org:3000/api/v1/user/profile_picture');

    // Create a MultipartRequest
    final request = http.MultipartRequest('POST', url);
    //print('Token : ${widget.user!.getToken}');

    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${widget.user!.getToken}',
    };

    Map<String, String> headers = {
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
      "Content-Type": "multipart/form-data"
    };

    request.headers.addAll(headers);

    // Get the filename
    final fileName = basename(imageFile.path);

    // Add the image file
    final stream = http.ByteStream(imageFile.openRead());
    final length = await imageFile.length();
    final imgType = lookupMimeType(imageFile.path);
    final contentType = imgType!.split('/');
    final multipartFile = http.MultipartFile(
      'photo',
      stream,
      length,
      filename: fileName,
      contentType: MediaType(contentType[0], contentType[1]),
    );

    // Add the image file to the request
    request.files.add(multipartFile);

    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      // Successfully sent the data
      final responseFromStream = await http.Response.fromStream(
          response); // json.decode(response.stream.toString());
      final responseBody = jsonDecode(responseFromStream.body);
      //print(responseBody);
      AppUser appUser = AppUser();
      widget.user!
          .setProfilePicture(File(responseBody['user']['profileImageUrl']));
      appUser.setProfilePicture(File(responseBody['user']['profileImageUrl']));
      appUser.saveUserData();
      return true;
    } else {
      // Handle errors
      //print(response.statusCode);
      //print(response.reasonPhrase);
      return false;
    }
  }

  Future<void> _pickImage(ImageSource source, selectedImage) async {
    var pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null && selectedImage == null) {
      buttonFunction = null;
      ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
      return;
    }
    pickedFile = pickedFile ?? selectedImage;
    File imageFile = File(pickedFile!.path);

    buttonFunction = (context) {
      //print("Image");
      uploadProfilePicture(imageFile).then((value) {
        //print(value);
        if (value) {
          Toast.show('Image Added Successfully!');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUsernameScreen(
                user: widget.user,
              ),
            ),
          );
        }
      }).onError((error, stackTrace) {
        // Toast.show('Error sending data $error');
        //print('Error sending data $error');
        //print(stackTrace);
      });
    };
    widget.user!.setProfilePicture(imageFile);

    ref.read(nextBarProvider.notifier).setNextBarFunction(buttonFunction);
    setState(() {
      _selectedImage = File(pickedFile!.path);
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
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return true;
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: QwitterAppBar(
            showLogoOnly: true,
            autoImplyLeading: false,
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
                          _pickImage(ImageSource.gallery,
                              _selectedImage); // Open the gallery
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
            buttonFunction: buttonFunction == null
                ? null
                : () {
                    buttonFunction!(context);
                  },
            useProvider: true,
            secondaryButtonText: 'Skip for now',
            secondaryButtonFunction: () {
              widget.user!.profilePicture = null;
              //print'Username : ${widget.user!.username}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUsernameScreen(
                    user: widget.user,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
