import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/primary_button.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/providers/timeline_tweets_provider.dart';
import 'package:qwitter_flutter_app/providers/tweet_images_provider.dart';
import 'package:qwitter_flutter_app/providers/tweet_progress_provider.dart';
import 'package:qwitter_flutter_app/screens/tweets/add_tweet_action_bar.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class AddTweetScreen extends ConsumerStatefulWidget {
  const AddTweetScreen({super.key, this.replyToTweetId, this.tweetText});

  final String? replyToTweetId;
  final String? tweetText;

  @override
  ConsumerState<AddTweetScreen> createState() => _AddTweetScreenState();
}

class _AddTweetScreenState extends ConsumerState<AddTweetScreen> {
  final TextEditingController _tweetController = TextEditingController();

  Future<bool> addTweet(List<File>? imageFiles) async {
    final url = Uri.parse('http://back.qwitter.cloudns.org:3000/api/v1/tweets');

    final request = http.MultipartRequest('POST', url);
    final Map<String, String> cookies = {
      'qwitter_jwt': 'Bearer ${AppUser().getToken}',
    };
    Map<String, String> headers = {
      'Cookie': cookies.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('; '),
      "Content-Type": "multipart/form-data"
    };

    print("Request headers: $headers");

    print("authorization: ${AppUser().getToken}");

    request.headers.addAll(headers);
    Map<String, String> fields = {
      "text": _tweetController.text.toString(),
      "source": Platform.isAndroid ? "Android" : "iOS",
      "coordinates": "0,0",
      "replyToTweetId": widget.replyToTweetId ?? "",
      "sensitive": "false",
    };

    request.fields.addAll(fields);
    print("Request fields: ${request.fields}");
    // Add all image files to the 'media' field
    if (imageFiles != null) {
      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        final fileName = basename(imageFile.path);

        final stream = http.ByteStream(imageFile.openRead());
        final length = await imageFile.length();
        final imgType = lookupMimeType(imageFile.path);
        final contentType = imgType!.split('/');

        final multipartFile = http.MultipartFile(
          'media[]', // Use the same field name for all files
          stream,
          length,
          filename: fileName,
          contentType: MediaType(contentType[0], contentType[1]),
        );

        request.files.add(multipartFile);
      }
    }

    try {
      // Send the request
      final response = await request.send();
      print(
          "Sent in tweet : ${request.fields['text']} ${imageFiles?.length} images , first image: ${imageFiles?[0].path}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseFromStream = await http.Response.fromStream(response);
        final responseBody = jsonDecode(responseFromStream.body);
        ref.read(timelineTweetsProvider.notifier).setTimelineTweets([Tweet.fromJson(responseBody['tweet'])]);
        print("Successfully uploaded tweet: $responseBody");
        return true;
      } else {
        final responseFromStream = await http.Response.fromStream(response);
        final responseBody = jsonDecode(responseFromStream.body);
        print("Error uploading tweet: $responseBody");
        print(response.statusCode);
        return false;
      }
    } catch (e, stackTrace) {
      print("Error uploading profile pictures: $e");
      print(stackTrace);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _tweetController.text = widget.tweetText ?? "";
    print("Tweet text: ${widget.tweetText}");
    print("replyToTweetId: ${widget.replyToTweetId}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tweetProgressProvider.notifier).setTweetProgress(1);
    });

    print('Picture : ${AppUser().profilePicture!.path}');
  }

  @override
  void dispose() {
    _tweetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tweetImages = ref.watch(tweetImagesProvider);

    return WillPopScope(
      onWillPop: () {
        if (_tweetController.text.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Discard Tweet?'),
              content:
                  const Text('Are you sure you want to discard this tweet?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Discard');
                    Navigator.pop(context);
                  },
                  child: const Text('Discard'),
                ),
              ],
            ),
          );
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: QwitterAppBar(
            showLogo: false,
            autoImplyLeading: false,
            isButton: true,
            includeActions: true,
            onPressed: () {
              if (_tweetController.text.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Discard Tweet?'),
                    content: const Text(
                        'Are you sure you want to discard this tweet?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Discard');
                          Navigator.pop(context);
                        },
                        child: const Text('Discard'),
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
            actionButton: Semantics(
              button: true,
              label: 'postTweetButtonLabel',
              child: PrimaryButton(
                key: const Key('postTweetButton'),
                text: 'Post',
                onPressed: () {
                  if (_tweetController.text.isNotEmpty) {
                    addTweet(tweetImages).then((value) {
                      if (value) {
                        Fluttertoast.showToast(
                            msg: 'Tweet posted successfully!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey[800],
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Error posting tweet',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey[800],
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    });
                  }
                },
                paddingValue:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                buttonSize: const Size(100, 10),
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage:
                          NetworkImage(AppUser().profilePicture!.path),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).viewInsets.bottom) *
                            0.5
                        : (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).viewInsets.bottom) *
                            0.2,
                    child: TextField(
                      onChanged: (text) {
                        ref
                            .read(tweetProgressProvider.notifier)
                            .setTweetProgress(1 - text.length / 280);
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
                      controller: _tweetController,
                      expands: true,
                      maxLength: 280,
                    ),
                  ),
                ],
              ),
              const AddTweetActionBar()
            ],
          ),
        ),
      ),
    );
  }
}
