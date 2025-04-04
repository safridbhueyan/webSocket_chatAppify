import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssl_commerz/chat.dart';
import 'package:ssl_commerz/web_socket_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController text;

  @override
  void initState() {
    super.initState();
    text = TextEditingController();
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("WebSocket"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter your Name"),
            const SizedBox(height: 10),
            TextFormField(
              controller: text,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.cyanAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.tealAccent),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color.fromARGB(179, 160, 32, 32)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Consumer<WebSocketProvider>(
              builder: (_, provider, __) {
                return ElevatedButton(
                  onPressed: provider.isLoading
                      ? null
                      : () {
                          if (text.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please enter your name")),
                            );
                            return;
                          }

                          provider.login(text.text.trim()).then((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Chat()),
                            );
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 38, 166, 130).withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 4,
                  ),
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("Send"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
