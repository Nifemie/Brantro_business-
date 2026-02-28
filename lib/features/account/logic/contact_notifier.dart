import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/contact_repository.dart';
import '../data/models/contact_message_request.dart';
import '../data/models/contact_message_response.dart';

// Provider for ApiClient (reuse from auth if needed)
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// Provider for ContactRepository
final contactRepositoryProvider = Provider<ContactRepository>(
  (ref) => ContactRepository(ref.read(apiClientProvider)),
);

// StateNotifier for Contact
class ContactNotifier extends StateNotifier<DataState<ContactMessageResponse>> {
  final ContactRepository _repository;

  ContactNotifier(this._repository) : super(DataState.initial());

  /// Send contact message
  Future<void> sendMessage(ContactMessageRequest request) async {
    log('[ContactNotifier] Sending message...');
    
    // Set loading state
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      // Call repository to make API request
      final response = await _repository.sendMessage(request);

      // Update state with success
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        singleData: response,
        message: response.message,
      );

      log('[ContactNotifier] Message sent successfully: ${response.message}');
    } catch (e, stack) {
      // Update state with error
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );

      log('[ContactNotifier] Message send error: $e\n$stack');
    }
  }

  /// Clear any error messages
  void clearMessage() {
    state = state.copyWith(message: null);
  }

  /// Reset state to initial
  void reset() {
    state = DataState.initial();
  }
}

// Provider for ContactNotifier
final contactNotifierProvider =
    StateNotifierProvider<ContactNotifier, DataState<ContactMessageResponse>>(
  (ref) => ContactNotifier(ref.read(contactRepositoryProvider)),
);
