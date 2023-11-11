import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/models/messeage.dart';

class ScrollableMessages extends StatefulWidget {
  ScrollableMessages({super.key, required this.msgs});
  List<Message> msgs;
  @override
  State<ScrollableMessages> createState() => _ScrollableMessagesState();
}

class _ScrollableMessagesState extends State<ScrollableMessages> {
  
  @override
  Widget build(context) {
    return Expanded(
      child: GroupedListView<Message, DateTime>(
        padding: const EdgeInsets.all(8),
        elements: widget.msgs,
        groupBy: (msgs) => DateTime(
          msgs.date.year,
          msgs.date.month,
          msgs.date.day,
        ),
        groupHeaderBuilder: (Message msg) => SizedBox(
          height: 40,
          child: Center(
            child: Text(DateFormat.yMMMd().format(msg.date)),
          ),
        ),
        itemBuilder: (context, Message message) => Align(
          alignment:
              message.byMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              color: message.byMe
                  ? Colors.blue
                  : const Color.fromARGB(255, 235, 235, 235),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(message.text),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
