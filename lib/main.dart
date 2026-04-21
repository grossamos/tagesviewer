import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const TagesviewerApp());
}

class TagesviewerApp extends StatelessWidget {
  const TagesviewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tagesviewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003A6E)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
