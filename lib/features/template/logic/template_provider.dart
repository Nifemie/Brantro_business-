import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/data/data_state.dart';
import 'package:brantro_business/core/network/api_client.dart';
import '../data/repositories/template_repository.dart';
import '../data/models/template_model.dart';
import 'template_notifier.dart';

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TemplateRepository(apiClient);
});

final templateProvider = StateNotifierProvider<TemplateNotifier, DataState<TemplateModel>>((ref) {
  final repository = ref.watch(templateRepositoryProvider);
  return TemplateNotifier(repository);
});
