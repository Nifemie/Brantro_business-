import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'service_card.dart';

class ServiceList extends StatelessWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context) {
    // We render a list of cards.
    final mockServices = [
      {
        'title': 'Brand Identity & Visual Style Guide',
        'category': 'Brand Guidelines',
        'price': '₦70,000',
        'priceUnit': '/ Per Project',
        'isActive': true,
        'imageUrl': 'assets/promotions/brand_identity.png',
        'tags': ['#branding', '#brand identity', '#style guide'],
      },
      {
        'title': 'Social Media Post & Banner Design',
        'category': 'Banner Design',
        'price': '₦15,000',
        'priceUnit': '/ Per Design',
        'isActive': true,
        'imageUrl': 'assets/promotions/social_media_banner.png',
        'tags': ['#social media design', '#banner', '#instagram pos...'],
      },
      {
        'title': 'Professional Logo Design',
        'category': 'Logo Design',
        'price': '₦25,000',
        'priceUnit': '/ Per Design',
        'isActive': true,
        'imageUrl': 'assets/promotions/logo_design.png',
        'tags': ['#logo', '#branding', '#graphic design'],
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: mockServices.length,
      itemBuilder: (context, index) {
        final service = mockServices[index];
        return ServiceCard(
          title: service['title'] as String,
          category: service['category'] as String,
          deliveryTime: '', // Not shown on this specific card
          price: service['price'] as String,
          priceUnit: service['priceUnit'] as String,
          isActive: service['isActive'] as bool,
          imageUrl: service['imageUrl'] as String,
          tags: service['tags'] as List<String>,
          onViewDetails: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Viewing Orders for ${service['title']}')),
            );
          },
        );
      },
    );
  }
}
