import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class TranslationResult {
  final String word;
  final String transcription;
  final List<String> synonyms;
  final List<String> examples;

  TranslationResult({
    required this.word,
    required this.transcription,
    required this.synonyms,
    required this.examples,
  });
}

class TranslationService {
  final String _groqKey = "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";

  Future<dynamic> translateText(String text, String langCode, bool isRus) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return "EMPTY";

    String uiLang = isRus ? "Russian" : "English";
    Map<String, String> langNames = {
      "la": "Latin", "grc": "Ancient Greek", "egypt": "Ancient Egyptian Hieroglyphs",
      "akk": "Akkadian Cuneiform", "sa": "Sanskrit", "cu": "Old Slavonic"
    };
    String targetLang = langNames[langCode] ?? "Ancient Language";

    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_groqKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {
              'role': 'system',
              'content': '''You are an expert in ancient languages. Translate "$cleanText" to "$targetLang".
              
              CRITICAL RULES:
              1. For Egyptian and Akkadian, the "word" field MUST contain ONLY actual UNICODE SYMBOLS (e.g. 𓀀 or 𒀭). 
              2. DO NOT use latin transliteration in the "word" field. Use it ONLY in "transcription".
              3. Answer strictly in $uiLang.
              
              RETURN JSON:
              {
                "word": "Actual Ancient Symbols (Mandatory for Egypt/Akkad)",
                "transcription": "[phonetic reading]",
                "synonyms": ["other meaning 1", "meaning 2"],
                "examples": ["Ancient phrase -> Translation"]
              }'''
            },
            {'role': 'user', 'content': cleanText}
          ],
          'response_format': {'type': 'json_object'},
          'temperature': 0.1, // Уменьшаем фантазию до минимума для точности
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final jsonRes = jsonDecode(data['choices'][0]['message']['content']);

        return TranslationResult(
          word: (jsonRes['word'] ?? "---").toString(),
          transcription: (jsonRes['transcription'] ?? "").toString(),
          synonyms: List<String>.from(jsonRes['synonyms'] ?? []),
          examples: List<String>.from(jsonRes['examples'] ?? []),
        );
      }
      return "ERROR_${response.statusCode}";
    } catch (e) {
      return "ERROR_CONNECTION";
    }
  }
}