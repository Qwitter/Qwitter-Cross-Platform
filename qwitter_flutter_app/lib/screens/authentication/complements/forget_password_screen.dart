import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button_outlined.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}


class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool _checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 27,
          ),
          onPressed: () { Navigator.of(context).pop();},
        ),
        title: Container(
          alignment: AlignmentDirectional.center,
          child: Image.network(
            'https://freelogopng.com/images/all_img/1690643777twitter-x%20logo-png-white.png',
            height: 24,
            width: 24,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.close, color: Colors.transparent, size: 27)),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 20, left: 40, right: 10, bottom: 10),
            padding: const EdgeInsets.all(0),
            child: const Text(
              'Where should we send a confirmation code?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 0, left: 40, right: 10, bottom: 0),
            padding: const EdgeInsets.all(0),
            child: Text(
              'Before you can change your password, we need to make sure it\'s really you.',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 0, left: 40, right: 10, bottom: 0),
            padding: const EdgeInsets.all(0),
            child: Text(
              'Start by choosing where to send a confirmation code.',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Theme(
            data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                unselectedWidgetColor: Colors.white),
            child: Container(
              margin: const EdgeInsets.only(
                  top: 0, left: 40, right: 10, bottom: 10),
              padding: const EdgeInsets.all(0),
              child: CheckboxListTile(
                onChanged: (value) {
                  setState(() {
                    _checkBoxValue = value!;
                  });
                },
                title: const Text(
                  'Text a code to the phone number ending in 78',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                checkColor: Colors.white,
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    width: 5,
                    color: Colors.blue,
                    style: BorderStyle.solid,
                  ),
                ),
                activeColor: Colors.blue,
                contentPadding: const EdgeInsets.only(right: 10),
                enabled: true,
                value: _checkBoxValue,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Contact ",
                    style: TextStyle(color: Colors.grey.shade600)),
                TextSpan(
                  text: 'X support ',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => print('taped'),
                    style: const TextStyle(color: Colors.blue),
                ),
                TextSpan(text: 'if you don\'t have access.',style: TextStyle(color: Colors.grey.shade600))
              ]),
            ),
          ),
          Divider(
            indent: 0,
            endIndent: 0,
            color: Colors.grey.shade800,
            thickness: 0.5,
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 10, bottom: 30, right: 30, left: 30),
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SecondaryButtonOutlined(text: 'Cancel', on_pressed: (){},),
                SecondaryButton(text: 'Next', on_pressed: (){},)
              ],
            ),
          ),
        ],
      ),
     
    );
  }
}
