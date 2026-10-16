import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../core/widgets/media_details_screen.dart';
import '../../../../../core/utils/html_helper.dart';
import '../../../data/models/service_model.dart';

class ServiceDetailsScreen extends ConsumerWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleanDescription = HtmlHelper.stripHtml(service.description);
    
    // Combine explicit features and parsed specifications
    final List<String> displayFeatures = [];
    if (service.features.isNotEmpty) {
      displayFeatures.addAll(service.features);
    }
    final parsedSpecs = HtmlHelper.parseHtmlList(service.specifications);
    if (parsedSpecs.isNotEmpty) {
      displayFeatures.addAll(parsedSpecs);
    }
    if (displayFeatures.isEmpty) {
      displayFeatures.addAll(const ['Professional Delivery', 'High Quality']);
    }

    // Combine thumbnail and gallery images
    final List<String> allImages = [];
    if (service.thumbnail.isNotEmpty) {
      allImages.add(service.thumbnail);
    }
    allImages.addAll(service.gallery);

    final createdDateStr = DateFormat('MM/dd/yyyy, h:mm:ss a').format(service.createdAt);

    return MediaDetailsScreen(
      id: service.id,
      type: 'service',
      name: service.title,
      location: service.coverageAreas.isNotEmpty
          ? service.coverageAreas.join(', ')
          : 'Remote Deliverable',
      description: cleanDescription.isNotEmpty ? cleanDescription : 'No description available.',
      features: displayFeatures,
      category: service.type.isNotEmpty
          ? service.type.replaceAll('_', ' ')
          : 'Digital Service',
      totalSlots: 0,
      bookedSlots: 0,
      createdDate: createdDateStr,
      isActive: service.status == 'ACTIVE',
      images: allImages,
      ownerName: service.ownerName ?? 'Service Provider',
      ownerBadge: service.ownerRole ?? 'CREATOR',
      ownerEmail: service.ownerEmail ?? 'services@brantro.com',
      ownerPhone: service.ownerPhone ?? '08000000000',
      ownerAddress: service.ownerAddress ?? 'Remote Deliverable',
      ownerLocation: service.ownerAddress ?? 'Remote Deliverable',
    );
  }
}
