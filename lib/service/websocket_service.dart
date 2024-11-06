import 'dart:convert';
import 'package:linkjo/util/log.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  // Singleton instance
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;

  // Channel WebSocket
  IOWebSocketChannel? _channel;

  // Callback untuk menangani pesan yang diterima
  Function(Map<String, dynamic>)? onMessage;

  // Constructor private untuk singleton
  WebSocketService._internal();

  // Fungsi untuk connect ke WebSocket
  void connect(String url,
      {Function(Map<String, dynamic>)? onMessageCallback}) {
    _channel = IOWebSocketChannel.connect(url);
    onMessage = onMessageCallback;

    // Listen ke pesan yang diterima
    _channel!.stream.listen((message) {
      _handleMessage(message);
    }, onDone: () {
      Log.d("Koneksi WebSocket terputus.");
    }, onError: (error) {
      Log.d("Error: $error");
    });
  }

  // Fungsi untuk mengirim pesan
  void sendMessage(Map<String, dynamic> data) {
    if (_channel != null) {
      final jsonData = jsonEncode(data);
      _channel!.sink.add(jsonData);
      Log.d("Pesan terkirim: $jsonData");
    }
  }

  // Fungsi untuk menutup koneksi
  void disconnect() {
    _channel?.sink.close();
  }

  // Fungsi private untuk menangani pesan yang diterima
  void _handleMessage(String message) {
    final data = jsonDecode(message);
    if (onMessage != null) {
      onMessage!(data);
    }
  }

  // Mengecek apakah koneksi masih aktif
  bool isConnected() {
    return _channel != null;
  }
}
