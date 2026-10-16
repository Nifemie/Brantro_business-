import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/notification_repository.dart';
import 'notification_notifier.dart';
import 'notification_state.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationNotifier(repository);
});
