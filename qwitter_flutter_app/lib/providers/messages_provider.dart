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

  void addMessage(MessageData msg) {
    state = [...state, msg];
  }
}

final messagesProvider =
    StateNotifierProvider<MessageNotifier, List<MessageData>>((ref) {
  return MessageNotifier();
});
