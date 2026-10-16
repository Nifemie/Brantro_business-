import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/media_details_screen.dart';
import '../../../../core/utils/html_helper.dart';
import '../../data/models/screen_model.dart';

class ScreenDetailsScreen extends ConsumerWidget {
  final ScreenModel screen;

  const ScreenDetailsScreen({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleanDescription = HtmlHelper.stripHtml(screen.description);
    final cleanFeatures = HtmlHelper.parseHtmlList(screen.featuresText);
    
    // Combine thumbnail and gallery images
    final List<String> allImages = [];
    if (screen.thumbnail.isNotEmpty) {
      allImages.add(screen.thumbnail);
    }
    allImages.addAll(screen.images);

    final createdDateStr = DateFormat('MM/dd/yyyy, h:mm:ss a').format(screen.createdAt);

    return MediaDetailsScreen(
      id: screen.id,
      type: 'screen',
      name: screen.name,
      location: screen.address,
      description: cleanDescription.isNotEmpty ? cleanDescription : 'No description available.',
      features: cleanFeatures.isNotEmpty ? cleanFeatures : ['Digital Screen', 'HD Display'],
      category: screen.type.isNotEmpty ? screen.type : 'Screen',
      totalSlots: screen.totalAdSlots ?? 0,
      bookedSlots: 0,
      createdDate: createdDateStr,
      isActive: screen.isActive,
      images: allImages,
      blockedDates: screen.blockedDates,
      ownerName: screen.ownerName ?? 'Brantro Africa',
      ownerBadge: 'HOST',
      ownerEmail: screen.ownerEmail ?? 'superadmin@brantro.com',
      ownerPhone: screen.ownerPhone ?? '08000000000',
      ownerAddress: screen.ownerAddress ?? 'Syril Ihesaba Court, Gwarinpa',
      ownerLocation: screen.ownerAddress ?? 'Syril Ihesaba Court, Gwarinpa, Abuja, FCT, Nigeria',
    );
  }
}
