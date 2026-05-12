import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const PocketHeroApp());
}

class PocketHeroApp extends StatelessWidget {
  const PocketHeroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketHero',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
