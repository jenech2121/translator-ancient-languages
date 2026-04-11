import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../services/translation_service.dart';

class TranslatorScreen extends StatefulWidget {
  final String title;
  final String code;
  const TranslatorScreen({super.key, required this.title, required this.code});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _input = TextEditingController();
  final TranslationService _service = TranslationService();
  
  TranslationResult? _result;
  String _error = "";
  bool _loading = false;

  void _translate() async {
    setState(() { _loading = true; _error = ""; _result = null; });
    final res = await _service.translateText(_input.text, widget.code);
    
    setState(() {
      _loading = false;
      if (res is TranslationResult) {
        _result = res;
      } else {
        _error = _getErrorMessage(res.toString());
      }
    });
  }

  String _getErrorMessage(String code) {
    bool rus = isRussian.value;
    if (code == "ERROR_INVALID_LANG") return rus ? "Ошибка: Используйте только английский или греческий!" : "Error: Use only English or Greek!";
    if (code == "ERROR_NOT_FOUND") return rus ? "Слово не найдено в архивах." : "Word not found in archives.";
    return rus ? "Ошибка связи." : "Connection error.";
  }

  @override
  Widget build(BuildContext context) {
    bool rus = isRussian.value;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: const Color(0xFF1E1E1E)),
      body: Column(
        children: [
          // Поле ВВОДА
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF121212),
              child: TextField(
                controller: _input,
                maxLines: null,
                style: const TextStyle(fontSize: 24, color: Colors.white),
                decoration: InputDecoration(
                  hintText: rus ? "Введите текст..." : "Type text...",
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() {}),
              ),
            ),
          ),
          
          const Divider(color: Color(0xFFD4AF37), height: 1),

          // Поле ВЫВОДА
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: const Color(0xFF1E1E1E),
              child: _loading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_error.isNotEmpty) Text(_error, style: const TextStyle(color: Colors.redAccent, fontSize: 18)),
                        if (_result != null) ...[
                          SelectableText(_result!.primary, style: const TextStyle(fontSize: 40, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(_result!.definition, style: const TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic)),
                          const Divider(height: 40, color: Colors.white24),
                          Text(rus ? "БИБЛИОТЕКА ВАРИАНТОВ:" : "LIBRARY OF VARIANTS:", style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 14)),
                          const SizedBox(height: 10),
                          ..._result!.alternatives.map((a) => SelectableText(a, style: const TextStyle(fontSize: 20, height: 1.8))),
                        ]
                      ],
                    ),
                  ),
            ),
          ),
          
          // Кнопка перевода
          Container(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _input.text.isEmpty ? null : _translate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                minimumSize: const Size(double.infinity, 60),
              ),
              child: Text(rus ? "ПЕРЕВЕСТИ" : "TRANSLATE", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}