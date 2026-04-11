import 'package:flutter/material.dart';
import '../../../main.dart';
import 'translator_screen.dart'; // Проверь, чтобы файл назывался именно так

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Слушаем изменение языка
    return ValueListenableBuilder(
      valueListenable: isRussian,
      builder: (context, rus, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Text(rus ? "РУ" : "EN", style: const TextStyle(color: Color(0xFFD4AF37))),
                    Switch(
                      value: rus, 
                      onChanged: (v) => isRussian.value = v,
                      activeColor: const Color(0xFFD4AF37), // Цвет кружка
                      activeTrackColor: const Color(0xFFD4AF37).withAlpha(100), // Цвет полоски
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("🏛", style: TextStyle(fontSize: 80)),
                const SizedBox(height: 20),
                Text(
                  rus ? "ДРЕВНИЙ ОРАКУЛ" : "ANCIENT ORACLE",
                  style: const TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFFD4AF37), 
                    letterSpacing: 4
                  ),
                ),
                const SizedBox(height: 50),
                _langBtn(context, rus ? "Древнегреческий" : "Ancient Greek", "grc"),
                _langBtn(context, rus ? "Латынь" : "Latin", "la"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _langBtn(BuildContext context, String name, String code) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1E),
          minimumSize: const Size(double.infinity, 70),
          side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (c) => TranslatorScreen(title: name, code: code))
          );
        },
        child: Text(name, style: const TextStyle(fontSize: 20, color: Color(0xFFD4AF37))),
      ),
    );
  }
}