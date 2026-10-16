import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro_business/core/network/api_client.dart';
import '../data/models/faq_model.dart';
import '../data/repositories/faq_repository.dart';

class FaqState {
  final List<FaqModel> faqs;
  final bool isLoading;
  final String? error;

  FaqState({
    this.faqs = const [],
    this.isLoading = false,
    this.error,
  });

  FaqState copyWith({
    List<FaqModel>? faqs,
    bool? isLoading,
    String? error,
  }) {
    return FaqState(
      faqs: faqs ?? this.faqs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FaqNotifier extends StateNotifier<FaqState> {
  final FaqRepository repository;

  FaqNotifier(this.repository) : super(FaqState()) {
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await repository.getFaqs(page: 0, size: 50);
      final List<dynamic> pageList = response['page'] ?? [];
      final List<FaqModel> faqs = pageList.map((item) => FaqModel.fromJson(item)).toList();

      state = state.copyWith(faqs: faqs, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addFaq(String title, String answer) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final newFaq = FaqModel(
        id: 'faq_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        answer: answer,
        createdAt: DateTime.now(),
      );
      state = state.copyWith(
        faqs: [newFaq, ...state.faqs],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> deleteFaq(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      state = state.copyWith(
        faqs: state.faqs.where((faq) => faq.id != id).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }
}

final faqRepositoryProvider = Provider<FaqRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FaqRepository(apiClient);
});

final faqProvider = StateNotifierProvider<FaqNotifier, FaqState>((ref) {
  final repository = ref.watch(faqRepositoryProvider);
  return FaqNotifier(repository);
});
