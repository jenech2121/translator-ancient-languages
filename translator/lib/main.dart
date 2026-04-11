import 'package:flutter/material.dart';
import 'features/home/screens/home_screen.dart';

void main() => runApp(const AncientOracleApp());

// Простой контроллер для смены языка интерфейса
ValueNotifier<bool> isRussian = ValueNotifier(false);

class AncientOracleApp extends StatelessWidget {
  const AncientOracleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isRussian,
      builder: (context, rus, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            primaryColor: const Color(0xFFD4AF37),
            fontFamily: 'Georgia',
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}