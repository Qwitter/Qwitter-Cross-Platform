import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';

class ConversationNotifier extends StateNotifier<List<Conversation>> {
  ConversationNotifier() : super([]);

  void printState() {
    for (var convo in state) {
      print(convo.lastMsg?.text ?? "");
    }
  }

  void DeleteHistory(MessageData msg) {
    state = [];
  }

  void InitConversations(List<Conversation> Convos) {
    print(Convos.length);
    state = Convos;
  }
}

final ConversationProvider =
    StateNotifierProvider<ConversationNotifier, List<Conversation>>((ref) {
  return ConversationNotifier();
});
