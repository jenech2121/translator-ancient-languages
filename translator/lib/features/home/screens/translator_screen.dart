import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../main.dart';
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
  bool _loading = false;
  String _error = "";

  void _translate() async {
    if (_input.text.isEmpty) return;
    setState(() { _loading = true; _error = ""; _result = null; });
    final res = await _service.translateText(_input.text, widget.code, isRussian.value);
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (res is TranslationResult) { _result = res; } 
      else { _error = isRussian.value ? "Ошибка оракула" : "Oracle Error"; }
    });
  }

  TextStyle _getAncientStyle() {
    if (widget.code == 'egypt') {
      return GoogleFonts.notoSansEgyptianHieroglyphs(fontSize: 55, color: const Color(0xFF2B1B17));
    } else if (widget.code == 'akk') {
      return GoogleFonts.notoSansCuneiform(fontSize: 50, color: const Color(0xFF2B1B17));
    } else {
      return const TextStyle(fontSize: 38, color: Color(0xFF2B1B17), fontWeight: FontWeight.bold);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool rus = isRussian.value;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: const Color(0xFF1E1E1E)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            color: const Color(0xFF121212),
            child: TextField(
              controller: _input,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(hintText: rus ? "Введите слово..." : "Type word...", border: InputBorder.none),
            ),
          ),
          const Divider(color: Color(0xFFD4AF37), height: 1),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              color: const Color(0xFFF5E6CA),
              child: _loading 
                ? const Center(child: CircularProgressIndicator(color: Colors.brown))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_error.isNotEmpty) Text(_error, style: const TextStyle(color: Colors.red)),
                        if (_result != null) ...[
                          SelectableText(_result!.word, style: _getAncientStyle()),
                          Text(_result!.transcription, style: const TextStyle(fontSize: 22, color: Colors.brown, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 30),
                          Text(rus ? "ВАРИАНТЫ:" : "VARIANTS:", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
                          const Divider(color: Colors.black26),
                          ..._result!.synonyms.map((s) => Text("• $s", style: const TextStyle(fontSize: 18, color: Colors.black87))),
                          const SizedBox(height: 30),
                          Text(rus ? "ПРИМЕРЫ:" : "EXAMPLES:", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
                          const Divider(color: Colors.black26),
                          ..._result!.examples.map((e) => Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(e, style: const TextStyle(fontSize: 16, color: Color(0xFF4E342E), height: 1.4)),
                          )),
                        ]
                      ],
                    ),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _translate,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), minimumSize: const Size(double.infinity, 60)),
              child: Text(rus ? "РАСШИФРОВАТЬ" : "DECODE", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}