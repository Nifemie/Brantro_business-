import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../data/models/social_account_model.dart';
import '../data/repositories/social_account_repository.dart';

class SocialAccountNotifier extends StateNotifier<DataState<SocialAccountModel>> {
  final SocialAccountRepository repository;

  SocialAccountNotifier(this.repository) : super(DataState.initial()) {
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    state = state.resetMessage().copyWith(isInitialLoading: true);
    try {
      final accounts = await repository.fetchSocialAccounts();
      state = state.copyWith(
        data: accounts,
        isInitialLoading: false,
        isDataAvailable: accounts.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: e.toString(),
      );
    }
  }

  Future<void> addSocialAccount({
    required String platform,
    required String handle,
    required String profileUrl,
    required int followers,
    required bool isPrimary,
    required bool isActive,
  }) async {
    try {
      final newAccount = await repository.createSocialAccount(
        platform: platform,
        handle: handle,
        profileUrl: profileUrl,
        followers: followers,
        isPrimary: isPrimary,
        isActive: isActive,
      );
      
      final currentList = List<SocialAccountModel>.from(state.data ?? []);
      if (isPrimary) {
        // Map other accounts to false for isPrimary if this one is primary
        for (int i = 0; i < currentList.length; i++) {
          if (currentList[i].isPrimary) {
            currentList[i] = SocialAccountModel(
              id: currentList[i].id,
              userId: currentList[i].userId,
              platform: currentList[i].platform,
              handle: currentList[i].handle,
              profileUrl: currentList[i].profileUrl,
              followers: currentList[i].followers,
              isPrimary: false,
              isActive: currentList[i].isActive,
              createdAt: currentList[i].createdAt,
              updatedAt: currentList[i].updatedAt,
            );
          }
        }
      }
      currentList.add(newAccount);
      state = state.copyWith(
        data: currentList,
        isDataAvailable: true,
      );
    } catch (e) {
      state = state.copyWith(message: e.toString());
      rethrow;
    }
  }

  Future<void> deleteSocialAccount(int accountId) async {
    try {
      await repository.deleteSocialAccount(accountId);
      final currentList = List<SocialAccountModel>.from(state.data ?? []);
      currentList.removeWhere((account) => account.id == accountId);
      state = state.copyWith(
        data: currentList,
        isDataAvailable: currentList.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(message: e.toString());
      rethrow;
    }
  }
}
