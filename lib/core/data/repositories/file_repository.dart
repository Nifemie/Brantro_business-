import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/api_client.dart';
import '../../constants/endpoints.dart';

final fileRepositoryProvider = Provider<FileRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return FileRepository(apiClient);
});

class FileRepository {
  final ApiClient apiClient;

  FileRepository(this.apiClient);

  /// Upload a file and get the URL
  /// 
  /// [filePath] is the local path to the file
  /// [prefix] is the directory prefix required by the backend (e.g. 'location-thumbnail')
  Future<String> uploadFile(String filePath, {String? prefix}) async {
    try {
      log('[FileRepository] Uploading file: $filePath with prefix: $prefix');
      
      final file = File(filePath);
      final fileName = file.path.split('/').last;
      
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
        if (prefix != null) 'prefix': prefix,
      });

      final response = await apiClient.postFormData(
        ApiEndpoints.uploadFile,
        data: formData,
      );

      log('[FileRepository] File uploaded successfully');
      
      if (response.data['success'] == true) {
        final fileUrl = response.data['payload']['url'] as String;
        return fileUrl;
      }

      throw Exception(response.data['message'] ?? 'Failed to upload file');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      
      log('[FileRepository] File upload FAILED');
      log('[FileRepository] Status Code: $statusCode');
      log('[FileRepository] Error Data: $responseData');

      String errorMessage = 'Failed to upload file. Please try again.';

      if (statusCode == 400) {
        errorMessage = responseData?['message'] ?? 'Invalid file';
      } else if (statusCode == 413) {
        errorMessage = 'File is too large';
      } else if (responseData is Map) {
        errorMessage = responseData['message'] ?? responseData['error'] ?? errorMessage;
      }

      throw Exception(errorMessage);
    } catch (e) {
      log('[FileRepository] Unexpected Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
