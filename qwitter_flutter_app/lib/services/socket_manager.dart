import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/notification.dart';
import 'package:qwitter_flutter_app/utils/enums.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  factory SocketManager() => _instance;

  SocketManager._internal();

  IO.Socket? _socket;
  bool _isConnecting = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void initializeSocket() {
    AppUser user = AppUser();
    user.getUserData();
    print("socket username: ${user.username ?? "not found"}");
    _socket = IO.io('http://back.qwitter.cloudns.org:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.onConnect((_) {
      print('Socket Connected to socket');
    });

    _socket!.onDisconnect((_) {
      print('Socket Disconnected from socket');
      _startReconnection();
    });

    _socket!.on('UNREAD_CONVERSATIONS', (data) {
      print('Socket unread Received data: $data');
    });

    _socket!.on('NOTIFICATION', (data) {
      print('Socket Received data: $data');
      QwitterNotification notification = QwitterNotification.fromJson(data);
      displayNotification(notification);
    });

    _socket!.connect();
    _socket!.emit('JOIN_ROOM', user.username);
  }

  
  Future<void> displayNotification(QwitterNotification notification) async {
    AppUser user = AppUser();
    user.getUserData();
    String text = notification.type == NotificationType.follow_type
        ? "New Follow"
        : notification.type == NotificationType.login_type
            ? "Recent Login"
            : notification.type == NotificationType.like_type
                ? "Got New Likes"
                : notification.type == NotificationType.retweet_type
                    ? "New Retweet"
                    : notification.type == NotificationType.reply_type
                        ? "New Reply"
                        : notification.type == NotificationType.mention_type
                            ? "Got Mentioned "
                            : notification.type == NotificationType.post_type
                                ? "New Post"
                                : " ";
    String desc = notification.type == NotificationType.follow_type
        ? "${notification.user!.fullName!} followed you"
        : notification.type == NotificationType.login_type
            ? "There was a recent login to your account @${user.username ?? ''}"
            : notification.type == NotificationType.like_type
                ? "${notification.user!.fullName!} liked your tweet"
                : notification.type == NotificationType.retweet_type
                    ? "${notification.user!.fullName!} reposted your post"
                    : notification.type == NotificationType.reply_type
                        ? "${notification.tweet?.text?? notification.user!.fullName} ${notification.tweet == null? 'replied to your post': ''}"
                        : notification.type == NotificationType.mention_type
                            ? "${notification.tweet?.text?? notification.user!.fullName} ${notification.tweet == null? 'replied to your post': ''}"
                            : notification.type == NotificationType.post_type
                                ? "${notification.user!.fullName!} Posted New Post"
                                : " ";
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'qwitter_channel', // Replace with your own channel ID
      'Qwitter', // Replace with your own channel name
      channelDescription:
          'Qwitter App Notification', // Replace with your own channel description
      importance: Importance.max,
      priority: Priority.high,
      icon: 'qwitter',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      text,
      desc,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void _startReconnection() async {
    while (!_socket!.connected) {
      print('Attempting to reconnect to socket...');
      await Future.delayed(Duration(seconds: 5));
      _socket!.connect();
      if (isConnected) {
        print("socket reconnected");
      }
    }

    _socket!.onError((error) {
      print('Socket Error: $error');
      if (!_isConnecting) {
        _isConnecting = true;
        _startReconnection();
      }
    });
    _isConnecting = false;
  }

  void disposeSocket() {
    _socket?.disconnect();
    _socket = null;
  }

  bool get isConnected => _socket?.connected ?? false;
}
