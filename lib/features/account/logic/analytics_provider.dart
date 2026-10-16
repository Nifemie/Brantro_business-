import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/analytics_repository.dart';
import '../data/models/user_analytics_model.dart';

final userAnalyticsProvider = FutureProvider.autoDispose<UserAnalyticsModel>((ref) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  return await repository.fetchUserAnalytics();
});
