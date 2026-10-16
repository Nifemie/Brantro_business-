import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/media_details_screen.dart';
import '../../../../core/utils/html_helper.dart';
import '../../data/models/billboard_model.dart';

class BillboardDetailsScreen extends ConsumerWidget {
  final BillboardModel billboard;

  const BillboardDetailsScreen({
    super.key,
    required this.billboard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleanDescription = HtmlHelper.stripHtml(billboard.description);
    final cleanFeatures = HtmlHelper.parseHtmlList(billboard.featuresText);
    
    // Combine thumbnail and gallery images
    final List<String> allImages = [];
    if (billboard.thumbnail.isNotEmpty) {
      allImages.add(billboard.thumbnail);
    }
    allImages.addAll(billboard.images);

    final createdDateStr = DateFormat('MM/dd/yyyy, h:mm:ss a').format(billboard.createdAt);

    return MediaDetailsScreen(
      id: billboard.id,
      type: 'billboard',
      name: billboard.name,
      location: billboard.address,
      description: cleanDescription.isNotEmpty ? cleanDescription : 'No description available.',
      features: cleanFeatures.isNotEmpty ? cleanFeatures : ['Premium Location', 'High Visibility'],
      category: billboard.type.isNotEmpty ? billboard.type : 'Billboard',
      totalSlots: billboard.totalAdSlots ?? 0,
      bookedSlots: 0, 
      createdDate: createdDateStr,
      isActive: billboard.isActive,
      images: allImages,
      blockedDates: billboard.blockedDates,
      ownerName: billboard.ownerName ?? 'Brantro Africa',
      ownerBadge: 'HOST',
      ownerEmail: billboard.ownerEmail ?? 'superadmin@brantro.com',
      ownerPhone: billboard.ownerPhone ?? '08000000000',
      ownerAddress: billboard.ownerAddress ?? 'Syril Ihesaba Court, Gwarinpa',
      ownerLocation: billboard.ownerAddress ?? 'Syril Ihesaba Court, Gwarinpa, Abuja, FCT, Nigeria',
    );
  }
}
