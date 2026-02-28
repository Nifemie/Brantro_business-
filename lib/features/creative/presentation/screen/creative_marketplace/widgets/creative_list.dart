import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'creative_card.dart';
import 'creative_menu_sheet.dart';

class CreativeList extends StatelessWidget {
  const CreativeList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from API/Provider
    final mockCreatives = [
      {
        'bannerImage': 'assets/promotions/billboard1.jpg',
        'title': 'Liquid Logo Animation Loop',
        'category': 'VIDEO',
        'type': 'STANDARD',
        'duration': '10s',
        'size': '3.6MB',
        'isActive': true,
      },
      {
        'bannerImage': 'assets/promotions/billboard2.jpg',
        'title': 'Modern Brand Identity Kit',
        'category': 'DESIGN',
        'type': 'PREMIUM',
        'duration': '5 Files',
        'size': '12MB',
        'isActive': true,
      },
      {
        'bannerImage': 'assets/promotions/billboard3.jpg',
        'title': 'Social Media Content Pack',
        'category': 'DESIGN',
        'type': 'STANDARD',
        'duration': '20 Files',
        'size': '8.5MB',
        'isActive': false,
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: mockCreatives.length,
      itemBuilder: (context, index) {
        final creative = mockCreatives[index];
        return CreativeCard(
          bannerImage: creative['bannerImage'] as String,
          title: creative['title'] as String,
          category: creative['category'] as String,
          type: creative['type'] as String,
          duration: creative['duration'] as String,
          size: creative['size'] as String,
          isActive: creative['isActive'] as bool,
          onViewOrders: () {
            // TODO: Navigate to orders page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('View orders for ${creative['title']}')),
            );
          },
          onMenuTap: () {
            showCreativeMenuSheet(context, creative['title'] as String);
          },
        );
      },
    );
  }
}
