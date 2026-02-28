import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick an image from gallery
  Future<File?> pickImage({
    double maxWidth = 1920,
    double maxHeight = 1080,
    int imageQuality = 85,
  }) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      throw FilePickerException('Failed to pick image: $e');
    }
  }

  /// Pick any file type
  Future<File?> pickFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      throw FilePickerException('Failed to pick file: $e');
    }
  }

  /// Pick a design file (specific formats)
  Future<File?> pickDesignFile() async {
    return pickFile(
      type: FileType.custom,
      allowedExtensions: ['psd', 'ai', 'xd', 'fig', 'sketch', 'pdf'],
    );
  }

  /// Pick a video file
  Future<File?> pickVideo() async {
    return pickFile(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv'],
    );
  }

  /// Check if file is an image
  bool isImageFile(String filePath) {
    final fileName = filePath.toLowerCase();
    return fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.png') ||
        fileName.endsWith('.gif') ||
        fileName.endsWith('.webp');
  }

  /// Get file name from path
  String getFileName(String filePath) {
    return filePath.split('/').last;
  }

  /// Get file extension
  String getFileExtension(String filePath) {
    final fileName = getFileName(filePath);
    return fileName.split('.').last.toUpperCase();
  }
}

class FilePickerException implements Exception {
  final String message;
  FilePickerException(this.message);

  @override
  String toString() => message;
}
