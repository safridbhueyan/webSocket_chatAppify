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
 List<Map<String,dynamic>> _massage =[];
 List<Map<String , dynamic>> get messages => _massage;
 String _username ="";

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
       _username = name;
       connectWebSocket();
        debugPrint("$name your login is Successful");
       
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
void connectWebSocket(){
  _channel = IOWebSocketChannel.connect("ws://192.168.4.3:3000");
  _channel.stream.listen((event){
    final message = jsonDecode(event);
    _massage.add(message);
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
  };

  _channel.sink.add(jsonEncode(msg));
  _massage.add(msg);
  notifyListeners();
}

}
