import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../logic/service_provider.dart';
import '../../../../data/models/service_model.dart';
import '../../../../../../core/network/api_client.dart';
import 'service_card.dart';

class ServiceList extends ConsumerWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceState = ref.watch(serviceProvider);
    final services = serviceState.data ?? [];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final priceFormatted = NumberFormat.currency(
          symbol: '₦',
          decimalDigits: 0,
        ).format(service.price);

        final String priceUnit = service.pricingUnit.isNotEmpty
            ? (service.pricingUnit.startsWith('/')
                ? service.pricingUnit
                : '/ ${service.pricingUnit}')
            : '/ Per Project';

        final imageUrl = service.thumbnail.isNotEmpty
            ? (service.thumbnail.startsWith('http')
                ? service.thumbnail
                : '${ApiClient.fileBaseUrl}/${service.thumbnail}')
            : '';

        final displayTags = service.tags.map((t) => t.startsWith('#') ? t : '#$t').toList();

        return ServiceCard(
          title: service.title,
          category: service.type.isNotEmpty ? service.type.replaceAll('_', ' ') : 'UGC Video',
          deliveryTime: '${service.deliveryTime} ${service.deliveryTimeUnit}',
          price: service.price,
          discount: service.discount,
          estimatedReach: service.estimatedReach,
          priceUnit: priceUnit,
          isActive: service.status == 'ACTIVE',
          imageUrl: imageUrl,
          tags: displayTags,
          onViewDetails: () {
            context.push('/service-details', extra: {'service': service});
          },
          onViewOrders: () {
            context.push('/orders', extra: {'serviceId': service.id});
          },
        );
      },
    );
  }
}
