import 'dart:developer';
import 'models/template_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';

class TemplateRepository {
  final ApiClient _apiClient;

  TemplateRepository(this._apiClient);

  /// Fetch all templates
  Future<List<TemplateModel>> fetchTemplates({
    int page = 0,
    int size = 20,
  }) async {
    try {
      log('[TemplateRepository] Fetching templates: page=$page, size=$size');
      
      final response = await _apiClient.get(
        ApiEndpoints.templateList,
        query: {
          'page': page,
          'size': size,
        },
      );

      log('[TemplateRepository] Templates response received: ${response.statusCode}');
      log('[TemplateRepository] Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['payload'] != null) {
          final List<dynamic> templateList = data['payload']['page'] ?? [];
          log('[TemplateRepository] Successfully parsed ${templateList.length} templates');
          return templateList
              .map((json) => TemplateModel.fromJson(json))
              .toList();
        } else {
          log('[TemplateRepository] Template fetch failed: ${data['message']}');
          throw Exception(data['message'] ?? 'Failed to load templates');
        }
      } else {
        log('[TemplateRepository] Failed with status code: ${response.statusCode}');
        throw Exception('Failed to load templates: ${response.statusCode}');
      }
    } catch (e) {
      log('[TemplateRepository] Error: $e');
      throw Exception('Error fetching templates: $e');
    }
  }

  /// Get template details by ID
  Future<TemplateModel> getTemplateById(String id) async {
    try {
      log('[TemplateRepository] Fetching template details for id=$id');
      
      final response = await _apiClient.get(
        '${ApiEndpoints.templateDetails}/$id',
      );

      log('[TemplateRepository] Template details response received: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['payload'] != null) {
          log('[TemplateRepository] Successfully parsed template details');
          return TemplateModel.fromJson(data['payload']);
        } else {
          log('[TemplateRepository] Template not found: ${data['message']}');
          throw Exception(data['message'] ?? 'Template not found');
        }
      } else {
        log('[TemplateRepository] Failed with status code: ${response.statusCode}');
        throw Exception('Failed to load template: ${response.statusCode}');
      }
    } catch (e) {
      log('[TemplateRepository] Error: $e');
      throw Exception('Error fetching template details: $e');
    }
  }
}
