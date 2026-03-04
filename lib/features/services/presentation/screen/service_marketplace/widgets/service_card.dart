import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'service_card_banner.dart';
import 'service_card_details.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String category;
  final String
  deliveryTime; // Keeping for compatibility with ServiceList mock data
  final String price;
  final String priceUnit;
  final bool isActive;
  final String imageUrl;
  final List<String> tags;
  final VoidCallback onViewDetails;

  const ServiceCard({
    super.key,
    required this.title,
    required this.category,
    required this.deliveryTime,
    required this.price,
    this.priceUnit = '/ Per Project',
    this.isActive = true,
    required this.imageUrl,
    required this.tags,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2D333B) : Colors.white;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServiceCardBanner(
            imageUrl: imageUrl,
            category: category,
            isDark: isDark,
          ),
          ServiceCardDetails(
            title: title,
            price: price,
            priceUnit: priceUnit,
            tags: tags,
            onViewDetails: onViewDetails,
          ),
        ],
      ),
    );
  }
}
