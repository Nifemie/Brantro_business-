import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/widgets/media_details_screen.dart';
import '../../../../../core/utils/html_helper.dart';
import '../../../data/models/creative_model.dart';

class CreativeDetailsScreen extends ConsumerWidget {
  final CreativeModel creative;

  const CreativeDetailsScreen({
    super.key,
    required this.creative,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleanDescription = HtmlHelper.stripHtml(creative.description);

    final List<String> displayFeatures = [];
    if (creative.features.isNotEmpty) {
      displayFeatures.addAll(creative.features);
    }
    final parsedSpecs = HtmlHelper.parseHtmlList(creative.specifications);
    if (parsedSpecs.isNotEmpty) {
      displayFeatures.addAll(parsedSpecs);
    }
    if (displayFeatures.isEmpty) {
      displayFeatures.addAll(const ['Standard Format', 'High Resolution']);
    }

    return MediaDetailsScreen(
      id: creative.id,
      type: 'creative',
      name: creative.name,
      location: 'Digital Asset / Remote Delivery',
      description: cleanDescription.isNotEmpty ? cleanDescription : 'No description available.',
      features: displayFeatures,
      category: creative.type.isNotEmpty ? creative.type : 'Creative Services',
      totalSlots: 0,
      bookedSlots: 0,
      createdDate: '15/06/2026, 12:00:00 PM',
      isActive: creative.isActive,
      images: [creative.image],
      ownerName: creative.ownerName,
      ownerBadge: creative.ownerBadge,
      ownerEmail: creative.ownerEmail,
      ownerPhone: creative.ownerPhone,
      ownerAddress: creative.ownerAddress,
      ownerLocation: creative.ownerLocation,
    );
  }
}
