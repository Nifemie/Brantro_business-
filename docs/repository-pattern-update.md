# Repository Pattern Update

## Overview
Updated billboard and category repositories to follow the established codebase pattern with proper error handling, logging, and API client usage.

## Pattern Guidelines

### Repository Structure
```dart
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:brantro_business/core/network/api_client.dart';
import 'package:brantro_business/core/constants/endpoints.dart';

class ExampleRepository {
  final ApiClient apiClient;

  ExampleRepository(this.apiClient);

  Future<ResponseType> methodName(params) async {
    try {
      log('[RepositoryName] Action description');
      
      final response = await apiClient.post/get(
        ApiEndpoints.endpointName,
        data: payload, // for POST
        query: queryParams, // for GET
      );

      log('[RepositoryName] Success message');
      
      if (response.data['success'] == true) {
        return parseResponse(response.data['payload']);
      }

      throw Exception(response.data['message'] ?? 'Default error');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      
      log('[RepositoryName] Action FAILED');
      log('[RepositoryName] Status Code: $statusCode');
      log('[RepositoryName] Error Data: $responseData');

      String errorMessage = 'Default error message';

      // Handle specific status codes
      if (statusCode == 400) {
        errorMessage = responseData?['message'] ?? 'Bad request';
      } else if (statusCode == 401) {
        errorMessage = 'Unauthorized: Please log in again';
      } else if (statusCode == 403) {
        errorMessage = 'Forbidden: No permission';
      } else if (statusCode != null && statusCode >= 500) {
        errorMessage = 'Server error ($statusCode)';
      } else if (responseData is Map) {
        errorMessage = responseData['message'] ?? responseData['error'] ?? errorMessage;
      }

      throw Exception(errorMessage);
    } catch (e) {
      log('[RepositoryName] Unexpected Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
```

## Updated Files

### 1. Endpoints
**File:** `lib/core/constants/endpoints.dart`
- Added `createLocation` endpoint
- Added `locationDetails` endpoint
- Added `categoryList` endpoint

### 2. Billboard Repository
**File:** `lib/features/billboard/data/repositories/billboard_repository.dart`
- Renamed `uploadBillboard` to `createLocation`
- Added proper error handling with status code checks
- Added logging for debugging
- Uses `ApiEndpoints` constants
- Follows DioException pattern
- Added `getLocations` method for fetching locations

### 3. Category Repository
**File:** `lib/core/data/repositories/category_repository.dart`
- Added proper error handling
- Added logging
- Uses `ApiEndpoints` constants
- Follows DioException pattern

### 4. Billboard Provider
**File:** `lib/features/billboard/logic/billboard_provider.dart`
- Updated to call `createLocation` instead of `uploadBillboard`

## Key Patterns

### Error Handling
1. Catch `DioException` for HTTP errors
2. Extract status code and response data
3. Provide user-friendly error messages
4. Log errors for debugging
5. Rethrow as `Exception` with message

### Logging
- Use `dart:developer` log function
- Log action start with parameters
- Log success/failure
- Log status codes and error data

### API Client Usage
- Use `apiClient.post()` for POST requests
- Use `apiClient.get()` for GET requests
- Pass `data` parameter for request body
- Pass `query` parameter for query strings
- Access response via `response.data`

### Response Handling
- Check `response.data['success']`
- Extract payload from `response.data['payload']`
- Parse into models/types
- Throw exception if not successful

## Benefits
- Consistent error handling across repositories
- Better debugging with logs
- User-friendly error messages
- Centralized endpoint management
- Type-safe API calls
