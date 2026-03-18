import 'package:flutter/material.dart';
import '/features/home/screens/home_screen.dart';

void main() {
  runApp(const AncientTranslatorApp());
}

class AncientTranslatorApp extends StatelessWidget {
  const AncientTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ancient Oracle AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFD4AF37),
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const HomeScreen(),
    );
  }
}