import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';

class MessageNotifier extends StateNotifier<List<MessageData>> {
  MessageNotifier() : super([]);

  void insertOldMessages(List<MessageData> msgs) {
    print("enter");
    print(msgs.length);
    for (var msg in msgs) {
      // bool prevLoaded = state.contains(tweet);
      if (!state.contains(msg)) {
        state = [...state, msg];
      }
    }
  }

  void printState() {
    for (var msg in state) {
      print(msg.text);
    }
  }

  void DeleteMessage(MessageData msg) {
    state = List.from(state)..removeWhere((data) => data == msg);
  }

  void DeleteHistory() {
    state = [];
  }

  bool addList(List<MessageData> msgs) {
    bool added = false;

    for (var msg in msgs) {
      if (!state.contains(msg)) {
        print(msg.text);
        print(msg.date);
        print(msg.id);
        print(msg.name);
        if (state.isNotEmpty) {
          print(state.last == msg);
          print(state.last.text);
          print(state.last.date);
          print(state.last.id);
          print(state.last.name);
        }
        added = true;
        state = [...state, msg];
      }
    }
    return added;
  }

  void addMessage(MessageData msg) {
    state = [msg, ...state];
  }
}

final messagesProvider =
    StateNotifierProvider<MessageNotifier, List<MessageData>>((ref) {
  return MessageNotifier();
});
