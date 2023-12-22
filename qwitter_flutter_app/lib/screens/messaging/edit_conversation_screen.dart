import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/providers/conversations_provider.dart';
import 'package:qwitter_flutter_app/providers/next_bar_provider.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversations_screen.dart';
import 'package:http/http.dart' as http;
import 'package:qwitter_flutter_app/services/Messaging_service.dart';

class EditConversationScreen extends ConsumerStatefulWidget {
  EditConversationScreen({super.key, required this.convo, required this.f});
  Conversation convo;
  Function(Conversation convo) f;
  @override
  ConsumerState<EditConversationScreen> createState() =>
      _EditConversationScreenState();
}

class _EditConversationScreenState
    extends ConsumerState<EditConversationScreen> {
  final controller = TextEditingController();
  File? imageFile;
  void Function(BuildContext)? savebutton;
  bool buttonPressed=false;
  final picker = ImagePicker();
  Future getImageFromGallery() async {
    final XFile? media = await picker.pickImage(source: ImageSource.gallery);
    if (media == null) return;
    setState(
      () {
        ref.read(nextBarProvider.notifier).setNextBarFunction(save);
        imageFile = File(media.path);
      },
    );
  }

  void getConversation() async {}
  void save(context) async {
    if(buttonPressed==true){
      Fluttertoast.showToast(
        msg: "Request being processed",
        backgroundColor: Colors.grey[700],
      );
      return;
    }
    buttonPressed=true;
    print('test');
    AppUser user = AppUser();
    String converstaionId = widget.convo.id;
    final url = Uri.parse(
        'http://back.qwitter.cloudns.org:3000/api/v1/conversation/$converstaionId');

    Map<String, String> fields = {
      'name': controller.text,
    };

    final request = http.MultipartRequest('PUT', url);
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer ${AppUser().getToken}',
    });
    request.fields.addAll(fields);
    if (imageFile != null) {
      final fileName = basename(imageFile!.path);

      final stream = http.ByteStream(imageFile!.openRead());
      final length = await imageFile!.length();
      final imgType = lookupMimeType(imageFile!.path);
      final contentType = imgType!.split('/');

      final multipartFile = http.MultipartFile(
        'media', // Use the same field name for all files
        stream,
        length,
        filename: fileName,
        contentType: MediaType(contentType[0], contentType[1]),
      );

      request.files.add(multipartFile);
    }

    final streamResponse = await request.send();
    try {
      print('done requesting');
      final response = await http.Response.fromStream(streamResponse);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        Conversation? newConvo =
            await MessagingServices.getSingleConversations(widget.convo.id);
        print('done getting convo');
        if (newConvo != null) {
          // widget.f(newConvo);

          ref
              .read(ConversationProvider.notifier)
              .updateConvo(widget.convo, newConvo!);
          Navigator.pop(context,newConvo);
          // setState(() {
          //   widget.convo = newConvo!;
          //   print(newConvo.fullName);
          // });
          print('ref');
        } else
          Navigator.pop(context);
        ;
      } else {
        Fluttertoast.showToast(
            msg: 'Error in editing converstaion, please try again later');
      }
    } catch (e) {
      print("editing conversation error");
    }
    buttonPressed=false;
  }

  textListener() {
    ref.read(nextBarProvider.notifier).setNextBarFunction(
        (imageFile == null && controller.text == widget.convo.fullName) ||
                controller.text.isEmpty
            ? null
            : save);
  }

  @override
  initState() {
    super.initState();
    controller.addListener(
      textListener,
    );
    controller.text = widget.convo.name;
  }

  @override
  Widget build(BuildContext context) {
    savebutton = ref.watch(nextBarProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: AppBar(
          title: Text("Edit group information"),
          actions: [
            TextButton(
              onPressed: savebutton == null
                  ? null
                  : () {
                      savebutton!(context);
                    },
              child: Text(
                "Save",
                style: TextStyle(
                  color: (savebutton != null) ? Colors.blue : Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              getImageFromGallery();
            },
            icon: ClipOval(
              child: imageFile == null
                  ? Image.network(
                      widget.convo.photo ?? "",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          // Image has successfully loaded
                          return child;
                        } else {
                          // Image is still loading
                          return CircularProgressIndicator();
                        }
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        // Handle image loading errors
                        return Image.asset(
                          "assets/images/def.jpg",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.file(
                      imageFile!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DecoratedTextField(
            keyboardType: TextInputType.text,
            placeholder: 'Name your group',
            controller: controller,
          ),
        ],
      ),
    );
  }
}
