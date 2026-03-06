import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for managing bottom navigation state
final dashboardNavigationProvider = StateProvider<int>((ref) => 0);

// Provider for managing analytics filter tab state
final analyticsFilterProvider = StateProvider<int>((ref) => 0);
