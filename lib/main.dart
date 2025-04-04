import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssl_commerz/home.dart';
import 'package:ssl_commerz/web_socket_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebSocketProvider()),
        
      ],
      child: const MyApp(),
      )
      
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 127, 109, 157)),
        
      ),
     home: Home(),
    );
  }
}

