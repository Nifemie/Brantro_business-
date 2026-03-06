import 'package:flutter/material.dart';

class OrderConfigHelper {
  static Map<String, dynamic> getServiceConfig(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'billboard':
        return {
          'label': 'Billboard',
          'icon': Icons.campaign_outlined,
          'color': const Color(0xFFFF6B6B),
        };
      case 'screen':
        return {
          'label': 'Digital Screen',
          'icon': Icons.tv_outlined,
          'color': const Color(0xFF4ECDC4),
        };
      case 'wall':
        return {
          'label': 'Advertisement Wall',
          'icon': Icons.wallpaper_outlined,
          'color': const Color(0xFFFFBE0B),
        };
      case 'template':
        return {
          'label': 'Template',
          'icon': Icons.style_outlined,
          'color': const Color(0xFF9B59B6),
        };
      case 'creative':
        return {
          'label': 'Creative',
          'icon': Icons.brush_outlined,
          'color': const Color(0xFFE74C3C),
        };
      case 'service':
        return {
          'label': 'Service',
          'icon': Icons.business_center_outlined,
          'color': const Color(0xFF3498DB),
        };
      case 'vetting':
        return {
          'label': 'Vetting',
          'icon': Icons.verified_outlined,
          'color': const Color(0xFF2ECC71),
        };
      default:
        return {
          'label': 'Other',
          'icon': Icons.shopping_bag_outlined,
          'color': Colors.grey,
        };
    }
  }

  static Map<String, dynamic> getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'label': 'PENDING',
          'color': const Color(0xFFF59E0B),
        };
      case 'active':
        return {
          'label': 'ACTIVE',
          'color': const Color(0xFF10B981),
        };
      case 'completed':
        return {
          'label': 'COMPLETED',
          'color': const Color(0xFF3B82F6),
        };
      case 'cancelled':
        return {
          'label': 'CANCELLED',
          'color': const Color(0xFFEF4444),
        };
      default:
        return {
          'label': status.toUpperCase(),
          'color': Colors.grey,
        };
    }
  }
}
