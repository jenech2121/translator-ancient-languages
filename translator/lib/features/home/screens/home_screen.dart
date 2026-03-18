import 'package:flutter/material.dart';
import 'translation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF4B3621)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Заголовок с древним символом
              const Text('𓋹', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 64)),
              const SizedBox(height: 10),
              const Text(
                'ANCIENT ORACLE', 
                style: TextStyle(
                  color: Color(0xFFD4AF37), 
                  fontSize: 32, 
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 6,
                )
              ),
              const SizedBox(height: 10),
              const Text(
                'ВЫБЕРИТЕ ЯЗЫК', 
                style: TextStyle(
                  color: Color(0xFFD4AF37), 
                  fontSize: 16, 
                  letterSpacing: 4,
                )
              ),
              const SizedBox(height: 60),

              // Кнопки выбора языка
              _buildLanguageButton(context, 'Латынь', 'latin'),
              const SizedBox(height: 20),
              _buildLanguageButton(context, 'Древнегреческий', 'greek'),
              const SizedBox(height: 20),
              _buildLanguageButton(context, 'Древнеегипетский', 'egyptian'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, String title, String langCode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TranslationScreen(
                languageName: title,
                languageCode: langCode,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white10,
          foregroundColor: const Color(0xFFD4AF37),
          minimumSize: const Size(double.infinity, 65),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.5)),
          ),
          elevation: 0,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}