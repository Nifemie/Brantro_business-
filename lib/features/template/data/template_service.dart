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
      final response = await _apiClient.get(
        ApiEndpoints.templateList,
        query: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['payload'] != null) {
          final List<dynamic> templateList = data['payload']['page'] ?? [];
          return templateList
              .map((json) => TemplateModel.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load templates');
        }
      } else {
        throw Exception('Failed to load templates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching templates: $e');
    }
  }

  /// Get template details by ID
  Future<TemplateModel> getTemplateById(String id) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.templateDetails}/$id',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['payload'] != null) {
          return TemplateModel.fromJson(data['payload']);
        } else {
          throw Exception(data['message'] ?? 'Template not found');
        }
      } else {
        throw Exception('Failed to load template: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching template details: $e');
    }
  }
}
