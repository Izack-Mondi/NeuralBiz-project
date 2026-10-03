import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MediaPicker {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (file == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final saved = await File(file.path).copy('${appDir.path}/$fileName');
    return saved.path;
  }

  static Future<String?> pickVideo() async {
    final XFile? file = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 3),
    );

    if (file == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final saved = await File(file.path).copy('${appDir.path}/$fileName');
    return saved.path;
  }
}
