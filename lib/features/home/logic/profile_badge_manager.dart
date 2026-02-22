import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../template/logic/purchased_templates_notifier.dart';
import '../../creatives/logic/purchased_creatives_notifier.dart';
import '../../vetting/logic/vetting_notifier.dart';
import '../../Digital_services/logic/purchased_services_notifier.dart';

/// Manages badge counts for profile menu items
class ProfileBadgeManager {
  final WidgetRef ref;

  ProfileBadgeManager(this.ref);

  /// Preload all badge counts on app start
  void preloadBadgeCounts() {
    // Fetch purchased templates
    Future.microtask(() {
      ref.read(purchasedTemplatesProvider.notifier).fetchPurchasedTemplates(refresh: true);
    });
    
    // Fetch purchased creatives
    Future.microtask(() {
      ref.read(purchasedCreativesProvider.notifier).fetchPurchasedCreatives(refresh: true);
    });
    
    // Fetch vetting options
    Future.microtask(() {
      ref.read(vettingProvider.notifier).fetchVettingOptions(page: 0, size: 100);
    });
    
    // Fetch purchased services
    Future.microtask(() {
      ref.read(purchasedServicesProvider.notifier).fetchPurchasedServices(refresh: true);
    });
  }

  /// Get templates count
  int getTemplatesCount() {
    final templatesAsync = ref.watch(purchasedTemplatesProvider);
    return templatesAsync.asData?.value?.page.length ?? 0;
  }

  /// Get creatives count
  int getCreativesCount() {
    final creativesAsync = ref.watch(purchasedCreativesProvider);
    return creativesAsync.asData?.value?.page.length ?? 0;
  }

  /// Get vetting count
  int getVettingCount() {
    final vettingState = ref.watch(vettingProvider);
    return vettingState.data?.length ?? 0;
  }

  /// Get services count
  int getServicesCount() {
    final servicesAsync = ref.watch(purchasedServicesProvider);
    return servicesAsync.asData?.value?.page.fold<int>(
      0, 
      (sum, order) => sum + order.items.length
    ) ?? 0;
  }
}
