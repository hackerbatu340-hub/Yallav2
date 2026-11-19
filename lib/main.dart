import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const YallaCloneApp());
}

class YallaCloneApp extends StatelessWidget {
  const YallaCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YallaClone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1B1425),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFB300)),
      ),
      home: const LoginScreen(),
    );
  }
}
