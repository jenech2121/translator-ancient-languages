import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationResult {
  final String primary;
  final List<String> alternatives;
  final String definition;

  TranslationResult({required this.primary, required this.alternatives, required this.definition});
}

class TranslationService {
  Future<dynamic> translateText(String text, String langCode) async {
    final cleanText = text.trim();
    // Проверка на запрещенные символы (Кириллица, Китайский и т.д.)
    // Разрешаем только Латиницу, Греческий и знаки препинания
    if (RegExp(r'[а-яА-ЯёЁ一-龥]').hasMatch(cleanText)) {
      return "ERROR_INVALID_LANG";
    }

    bool isAncient = RegExp(r'[α-ωΑ-Ω]').hasMatch(cleanText);
    
    try {
      final url = Uri.parse('https://en.wiktionary.org/api/rest_v1/page/definition/${Uri.encodeComponent(cleanText)}');
      final res = await http.get(url).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        String? key = data.keys.firstWhere((k) => k.toLowerCase().contains('greek') || k.toLowerCase().contains('latin'), orElse: () => "");

        if (key.isNotEmpty) {
          final List<dynamic> entries = data[key];
          String primary = cleanText;
          List<String> alts = [];
          String def = entries[0]['definitions'][0]['definition'].toString().replaceAll(RegExp(r'<[^>]*>'), '');

          return TranslationResult(primary: primary, alternatives: alts, definition: def);
        }
      }

      // Если ввели английский — ищем эквиваленты
      if (!isAncient) {
        final searchUrl = Uri.parse('https://en.wiktionary.org/w/api.php?action=query&list=search&srsearch=incategory:Ancient_Greek_lemmas+$cleanText&format=json&origin=*');
        final sRes = await http.get(searchUrl);
        final sData = json.decode(sRes.body);
        final List<dynamic> sResults = sData['query']['search'] ?? [];

        if (sResults.isNotEmpty) {
          String primary = sResults[0]['title'];
          List<String> alternatives = sResults.skip(1).map((e) => e['title'].toString()).toList();
          return TranslationResult(primary: primary, alternatives: alternatives, definition: "Ancient equivalent found.");
        }
      }
      
      return "ERROR_NOT_FOUND";
    } catch (e) {
      return "ERROR_CONNECTION";
    }
  }
}