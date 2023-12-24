
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/models/notification.dart';
import 'package:qwitter_flutter_app/models/tweet.dart';

class NotificationsProvider extends StateNotifier<List<QwitterNotification>> {
  NotificationsProvider() : super([]);

  void setNotifications(List<QwitterNotification> notifications) {
    for (var notification in notifications) {
      if (state.where((element) => element.date == notification.date).isEmpty) {
        state = [notification, ...state];
      }
    }
  }

  void resetNotifications(List<QwitterNotification> notifications) {
    state = notifications;
  }

  void removeTweet(QwitterNotification notification) {
    state = state.where((t) => t.date != notification.date).toList();
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsProvider, List<QwitterNotification>>((ref) {
  return NotificationsProvider();
});



