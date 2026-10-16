import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/media_details_screen.dart';
import '../../../../core/utils/html_helper.dart';
import '../../data/models/vehicle_model.dart';

class VehicleDetailsScreen extends ConsumerWidget {
  final VehicleModel vehicle;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleanDescription = HtmlHelper.stripHtml(vehicle.description);
    final cleanFeatures = HtmlHelper.parseHtmlList(vehicle.featuresText);
    
    // Combine thumbnail and gallery images
    final List<String> allImages = [];
    if (vehicle.thumbnail.isNotEmpty) {
      allImages.add(vehicle.thumbnail);
    }
    allImages.addAll(vehicle.images);

    final createdDateStr = DateFormat('MM/dd/yyyy, h:mm:ss a').format(vehicle.createdAt);

    return MediaDetailsScreen(
      id: vehicle.id,
      type: 'vehicle',
      name: vehicle.name,
      location: vehicle.address,
      description: cleanDescription.isNotEmpty ? cleanDescription : 'No description available.',
      features: cleanFeatures.isNotEmpty ? cleanFeatures : ['Mobile Reach', 'High Visibility'],
      category: vehicle.type.isNotEmpty ? vehicle.type : 'Vehicle',
      totalSlots: vehicle.totalAdSlots ?? 0,
      bookedSlots: 0,
      createdDate: createdDateStr,
      isActive: vehicle.isActive,
      images: allImages,
      blockedDates: vehicle.blockedDates,
      ownerName: vehicle.ownerName ?? 'Brantro Africa',
      ownerBadge: 'HOST',
      ownerEmail: vehicle.ownerEmail ?? 'superadmin@brantro.com',
      ownerPhone: vehicle.ownerPhone ?? '08000000000',
      ownerAddress: vehicle.ownerAddress ?? 'Syril Ihesaba Court, Gwarinpa',
      ownerLocation: vehicle.ownerAddress ?? 'Syril Ihesaba Court, Gwarinpa, Abuja, FCT, Nigeria',
    );
  }
}
