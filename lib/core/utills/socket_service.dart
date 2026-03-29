import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phoenix_slack/core/constants/api_constants.dart';

class SocketService {
  static SocketService? _instance;
  IO.Socket? _socket;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  SocketService._internal();
  
  static SocketService get instance {
    _instance ??= SocketService._internal();
    return _instance!;
  }
  
  Future<void> connect() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) return;
    
    _socket = IO.io(
      ApiConstants.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );
    
    _socket?.connect();
    
    _socket?.onConnect((_) {
    });
    
    _socket?.onDisconnect((_) {
    });
    
    _socket?.onError((error) {
    });
  }
  
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
  }
  
  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }
  
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }
  
  void off(String event) {
    _socket?.off(event);
  }
  
  bool get isConnected => _socket?.connected ?? false;
} 