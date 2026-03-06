import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/media_details_screen.dart';
import '../../data/models/wall_model.dart';

class WallDetailsScreen extends ConsumerWidget {
  final WallModel wall;

  const WallDetailsScreen({
    super.key,
    required this.wall,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MediaDetailsScreen(
      id: wall.id,
      type: 'wall',
      name: wall.name,
      location: wall.address,
      description: 'Premium indoor wall space in high-traffic shopping mall, perfect for brand visibility and customer engagement.',
      features: ['Indoor wall', 'mall visibility', 'high footfall', 'premium location'],
      category: 'Indoor Wall',
      totalSlots: 0, // TODO: Get from actual data
      bookedSlots: 0, // TODO: Get from actual data
      createdDate: '2/11/2026, 3:26:01 PM',
      isActive: wall.isActive,
      images: wall.images,
      ownerName: 'Brantro Africa',
      ownerBadge: 'SUPER_ADMIN',
      ownerEmail: 'superadmin@brantro.com',
      ownerPhone: '08000000000',
      ownerAddress: 'Syril Ihesaba Court, Gwarinpa',
      ownerLocation: 'Syril Ihesaba Court, Gwarinpa, Abuja, FCT, Nigeria',
    );
  }
}
