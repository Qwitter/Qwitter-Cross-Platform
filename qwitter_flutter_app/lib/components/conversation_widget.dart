import 'package:flutter/material.dart';

class ConversationWidget extends StatelessWidget {
  const ConversationWidget(
      {super.key,
      required this.imagePath,
      required this.name,
      required this.handle,
      required this.lastMsg});
  final String imagePath;
  final String name;
  final String handle;
  final String lastMsg;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {print(name);},
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, elevation: 0,),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            children: [
              Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: InkWell(
                    onTap: () {},
                    child: Ink.image(
                      image: AssetImage(imagePath),
                      height: 60,
                      width: 60,
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            "@ $handle",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    lastMsg,
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
