import 'package:flutter/material.dart';
import '../../../../main.dart';
import 'translator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isRussian,
      builder: (context, rus, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  children: [
                    Text(rus ? "РУ" : "EN", style: const TextStyle(color: Color(0xFFD4AF37))),
                    Switch(
                      value: rus,
                      onChanged: (v) => isRussian.value = v,
                      activeThumbColor: const Color(0xFFD4AF37),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text("🏛", style: TextStyle(fontSize: 80)),
                  Text(rus ? "ДРЕВНИЙ ОРАКУЛ" : "ANCIENT ORACLE",
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37), letterSpacing: 4)),
                  const SizedBox(height: 40),
                  _btn(context, rus ? "Латынь" : "Latin", "la"),
                  _btn(context, rus ? "Древнегреческий" : "Ancient Greek", "grc"),
                  _btn(context, rus ? "Древнеегипетский" : "Egyptian", "egypt"),
                  _btn(context, rus ? "Аккадский" : "Akkadian", "akk"),
                  _btn(context, rus ? "Старославянский" : "Old Slavonic", "cu"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _btn(BuildContext context, String name, String code) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1E),
          minimumSize: const Size(double.infinity, 65),
          side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => TranslatorScreen(title: name, code: code))),
        child: Text(name, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 18)),
      ),
    );
  }
}