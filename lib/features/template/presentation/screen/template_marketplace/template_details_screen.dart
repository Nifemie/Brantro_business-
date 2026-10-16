import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/widgets/media_details_screen.dart';
import '../../../../../core/utils/html_helper.dart';
import '../../../data/models/template_model.dart';

class TemplateDetailsScreen extends ConsumerWidget {
  final TemplateModel template;

  const TemplateDetailsScreen({
    super.key,
    required this.template,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleanDescription = HtmlHelper.stripHtml(template.description);

    final List<String> displayFeatures = [];
    if (template.features.isNotEmpty) {
      displayFeatures.addAll(template.features);
    }
    final parsedSpecs = HtmlHelper.parseHtmlList(template.specifications);
    if (parsedSpecs.isNotEmpty) {
      displayFeatures.addAll(parsedSpecs);
    }
    if (displayFeatures.isEmpty) {
      displayFeatures.addAll(const ['Layered File', 'High Resolution']);
    }

    return MediaDetailsScreen(
      id: template.id,
      type: 'template',
      name: template.name,
      location: 'Digital Asset / Online Deliverable',
      description: cleanDescription.isNotEmpty ? cleanDescription : 'No description available.',
      features: displayFeatures,
      category: 'Design Template',
      totalSlots: 0,
      bookedSlots: 0,
      createdDate: '15/06/2026, 12:00:00 PM',
      isActive: template.isActive,
      images: [template.image],
      ownerName: template.ownerName,
      ownerBadge: template.ownerBadge,
      ownerEmail: template.ownerEmail,
      ownerPhone: template.ownerPhone,
      ownerAddress: template.ownerAddress,
      ownerLocation: template.ownerLocation,
    );
  }
}
