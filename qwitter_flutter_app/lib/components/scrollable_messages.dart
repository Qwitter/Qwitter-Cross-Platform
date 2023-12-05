import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/theme/theme_constants.dart';

class ScrollableMessages extends StatefulWidget {
  ScrollableMessages({super.key, required this.msgs});
  List<MessageData> msgs;
  @override
  State<ScrollableMessages> createState() => _ScrollableMessagesState();
}

class _ScrollableMessagesState extends State<ScrollableMessages> {
  @override
  Widget build(context) {
    return Expanded(
      child: GroupedListView<MessageData, DateTime>(
        sort: false,
        padding: const EdgeInsets.all(8),
        elements: widget.msgs,
        groupBy: (msgs) => DateTime(
          msgs.date.year,
          msgs.date.month,
          msgs.date.day,
        ),
        groupHeaderBuilder: (MessageData msg) => SizedBox(
          height: 40,
          child: Center(
            child: Text(
              DateFormat.yMMMd().format(msg.date),
              style: const TextStyle(color: white),
            ),
          ),
        ),
        itemBuilder: (context, MessageData message) => Align(
          alignment:
              message.byMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              color:
                  message.byMe ? Colors.blue : Color.fromARGB(255, 50, 57, 64),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  message.text,
                  style: TextStyle(
                      color: message.byMe
                          ? white
                          : Color.fromARGB(255, 232, 231, 231)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
