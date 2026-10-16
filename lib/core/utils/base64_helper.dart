import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Helper utility to convert images and files to Base64 strings
class Base64Helper {
  /// Converts a [File] to a full Data URI formatted Base64 string (e.g. data:image/jpeg;base64,...)
  static Future<String> fileToDataUri(
    File file, {
    String defaultMimeType = 'image/jpeg',
  }) async {
    final bytes = await file.readAsBytes();
    final mimeType = _getMimeType(file.path, defaultMimeType);
    final base64String = base64Encode(bytes);
    return 'data:$mimeType;base64,$base64String';
  }

  /// Converts raw [Uint8List] bytes to a Data URI formatted Base64 string
  static String bytesToDataUri(
    Uint8List bytes, {
    String mimeType = 'image/jpeg',
  }) {
    final base64String = base64Encode(bytes);
    return 'data:$mimeType;base64,$base64String';
  }

  /// Converts a [File] to a pure Base64 string (without data: prefix)
  static Future<String> fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  /// Helper to determine MIME type from file extension
  static String _getMimeType(String filePath, String defaultMimeType) {
    final lower = filePath.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.webp')) return 'image/webp';
    return defaultMimeType;
  }
}
