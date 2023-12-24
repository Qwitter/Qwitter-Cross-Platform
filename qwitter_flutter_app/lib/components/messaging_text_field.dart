import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:qwitter_flutter_app/models/reply.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/providers/image_provider.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/providers/reply_provider.dart';
import 'package:qwitter_flutter_app/screens/tweets/add_tweet_action_bar.dart';
import 'package:qwitter_flutter_app/theme/theme_constants.dart';

class MessagingTextField extends ConsumerStatefulWidget {
  MessagingTextField({
    super.key,
    required this.textController,
    required this.sendMessage,
  });
  final sendMessage;
  final TextEditingController textController;
  @override
  ConsumerState<MessagingTextField> createState() => _MessagingTextFieldState();
}

class _MessagingTextFieldState extends ConsumerState<MessagingTextField> {
  Media? image;
  Reply? reply;
  final picker = ImagePicker();
  void Function(BuildContext)? sendbutton;

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(() {
      ref.read(sendMessageProvider.notifier).setNextBarFunction(
          widget.textController.text.trim() != '' || image != null
              ? (context) {
                  widget.sendMessage();
                }
              : null);
    });
  }

  void onRemove() {
    ref
        .read(sendMessageProvider.notifier)
        .setNextBarFunction(widget.textController.text.trim() != ''
            ? (context) {
                widget.sendMessage();
              }
            : null);
    ref.read(imageProvider.notifier).setImage(null);
  }

  Future getImageFromGallery() async {
    final XFile? media = await picker.pickImage(source: ImageSource.gallery);
    if (media == null) return;

    ref.read(sendMessageProvider.notifier).setNextBarFunction((context) {
      widget.sendMessage();
    });
    ref.read(imageProvider.notifier).setImage(Media(media.path, 'image'));
  }

  Future getVideoFromGallery() async {
    final XFile? media = await picker.pickVideo(source: ImageSource.gallery);
    if (media == null) return;

    ref.read(sendMessageProvider.notifier).setNextBarFunction((context) {
      widget.sendMessage();
    });
    ref.read(imageProvider.notifier).setImage(Media(media.path, 'video'));
  }

  @override
  Widget build(context) {
    image = ref.watch(imageProvider);
    reply = ref.watch(replyProvider);
    sendbutton = ref.watch(sendMessageProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        image != null && image!.type == 'video'
            ? Card(
                child: Stack(
                  children: [
                    // Display the image
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.play_circle_outline),
                    ),
                    // Close button
                    Positioned(
                      top: -10,
                      right: -10,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: onRemove,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                height: 0,
              ),
        image != null && image!.type == 'image'
            ? Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ImageCard(
                  imageUrl: File(image!.value),
                  onRemove: onRemove,
                ),
              )
            : Container(
                height: 0,
              ),
        reply != null
            ? Container(
                // height: 60,
                width: double.infinity,
                color: const Color.fromARGB(255, 50, 57, 64),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              reply!.replyName ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              reply!.replyText ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (reply!.replyMedia != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(reply!.replyMedia!.value,
                            height: 50,
                            width: 50, loadingBuilder: (BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            // Image has successfully loaded
                            return child;
                          } else {
                            // Image is still loading
                            return CircularProgressIndicator();
                          }
                        }, errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                          // Handle image loading errors
                          return const SizedBox(
                            height: 0,
                          );
                        }),
                      )
                    ],
                    IconButton(
                      onPressed: () {
                        ref.read(replyProvider.notifier).set(null);
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(
                height: 0,
              ),
        Container(
          constraints: const BoxConstraints(maxHeight: 300),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 50, 57, 64),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(60, 0, 30, 0),
                        child: TextField(
                          style: const TextStyle(
                              color: Color.fromARGB(255, 204, 203, 203)),
                          controller: widget.textController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 204, 203, 203),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            hintText: 'Start a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // top: 5,
                    left: 0,
                    bottom: 1,
                    child: Container(
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(0, 95, 129, 157),
                      ),
                      child: IconButton(
                        splashRadius: 30,
                        color: Colors.white,
                        icon: const Icon(Icons.image),
                        onPressed: getImageFromGallery,
                      ),
                    ),
                  ),
                  Positioned(
                    // top: 5,
                    left: 30,
                    bottom: 1,
                    child: Container(
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(0, 95, 129, 157),
                      ),
                      child: IconButton(
                        splashRadius: 30,
                        color: Colors.white,
                        icon: const Icon(Icons.play_circle_outline_outlined),
                        onPressed: getVideoFromGallery,
                      ),
                    ),
                  ),
                  Positioned(
                    // top: 5,
                    right: 5,
                    bottom: 1,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: sendbutton != null
                            ? Color.fromARGB(255, 61, 195, 253)
                            : Color.fromARGB(255, 50, 57, 64),
                      ),
                      child: IconButton(
                        color: sendbutton == null ? Colors.white : Colors.black,
                        icon: const Icon(Icons.send),
                        onPressed: sendbutton == null
                            ? null
                            : () {
                                sendbutton!(context);
                              },
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
