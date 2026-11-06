import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/review_model.dart';
import '../data/models/review_stats_model.dart';
import '../data/review_repository.dart';

final userReviewStatsProvider = FutureProvider.autoDispose<ReviewStatsModel>((ref) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return await repo.fetchUserReviewStats();
});

final userReviewsProvider = FutureProvider.autoDispose<List<ReviewModel>>((ref) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return await repo.fetchUserReviews();
});

typedef TargetReviewKey = ({String type, dynamic id});

final targetReviewsProvider =
    FutureProvider.autoDispose.family<List<ReviewModel>, TargetReviewKey>((ref, key) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return await repo.fetchTargetReviews(targetType: key.type, targetId: key.id);
});
