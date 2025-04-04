import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:ssl_commerz/api.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late WebSocketChannel _channel;
  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  String _username = "";
  String? _token;
  String get username => _username;
  String? get token => _token;

  Future<void> login(String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("http://${Api.login}"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": name,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        _username = data["user"]["username"];
        _token = data["token"];
        connectWebSocket();
        debugPrint("Login successful for $_username with token: $_token");
      } else {
        debugPrint("Login failed: ${data["message"] ?? 'Unknown error'}");
      }
    } catch (e) {
      debugPrint("Login error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void connectWebSocket() {
    final wsUrl = Uri.parse("ws://192.168.4.3:3000?token=$_token");

    _channel = IOWebSocketChannel.connect(wsUrl);

    _channel.stream.listen((event) {
      final message = jsonDecode(event);
      _messages.add(message);
      notifyListeners();
    });
  }

  void sendMessage(String to, String text) {
    if (_channel == null) {
      debugPrint("WebSocket is not connected!");
      return;
    }

    final msg = {
      "from": _username,
      "to": to,
      "message": text,
      "token": _token, 
    };

    _channel.sink.add(jsonEncode(msg));
    _messages.add(msg);
    notifyListeners();
  }

  void disposeWebSocket() {
    _channel.sink.close();
  }
}
