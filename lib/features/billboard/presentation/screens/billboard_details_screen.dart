import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/media_details_screen.dart';
import '../../data/models/billboard_model.dart';

class BillboardDetailsScreen extends ConsumerWidget {
  final BillboardModel billboard;

  const BillboardDetailsScreen({
    super.key,
    required this.billboard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MediaDetailsScreen(
      id: billboard.id,
      type: 'billboard',
      name: billboard.name,
      location: billboard.address,
      description: 'Large roadside digital screen facing Airport Road, capturing daily commuters and travelers.',
      features: ['Large-screen', 'roadside visibility', 'high traffic', '24/7 display'],
      category: 'Digital Screen',
      totalSlots: 0, // TODO: Get from actual data
      bookedSlots: 0, // TODO: Get from actual data
      createdDate: '2/11/2026, 3:26:01 PM',
      isActive: billboard.isActive,
      images: billboard.images,
      ownerName: 'Brantro Africa',
      ownerBadge: 'SUPER_ADMIN',
      ownerEmail: 'superadmin@brantro.com',
      ownerPhone: '08000000000',
      ownerAddress: 'Syril Ihesaba Court, Gwarinpa',
      ownerLocation: 'Syril Ihesaba Court, Gwarinpa, Abuja, FCT, Nigeria',
    );
  }
}
