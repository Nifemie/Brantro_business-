# Brantro File & Image Service: Uploading & Getting Images

This document explains the exact **File Service**, **Endpoints**, and **CDN Retrieval** architecture used across Brantro.

---

## 1. Endpoints Summary

### A. Upload Image / File (API)
* **URL**: `POST https://api.syroltech.com/brantro/api/v1/upload`
* **Method**: `POST`
* **Content-Type**: `multipart/form-data`
* **Headers**: `Authorization: Bearer {{ACCESS_TOKEN}}`
* **Form-Data Body**:
  * `file`: `<Binary File>` (e.g. `image.png`, `avatar.jpg`)
  * `prefix`: `avatar` *(or `cover`, `location-thumbnail`, `proof`, `creative`)*

#### Upload Response Example:
```json
{
  "success": true,
  "message": "File uploaded successfully",
  "payload": {
    "url": "648732_1787907723226.png",
    "key": "648732_1787907723226.png",
    "s3Key": "648732_1787907723226.png"
  }
}
```

---

### B. Retrieve / Get Image (CDN)
The backend does **not** serve raw image bytes from the API server. Instead, images are served directly through **BunnyCDN**:

* **CDN Base URL**: `https://realta360.b-cdn.net`
* **Full Image URL**: `https://realta360.b-cdn.net/{{FILE_KEY}}`
* **Example**: 
  ```text
  https://realta360.b-cdn.net/648732_1787907723226.png
  ```
* **Headers**: None needed (public GET request).

---

## 2. File Service Implementation (`file_repository.dart`)

```dart
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

class FileRepository {
  final Dio dio;

  // Base API configuration
  static const String uploadEndpoint = 'https://api.syroltech.com/brantro/api/v1/upload';
  static const String cdnBaseUrl = 'https://realta360.b-cdn.net';

  FileRepository(this.dio);

  /// 1. Upload a local file and return the generated filename / key
  Future<String> uploadFile(
    String localFilePath, {
    String prefix = 'avatar',
    String? bearerToken,
  }) async {
    try {
      final file = File(localFilePath);
      final fileName = file.path.split(Platform.pathSeparator).last;

      // Prepare Multipart FormData
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          localFilePath,
          filename: fileName,
        ),
        'prefix': prefix,
      });

      log('[FileService] Uploading $fileName (prefix: $prefix)...');

      final response = await dio.post(
        uploadEndpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
          },
        ),
      );

      if (response.data != null && response.data['success'] == true) {
        final payload = response.data['payload'];
        // Extract the stored file key
        final fileKey = payload['s3Key'] ?? payload['key'] ?? payload['url'];
        log('[FileService] Upload SUCCESS: $fileKey');
        return fileKey.toString();
      }

      throw Exception(response.data?['message'] ?? 'Failed to upload image');
    } on DioException catch (e) {
      log('[FileService] Upload FAILED: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception(e.response?.data?['message'] ?? 'Network error uploading file');
    }
  }

  /// 2. Helper to construct the full CDN image URL from any stored key
  static String getFullImageUrl(String? fileKey) {
    if (fileKey == null || fileKey.trim().isEmpty) return '';
    // If it's already a full URL, return as-is
    if (fileKey.startsWith('http://') || fileKey.startsWith('https://')) {
      return fileKey;
    }
    // Prepend CDN base URL
    return '$cdnBaseUrl/$fileKey';
  }
}
```

---

## 3. ApiClient `postFormData` Helper (`api_client.dart`)

If you use a centralized `ApiClient` with interceptors:

```dart
Future<Response> postFormData(
  String path, {
  required FormData data,
  Options? options,
}) async {
  final token = await SessionService.getAccessToken();

  final mergedOptions = options ?? Options();
  mergedOptions.headers ??= {};
  mergedOptions.headers!['Content-Type'] = 'multipart/form-data';
  if (token != null && token.isNotEmpty) {
    mergedOptions.headers!['Authorization'] = 'Bearer $token';
  }

  return dio.post(
    path,
    data: data,
    options: mergedOptions,
  );
}
```

---

## 4. End-to-End Profile Avatar Flow

### Step 1: Pick Image and Upload
```dart
// 1. Pick file from device gallery/camera using image_picker
final ImagePicker picker = ImagePicker();
final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

if (pickedFile != null) {
  // 2. Upload via FileRepository
  final fileRepo = FileRepository(dio);
  final token = await SessionService.getAccessToken();
  
  final String fileKey = await fileRepo.uploadFile(
    pickedFile.path,
    prefix: 'avatar',
    bearerToken: token,
  );
  // fileKey is now e.g. "648732_1787907723226.png"

  // 3. Save fileKey to User Profile via PUT /api/v1/user/:userId
  final userId = user.id;
  await dio.put(
    'https://api.syroltech.com/brantro/api/v1/user/$userId',
    data: {
      'avatarUrl': fileKey,
    },
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );

  // 4. Update local session cache
  user['avatarUrl'] = fileKey;
  await SessionService.saveUser(user);
}
```

---

## 5. UI Helper for Displaying Images (`avatar_helper.dart`)

```dart
import 'dart:io';
import 'package:flutter/material.dart';

class AvatarHelper {
  static const String cdnBaseUrl = 'https://realta360.b-cdn.net';

  /// Resolves any URL or Key to an ImageProvider
  static ImageProvider getImageProvider(String? url) {
    if (url == null || url.trim().isEmpty) {
      return const AssetImage('assets/images/default_avatar.png');
    }
    if (url.startsWith('assets/')) {
      return AssetImage(url);
    }
    if (url.startsWith('file://')) {
      final cleanPath = url.replaceFirst('file://', '');
      return FileImage(File(cleanPath));
    }
    if (url.startsWith('/') || url.contains(':\\') || url.contains(':/')) {
      return FileImage(File(url));
    }
    // Relative CDN filename (e.g. 648732_1787907723226.png)
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return NetworkImage('$cdnBaseUrl/$url');
    }
    // Full URL
    return NetworkImage(url);
  }
}
```

### UI Usage:
```dart
CircleAvatar(
  radius: 36,
  backgroundColor: Colors.grey[200],
  backgroundImage: AvatarHelper.getImageProvider(user.avatarUrl),
)
```
