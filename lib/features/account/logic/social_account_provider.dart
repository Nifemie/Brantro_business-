import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/data/data_state.dart';
import '../data/models/social_account_model.dart';
import '../data/repositories/social_account_repository.dart';
import 'social_account_notifier.dart';

final socialAccountRepositoryProvider = Provider<SocialAccountRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SocialAccountRepository(apiClient);
});

final socialAccountProvider =
    StateNotifierProvider<SocialAccountNotifier, DataState<SocialAccountModel>>((ref) {
  final repository = ref.watch(socialAccountRepositoryProvider);
  return SocialAccountNotifier(repository);
});
