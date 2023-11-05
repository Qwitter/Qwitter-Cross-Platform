import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/underlined_text_field_label_only.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late DateTime _birthDate;
  late TextEditingController _birthDateFieldController;

  @override
  void initState() {
    super.initState();
    _birthDate = DateTime.now();
    _birthDateFieldController =
        TextEditingController(text: formatDate(_birthDate));
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  void changeBirthDate() {
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
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ))),
              child: CupertinoDatePicker(
                onDateTimeChanged: (value) {
                  _birthDate = value;
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
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            // Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Edit profile",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.black, fontSize: 20),
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () {
                    print(1);
                  },
                  child: Container(
                    height: 140,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                          image: NetworkImage(
                            'https://th.bing.com/th/id/R.954112b1d86c17e04f32710a9dfa624b?rik=%2bujOnc84tNbuEQ&riu=http%3a%2f%2f3.bp.blogspot.com%2f-OuRPhqkSc60%2fU2dbPYEHx1I%2fAAAAAAAAFq8%2fvOU3zTMXzH8%2fs1600%2f1500x500-Nature-Twitter-Header28.jpg&ehk=EwDVaeRMKrCyrHOksN8rJ5QGW8qzTtgbTZ9OqW9sSRM%3d&risl=&pid=ImgRaw&r=0',
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Color.fromARGB(172, 0, 0, 0),
                              BlendMode.multiply)),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  child: GestureDetector(
                    onTap: () {
                      print(2);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 41,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                            'https://hips.hearstapps.com/digitalspyuk.cdnds.net/17/13/1490989105-twitter1.jpg?resize=480:*',
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 45,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  UnderlineTextFieldLabelOnly(
                    keyboardType: TextInputType.text,
                    placeholder: 'Name',
                    maxLines: 1,
                    controller: null,
                    validator: (val) {
                      if(val==null || val=="") {
                        return "this field can't be empty";
                      } else {
                        return null;
                      }
                    },
                    intialValue: 'Amr Magdy',
                    readOnly: false,
                    onTap: null,
                  ),
                  UnderlineTextFieldLabelOnly(
                    keyboardType: TextInputType.text,
                    placeholder: 'Bio',
                    maxLines: 3,
                    controller: TextEditingController(),
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
                    controller: TextEditingController(),
                    validator: (val) {
                      return null;
                    },
                    intialValue: null,
                    readOnly: false,
                    onTap: null,
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
                    onTap: changeBirthDate,
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
