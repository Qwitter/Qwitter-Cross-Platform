import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_avatar.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_header.dart';
import 'package:qwitter_flutter_app/components/tweet/tweet_video.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';
import 'package:qwitter_flutter_app/screens/tweets/tweet_details.dart';
import 'package:qwitter_flutter_app/services/tweets_services.dart';

class MessagingMediaViewerScreen extends ConsumerStatefulWidget {
  MessagingMediaViewerScreen({
    super.key,
    required this.imageUrl,
    required this.tag,
  });
  final String imageUrl;
  final String tag;
  @override
  ConsumerState<MessagingMediaViewerScreen> createState() =>
      MessagingMediaViewerScreenState();
}

class MessagingMediaViewerScreenState
    extends ConsumerState<MessagingMediaViewerScreen> {
  TextEditingController textEditingController = TextEditingController();

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: AppBar(
          actions:
           [
            // PopupMenuButton(
            //   onSelected: (value) async {
            //     try {
            //     } catch (e) {
            //       print('Error saving image $e');
            //     }
            //   },
            //   itemBuilder: ((context) => const [
            //         PopupMenuItem(
            //           child: Text("Save"),
            //         ),
            //       ]),
            // ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Hero(
            tag: widget.tag,
            child: Image.network(widget.imageUrl),
          ),
        ),
      ),
    );
  }
}
