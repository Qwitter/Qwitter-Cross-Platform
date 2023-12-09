import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/underlined_text_field_label_only.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late DateTime _birthDate;
  late AppUser appUser;
  late TextEditingController _birthDateFieldController;
  late TextEditingController _nameFieldController;
  late TextEditingController _bioFieldController;
  late TextEditingController _locationFieldController;
  late TextEditingController _websiteFieldController;
  late ImageProvider _profilePicture;
  late ImageProvider _profileBanner;
  File? _profilePictureFile;
  File? _profilebannerFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    appUser = AppUser();
    _birthDateFieldController = TextEditingController(
        text: formatDate(DateTime.parse(appUser.birthDate!)));
    _nameFieldController = TextEditingController(text: appUser.fullName);
    _bioFieldController = TextEditingController(text: appUser.description);
    _websiteFieldController = TextEditingController(text: appUser.url);
    _locationFieldController = TextEditingController(text: appUser.location);
    _profileBanner = (appUser.profileBannerUrl!.path.isEmpty
        ? const AssetImage("assets/images/def_banner.png")
        : NetworkImage(appUser.profileBannerUrl!.path.startsWith("http")
            ? appUser.profileBannerUrl!.path
            : "http://" + appUser.profileBannerUrl!.path) as ImageProvider);

    _profilePicture = (appUser.profilePicture!.path.isEmpty
        ? const AssetImage("assets/images/def.jpg")
        : NetworkImage(appUser.profilePicture!.path.startsWith("http")
            ? appUser.profilePicture!.path
            : "http://" + appUser.profilePicture!.path) as ImageProvider);
    _birthDate = DateTime.parse(appUser.birthDate!);
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  Future<void> _pickImage(bool profilePicture) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        File imageFile = File(pickedFile.path);
        appUser.setProfilePicture(imageFile);
        setState(() {
          if (profilePicture) {
            _profilePicture = FileImage(imageFile);
            _profilePictureFile = imageFile;
          } else {
            _profileBanner = FileImage(imageFile);
            _profilebannerFile = imageFile;
          }
        });
      } catch (e) {
        print("something went wrong");
      }
    }
  }

  void _exit(BuildContext context) {
    if (_profilePictureFile != null ||
        _profilebannerFile != null ||
        DateTime.parse(appUser.birthDate!) != _birthDate ||
        _nameFieldController.text != appUser.fullName ||
        _bioFieldController.text != appUser.description ||
        _locationFieldController.text != appUser.location ||
        _websiteFieldController != appUser.url) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Do you want to discard the changes?"),
                // content: Text("Do you want to discard the changes?",style: TextStyle(fontSize: 17),),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text("Discard"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ]);
          });
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _save(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_profilePictureFile != null) {
        uploadProfilePicture(_profilePictureFile!);
        appUser.setProfilePicture(_profilePictureFile);
      }
      if (_profilebannerFile != null) {
        uploadProfilebanner(_profilebannerFile!);
        appUser.setProfileBanner(_profilebannerFile);
      }
      _updateUserProfile(
          _nameFieldController.text,
          _bioFieldController.text,
          _locationFieldController.text,
          _websiteFieldController.text,
          _birthDate);
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ProfileDetailsScreen(
          username: appUser.username!,
        );
      }));
    } else {
      print("invalid");
    }
  }

  Future<void> _updateUserProfile(String name, String description,
      String location, String website, DateTime birthData) async {
    String _baseUrl = 'http://qwitterback.cloudns.org:3000';
    Uri url = Uri.parse('$_baseUrl/api/v1/user/profile');

    try {
      final body = {
        'name': name,
        'description': description,
        'location': location,
        'url': website,
        'birth_date': birthData.toUtc().toIso8601String()
      };
      print(body);
      print(jsonEncode(body));
      http.Response response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'authorization': 'Bearer ${appUser.token}',
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        appUser
            .setBirthDate(birthData.toString())
            .setFullName(name)
            .setLocation(location)
            .setURL(website)
            .setDescription(description);
        appUser.saveUserData();
        print("saved successfully");
      } else {
        print(
            "error occured while saving the data status code ${response.statusCode}");
      }
    } catch (e) {
      print("an exception occured ${e.toString()}");
    }
  }

  Future<bool> uploadProfilePicture(File imageFile) async {
    final url = Uri.parse(
        'http://qwitterback.cloudns.org:3000/api/v1/user/profile_picture');

    // Create a MultipartRequest
    final request = http.MultipartRequest('POST', url);
    //print('Token : ${widget.user!.getToken}');
    Map<String, String> headers = {
      "authorization": 'Bearer ${appUser.getToken}',
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
      appUser.setProfilePicture(File(responseBody['user']['profileImageUrl']));
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

  Future<bool> uploadProfilebanner(File imageFile) async {
    final url = Uri.parse(
        'http://qwitterback.cloudns.org:3000/api/v1/user/profile_banner');

    // Create a MultipartRequest
    final request = http.MultipartRequest('POST', url);
    //print('Token : ${widget.user!.getToken}');
    Map<String, String> headers = {
      "authorization": 'Bearer ${appUser.getToken}',
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
      appUser.setProfilePicture(File(responseBody['user']['profileImageUrl']));
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

  void changeBirthDate(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 300,
            width: double.infinity,
            color: Colors.black,
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ))),
              child: CupertinoDatePicker(
                onDateTimeChanged: (value) {
                  _birthDate = value;
                  print(_birthDate.toUtc().toIso8601String());

                  setState(() {
                    _birthDateFieldController.text = formatDate(_birthDate);
                  });
                },
                initialDateTime: DateTime.now(),
                maximumDate: DateTime.now(),
                minimumDate: DateTime(1930),
                mode: CupertinoDatePickerMode.date,
                showDayOfWeek: false,
                dateOrder: DatePickerDateOrder.mdy,
                itemExtent: 50,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: null,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            _exit(context);
          },
        ),
        title: const Text(
          "Edit profile",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _save(context);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ))
        ],
        bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 1),
            child: Divider(
              color: Colors.grey.shade600,
              thickness: 0.1,
              height: 6,
            )),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickImage(false);
                    },
                    child: Container(
                      height: 140,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: _profileBanner,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // child: const Icon(
                      //   Icons.camera_alt_outlined,
                      //   size: 60,
                      //   color: Colors.white,
                      // ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    child: GestureDetector(
                      onTap: () {
                        _pickImage(true);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 41,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: _profilePicture,
                            // child: Icon(
                            //   Icons.camera_alt_outlined,
                            //   size: 45,
                            //   color: Colors.black,
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: Column(
                children: [
                  UnderlineTextFieldLabelOnly(
                    keyboardType: TextInputType.text,
                    placeholder: 'Name',
                    maxLines: 1,
                    controller: _nameFieldController,
                    validator: (val) {
                      if (val == null || val == "") {
                        return "this field can't be empty";
                      } else {
                        return null;
                      }
                    },
                    intialValue: null,
                    readOnly: false,
                    onTap: null,
                  ),
                  UnderlineTextFieldLabelOnly(
                    keyboardType: TextInputType.text,
                    placeholder: 'Bio',
                    maxLines: 3,
                    controller: _bioFieldController,
                    validator: (val) {
                      return null;
                    },
                    intialValue: null,
                    readOnly: false,
                    onTap: null,
                  ),
                  UnderlineTextFieldLabelOnly(
                    keyboardType: TextInputType.text,
                    placeholder: 'Website',
                    maxLines: 1,
                    controller: _websiteFieldController,
                    validator: (val) {
                      if (val!.isEmpty ||
                          (val.isEmpty == false &&
                              (val.startsWith("http://") ||
                                  val.startsWith("https://")))) return null;
                      return "the url must starts with http or https";
                    },
                    intialValue: null,
                    readOnly: false,
                    onTap: null,
                  ),
                  UnderlineTextFieldLabelOnly(
                    keyboardType: TextInputType.text,
                    placeholder: 'Location',
                    maxLines: 1,
                    controller: _locationFieldController,
                    validator: (val) {
                      return null;
                    },
                    intialValue: null,
                    readOnly: false,
                    onTap: () {},
                  ),
                  UnderlineTextFieldLabelOnly(
                    keyboardType: TextInputType.text,
                    placeholder: 'Birth date',
                    maxLines: 1,
                    controller: _birthDateFieldController,
                    validator: (val) {
                      return null;
                    },
                    intialValue: null,
                    readOnly: true,
                    onTap: () {
                      changeBirthDate(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
