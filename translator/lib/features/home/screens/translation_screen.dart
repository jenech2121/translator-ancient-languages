import 'package:flutter/material.dart';

class TranslationScreen extends StatefulWidget {
  final String languageName;
  final String languageCode;

  const TranslationScreen({
    super.key, 
    required this.languageName, 
    required this.languageCode,
  });

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = "Здесь явится мудрость предков...";
  bool _isLoading = false;

  Future<void> _translate() async {
    final text = _controller.text.trim();
    
    if (text.isEmpty) {
      setState(() {
        _result = "Напиши фразу для перевода...";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = "Призываю духов древности...";
    });

    await Future.delayed(const Duration(seconds: 2));

    String translatedText;
    // Определяем логику перевода по коду языка
    if (widget.languageCode == 'latin') {
      translatedText = _translateToLatin(text);
    } else if (widget.languageCode == 'greek') {
      translatedText = _translateToGreek(text);
    } else if (widget.languageCode == 'egyptian') {
      translatedText = _translateToEgyptian(text);
    } else {
      translatedText = "Неизвестный язык";
    }

    setState(() {
      _isLoading = false;
      _result = translatedText;
    });
  }

  String _translateToLatin(String text) {
    String cleanText = text.trim();
    const dictionary = {
      'привет': 'Salve', 'мир': 'Mundi', 'как дела': 'Quid agis',
      'спасибо': 'Gratias tibi', 'добро': 'Bonum', 'утро': 'Mane',
      'вечер': 'Vesper', 'день': 'Dies', 'ночь': 'Nox',
      'вода': 'Aqua', 'огонь': 'Ignis', 'земля': 'Terra', 'воздух': 'Aer',
    };

    for (var entry in dictionary.entries) {
      if (cleanText.toLowerCase().contains(entry.key)) {
        return '${entry.value}\n\n(лат. ${entry.value})';
      }
    }
    return '$cleanText in Latin:\n"${cleanText}us" (примерный перевод)';
  }

  String _translateToGreek(String text) {
    String cleanText = text.trim();
    const dictionary = {
      'привет': 'Γεια σας (Yia sas)', 'мир': 'Κόσμος (Kosmos)',
      'спасибо': 'Ευχαριστώ (Efcharistó)', 'добро': 'Αγαθό (Agathó)',
    };

    for (var entry in dictionary.entries) {
      if (cleanText.toLowerCase().contains(entry.key)) {
        return entry.value;
      }
    }
    return 'Древнегреческий: "$cleanText" (в разработке)';
  }

  String _translateToEgyptian(String text) {
    String cleanText = text.trim();
    const hieroglyphs = {
      'привет': '𓋴𓍯𓃀𓈖𓏏 (seneb)', 'жизнь': '𓋹 (ankh)',
      'здоровье': '𓋴𓍯𓃀 (seneb)', 'сила': '𓊪𓃀𓏏 (pehty)',
    };

    for (var entry in hieroglyphs.entries) {
      if (cleanText.toLowerCase().contains(entry.key)) {
        return entry.value;
      }
    }
    return '𓂋𓏺𓈖 𓆎𓅓𓏏𓊖\n(иероглифы в разработке)';
  }

  Widget _buildChip(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.text = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Позволяет градиенту быть под AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        title: Text(
          widget.languageName.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF4B3621)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Быстрые подсказки
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildChip('Привет'),
                        _buildChip('Мир'),
                        _buildChip('Жизнь'),
                        _buildChip('Спасибо'),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Поле ввода
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD4AF37).withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Напиши фразу...",
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          prefixIcon: const Icon(Icons.mic, color: Color(0xFFD4AF37)),
                          suffixIcon: _controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.white54),
                                  onPressed: () {
                                    setState(() {
                                      _controller.clear();
                                    });
                                  },
                                )
                              : null,
                        ),
                        maxLines: 3,
                        minLines: 2,
                        onSubmitted: (_) => _translate(),
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    // Кнопка перевода
                    _isLoading 
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: const [
                              CircularProgressIndicator(
                                color: Color(0xFFD4AF37),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Духи древних читают...",
                                style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _translate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 10,
                            shadowColor: const Color(0xFFD4AF37).withOpacity(0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.auto_awesome, size: 24),
                              SizedBox(width: 10),
                              Text(
                                "РАСШИФРОВАТЬ", 
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                )
                              ),
                            ],
                          ),
                        ),
                    
                    const SizedBox(height: 40),
                    
                    // Результат (папирус)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E6CA),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3), 
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                          BoxShadow(
                            color: const Color(0xFFD4AF37).withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.history_edu, color: Color(0xFF8B4513), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Свиток мудрости:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF8B4513),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            _result, 
                            style: const TextStyle(
                              fontSize: 18, 
                              color: Color(0xFF2B1B17), 
                              fontStyle: FontStyle.italic, 
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}