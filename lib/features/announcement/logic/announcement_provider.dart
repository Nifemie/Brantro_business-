import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/announcement_model.dart';

class AnnouncementState {
  final List<AnnouncementModel> announcements;
  final bool isLoading;
  final String? error;

  AnnouncementState({
    this.announcements = const [],
    this.isLoading = false,
    this.error,
  });

  AnnouncementState copyWith({
    List<AnnouncementModel>? announcements,
    bool? isLoading,
    String? error,
  }) {
    return AnnouncementState(
      announcements: announcements ?? this.announcements,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AnnouncementNotifier extends StateNotifier<AnnouncementState> {
  AnnouncementNotifier() : super(AnnouncementState());

  Future<void> fetchAnnouncements() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Mock delay
      await Future.delayed(const Duration(milliseconds: 600));
      // Return empty initially as requested
      state = state.copyWith(announcements: [], isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addAnnouncement({
    required String title,
    required String audience,
    String? category,
    String? actionText,
    String? actionUrl,
    required String description,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final newAnnouncement = AnnouncementModel(
        id: 'ann_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        audience: audience,
        category: category,
        actionText: actionText,
        actionUrl: actionUrl,
        description: description,
        createdAt: DateTime.now(),
      );
      state = state.copyWith(
        announcements: [newAnnouncement, ...state.announcements],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      state = state.copyWith(
        announcements: state.announcements.where((ann) => ann.id != id).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }
}

final announcementProvider =
    StateNotifierProvider<AnnouncementNotifier, AnnouncementState>((ref) {
  return AnnouncementNotifier();
});
