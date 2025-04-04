import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssl_commerz/web_socket_provider.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late TextEditingController toController;
  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    toController = TextEditingController();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    toController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WebSocketProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text("Enter your friend's name (receiver):"),
            const SizedBox(height: 10),
            TextFormField(
              controller: toController,
              decoration: InputDecoration(
                hintText: "Enter receiver's name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Type your message:"),
            const SizedBox(height: 10),
            TextFormField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "Enter message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final to = toController.text.trim();
                final msg = messageController.text.trim();

                if (to.isNotEmpty && msg.isNotEmpty) {
                  provider.sendMessage(to, msg);
                  messageController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill both fields")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 38, 166, 130).withOpacity(0.9),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Send Message"),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const Text(
              "Messages",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  final msg = provider.messages[index];
                  return ListTile(
                    title: Text("${msg["from"]} ➤ ${msg["to"]}"),
                    subtitle: Text(msg["message"]),
                    trailing: Text(
                      msg["timestamp"] != null
                          ? msg["timestamp"].toString().substring(11, 19)
                          : "--:--",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
