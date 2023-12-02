import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/primary_button.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/screens/tweets/add_tweet_action_bar.dart';

class AddTweetScreen extends StatefulWidget {
  const AddTweetScreen({super.key});

  @override
  State<AddTweetScreen> createState() => _AddTweetScreenState();
}

class _AddTweetScreenState extends State<AddTweetScreen> {
  TextEditingController _tweetController = TextEditingController();
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    print('Picture : ${AppUser().profilePicture!.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: QwitterAppBar(
            showLogo: false,
            autoImplyLeading: false,
            isButton: true,
            includeActions: true,
            onPressed: () => Navigator.pop(context),
            actionButton: PrimaryButton(
              text: 'Post',
              onPressed: () {},
              paddingValue:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              buttonSize: const Size(100, 10),
            )),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: CircleAvatar(
                radius: 22,
                backgroundImage:
                    NetworkImage(AppUser().profilePicture!.path ?? ''),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    // Calculate progress based on text length
                    _progress =
                        1.0 - (text.length / 10.0); // Assuming max length is 10
                  });
                },
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  hintText: 'What\'s happening?',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 132, 132, 132),
                  ),
                  counterText: '',
                  border: InputBorder.none,
                ),
                maxLines: null,
                maxLength: 280,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AddTweetActionBar(),
    );
  }
}
