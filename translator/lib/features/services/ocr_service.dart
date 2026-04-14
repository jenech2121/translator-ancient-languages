import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class OCRService {
  // Используем латинский скрипт для английского/латыни
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndRecognizeText() async {
    try {
      // 1. Делаем фото (на реальном устройстве)
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 95, // Повышаем качество для точности
      );
      
      if (image == null) return null;

      // 2. Превращаем файл в InputImage
      final inputImage = InputImage.fromFilePath(image.path);

      // 3. Процесс распознавания
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      // 4. Чистим текст
      String result = recognizedText.text.trim();
      
      debugPrint("LOG: OCR распознал текст: $result");
      return result.isNotEmpty ? result : null;
    } catch (e) {
      debugPrint("LOG: Ошибка OCR: $e");
      return null;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}