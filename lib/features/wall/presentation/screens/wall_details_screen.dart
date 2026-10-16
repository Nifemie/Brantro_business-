import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/media_details_screen.dart';
import '../../../../core/utils/html_helper.dart';
import '../../data/models/wall_model.dart';

class WallDetailsScreen extends ConsumerWidget {
  final WallModel wall;

  const WallDetailsScreen({
    super.key,
    required this.wall,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleanDescription = HtmlHelper.stripHtml(wall.description);
    final cleanFeatures = HtmlHelper.parseHtmlList(wall.featuresText);
    
    // Combine thumbnail and gallery images
    final List<String> allImages = [];
    if (wall.thumbnail.isNotEmpty) {
      allImages.add(wall.thumbnail);
    }
    allImages.addAll(wall.images);

    final createdDateStr = DateFormat('MM/dd/yyyy, h:mm:ss a').format(wall.createdAt);

    return MediaDetailsScreen(
      id: wall.id,
      type: 'wall',
      name: wall.name,
      location: wall.address,
      description: cleanDescription.isNotEmpty ? cleanDescription : 'No description available.',
      features: cleanFeatures.isNotEmpty ? cleanFeatures : ['Premium Location', 'High Visibility'],
      category: wall.type.isNotEmpty ? wall.type : 'Wall',
      totalSlots: wall.totalAdSlots ?? 0,
      bookedSlots: 0,
      createdDate: createdDateStr,
      isActive: wall.isActive,
      images: allImages,
      blockedDates: wall.blockedDates,
      ownerName: wall.ownerName ?? 'Brantro Africa',
      ownerBadge: 'HOST',
      ownerEmail: wall.ownerEmail ?? 'superadmin@brantro.com',
      ownerPhone: wall.ownerPhone ?? '08000000000',
      ownerAddress: wall.ownerAddress ?? 'Syril Ihesaba Court, Gwarinpa',
      ownerLocation: wall.ownerAddress ?? 'Syril Ihesaba Court, Gwarinpa, Abuja, FCT, Nigeria',
    );
  }
}
