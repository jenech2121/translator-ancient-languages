import 'package:flutter/material.dart';
import '../../services/translation_service.dart'; // Проверьте, что путь верный!

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
  final TranslationService _apiService = TranslationService();
  
  String _result = "Здесь явится мудрость предков...";
  bool _isLoading = false;

  // ГЛАВНАЯ ФУНКЦИЯ ПЕРЕВОДА
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

    try {
      // Отправляем запрос в Gemini через наш сервис
      final aiResponse = await _apiService.translateText(
        text,
        widget.languageName,
      );

      setState(() {
        _isLoading = false;
        _result = aiResponse; // Выводим реальный ответ ИИ
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = "Оракул столкнулся с преградой: Проверьте интернет или API ключ.";
      });
      debugPrint("Ошибка API: $e");
    }
  }

  // Виджет быстрых подсказок (чипсы)
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
      extendBodyBehindAppBar: true,
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
                        _buildChip('Где выход?'),
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
                          hintText: "Напиши фразу для оракула...",
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          prefixIcon: const Icon(Icons.auto_fix_high, color: Color(0xFFD4AF37)),
                          suffixIcon: _controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.white54),
                                  onPressed: () {
                                    setState(() => _controller.clear());
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
                    
                    // Кнопка перевода или индикатор загрузки
                    _isLoading 
                      ? const Column(
                          children: [
                            CircularProgressIndicator(color: Color(0xFFD4AF37)),
                            SizedBox(height: 15),
                            Text(
                              "Духи древних читают свитки...",
                              style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                            ),
                          ],
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
                          ),
                          child: const Text(
                            "РАСШИФРОВАТЬ", 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                          ),
                        ),
                    
                    const SizedBox(height: 40),
                    
                    // Результат (папирус)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E6CA), // Цвет папируса
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3), 
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.history_edu, color: Color(0xFF8B4513), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Свиток мудрости:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF8B4513),
                                  fontWeight: FontWeight.bold,
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