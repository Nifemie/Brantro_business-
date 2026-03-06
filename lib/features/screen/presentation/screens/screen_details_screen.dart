import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/media_details_screen.dart';
import '../../data/models/screen_model.dart';

class ScreenDetailsScreen extends ConsumerWidget {
  final ScreenModel screen;

  const ScreenDetailsScreen({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MediaDetailsScreen(
      id: screen.id,
      type: 'screen',
      name: screen.name,
      location: screen.address,
      description: 'High-resolution digital screen with dynamic content display, perfect for engaging advertisements and brand promotions.',
      features: ['Digital screen', 'HD display', 'dynamic content', 'remote control'],
      category: 'Digital Screen',
      totalSlots: 0, // TODO: Get from actual data
      bookedSlots: 0, // TODO: Get from actual data
      createdDate: '2/11/2026, 3:26:01 PM',
      isActive: screen.isActive,
      images: screen.images,
      ownerName: 'Brantro Africa',
      ownerBadge: 'SUPER_ADMIN',
      ownerEmail: 'superadmin@brantro.com',
      ownerPhone: '08000000000',
      ownerAddress: 'Syril Ihesaba Court, Gwarinpa',
      ownerLocation: 'Syril Ihesaba Court, Gwarinpa, Abuja, FCT, Nigeria',
    );
  }
}
