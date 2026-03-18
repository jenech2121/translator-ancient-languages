import 'package:google_generative_ai/google_generative_ai.dart';

class TranslationService {
  // Вставьте сюда ваш ключ из AI Studio
  static const String _apiKey = '';
  
  final GenerativeModel _model;

  TranslationService() : _model = GenerativeModel(
    model: 'gemini-pro', // Самая быстрая и дешевая модель
    apiKey: _apiKey,
  );

  Future<String> translateText(String text, String language) async {
    // Формируем инструкцию для нейросети
    final prompt = '''
    Ты — древний оракул и эксперт по лингвистике. 
    Переведи следующую фразу на язык: $language.
    
    Требования к ответу:
    1. Если это Древнеегипетский — используй только иероглифы Юникода.
    2. Если это Латынь или Греческий — напиши перевод и в скобках транскрипцию кириллицей.
    3. Не пиши никаких лишних слов вроде "Вот ваш перевод", только сам результат.
    
    Фреза для перевода: "$text"
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      return response.text ?? "Оракул молчит...";
    } catch (e) {
      return "Ошибка связи с миром духов: $e";
    }
  }
}