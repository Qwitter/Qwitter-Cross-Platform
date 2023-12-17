import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qwitter_flutter_app/providers/image_provider.dart';
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
  File? image;

  final picker = ImagePicker();

  Future getImageFromGallery() async {
    final XFile? media = await picker.pickImage(source: ImageSource.gallery);
    print(media?.path ?? "NULL");
    if (media == null) return;
    ref.read(imageProvider.notifier).setImage(File(media.path));
  }

  @override
  Widget build(context) {
    image = ref.watch(imageProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        image != null
            ? Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: ImageCard(
                    imageUrl: image!,
                    onRemove: () {
                      setState(() {
                        ref.read(imageProvider.notifier).setImage(null);
                      });
                    }),
              )
            : Container(
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
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                    left: 5,
                    bottom: 1,
                    child: Container(
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(0, 33, 149, 243),
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
                    right: 5,
                    bottom: 1,
                    child: Container(
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.send),
                        onPressed: widget.sendMessage,
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
