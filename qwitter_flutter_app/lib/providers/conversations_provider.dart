import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/conversation_data.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/models/user.dart';
import 'package:qwitter_flutter_app/screens/messaging/conversations_screen.dart';

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

  void removeConvo(Conversation convo) {
    state = state.where((listConvo) => listConvo.id != convo.id).toList();
  }

  void addConvo(Conversation convo) {
    state = [convo, ...state];
  }

  void updateConvo(Conversation convo, Conversation newConvo) {
    state = state.map(
      (listConvo) {
        if (listConvo.id == convo.id) {
          return newConvo;
        } else {
          return listConvo;
        }
      },
    ).toList();
  }
}

final ConversationProvider =
    StateNotifierProvider<ConversationNotifier, List<Conversation>>((ref) {
  return ConversationNotifier();
});
final convoProvider = Provider.family<Conversation, String>(
  (ref, arg) {
    List<Conversation> conversations = ref.watch(ConversationProvider);
    Conversation? convo = conversations.firstWhere((convo) => convo.id == arg);
    return convo;
  },
);
