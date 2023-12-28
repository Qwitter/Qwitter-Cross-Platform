import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();

  factory SocketManager() => _instance;

  SocketManager._internal();

  IO.Socket? _socket;
  bool _isConnecting = false;

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
    });

    _socket!.connect();
    _socket!.emit('JOIN_ROOM', user.username);
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
