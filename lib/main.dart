import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/meny.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin App',
      home: const LoginPage(),
      routes: {
        '/shell': (_) => const MainShell(),
      },
    );
  }
}