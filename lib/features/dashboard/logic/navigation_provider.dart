import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to track the current active navigation item
final activeNavigationProvider = StateProvider<String>((ref) => 'Dashboard');
