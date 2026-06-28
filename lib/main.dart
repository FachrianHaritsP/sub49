import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'screens/auth_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WMS HoA',
      home: const AuthChecker(),
     // home: const LoginScreen(),
    );
  }
}

