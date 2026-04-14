import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCRService {
  // Для английского текста используем латинский скрипт
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<String?> pickAndRecognizeText() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      // 1. Делаем фото (на реальном устройстве)
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90, // Хорошее качество для распознавания
      );
      
      if (image == null) return null;

      // 2. Превращаем файл в InputImage
      final inputImage = InputImage.fromFilePath(image.path);

      // 3. Процесс распознавания
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      // 4. Чистим текст от лишних пробелов и переносов
      String result = recognizedText.text.trim();
      
      return result.isNotEmpty ? result : null;
    } catch (e) {
      print("Ошибка OCR: $e");
      return null;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}