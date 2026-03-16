import 'package:flutter/material.dart';

void main() {
  runApp(const AncientTranslatorApp());
}

class AncientTranslatorApp extends StatelessWidget {
  const AncientTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ancient Oracle AI',
      theme: ThemeData(brightness: Brightness.dark),
      home: const TranslatorScreen(),
    );
  }
}

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = "Здесь явится мудрость предков...";
  bool _isLoading = false;

  Future<void> _translate() async {
    // Логика перевода будет добавлена позже
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF4B3621)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  const Text('ANCIENT ORACLE', 
                    style: TextStyle(color: Color(0xFFD4AF37), fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 6)),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Напиши фразу и язык (напр: Привет на латыни)",
                      hintStyle: const TextStyle(color: Colors.white30),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  _isLoading 
                    ? const CircularProgressIndicator(color: Color(0xFFD4AF37))
                    : ElevatedButton(
                        onPressed: _translate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("РАСШИФРОВАТЬ", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E6CA),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15)],
                    ),
                    child: Text(_result, 
                      style: const TextStyle(fontSize: 18, color: Color(0xFF2B1B17), fontStyle: FontStyle.italic, height: 1.5)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}