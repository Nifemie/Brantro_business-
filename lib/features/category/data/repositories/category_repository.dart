import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:brantro_business/core/network/api_client.dart';
import 'package:brantro_business/core/constants/endpoints.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final ApiClient apiClient;

  CategoryRepository(this.apiClient);

  Future<List<CategoryModel>> getCategories({
    int page = 0,
    int size = 100,
    String? type,
  }) async {
    try {
      log('[CategoryRepository] Fetching categories: page=$page, size=$size, type=$type');

      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
      };

      final response = await apiClient.get(
        ApiEndpoints.categoryList,
        query: queryParams,
      );

      log('[CategoryRepository] Categories fetched successfully');

      if (response.data['success'] == true) {
        final List<dynamic> pageData = response.data['payload']['page'] as List;
        final categories = pageData
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Filter by type if specified
        if (type != null) {
          return categories.where((cat) => cat.type == type).toList();
        }

        return categories;
      }

      throw Exception(response.data['message'] ?? 'Failed to fetch categories');
    } on DioException catch (e) {
      log('[CategoryRepository] Fetch categories FAILED: ${e.message}');
      
      final errorMessage = e.response?.data?['message'] ?? 
                          e.response?.data?['error'] ?? 
                          'Failed to fetch categories. Please try again.';
      
      throw Exception(errorMessage);
    } catch (e) {
      log('[CategoryRepository] Unexpected Error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<CategoryModel>> getLocationCategories() async {
    return getCategories(type: 'LOCATION');
  }

  Future<List<CategoryModel>> getTemplateCategories() async {
    return getCategories(type: 'TEMPLATE');
  }
}
