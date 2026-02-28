import 'package:flutter/material.dart';

/// Role information including description and icon
class RoleInfo {
  final String name;
  final String description;
  final IconData icon;

  const RoleInfo({
    required this.name,
    required this.description,
    required this.icon,
  });
}

/// All available roles with their information
const Map<String, RoleInfo> ROLE_INFORMATION = {
  'Advertiser': RoleInfo(
    name: 'Advertiser',
    description:
        'Discover, compare, and book advertising across multiple channels.',
    icon: Icons.campaign,
  ),
  'Artist': RoleInfo(
    name: 'Artist',
    description:
        'Showcase your talents and connect with opportunities and fans.',
    icon: Icons.music_note,
  ),
  'Screen / Billboard': RoleInfo(
    name: 'Screen / Billboard',
    description: 'Manage and monetize your outdoor advertising spaces.',
    icon: Icons.image,
  ),
  'Content Producer': RoleInfo(
    name: 'Content Producer',
    description: 'Create, produce, and distribute high-quality content.',
    icon: Icons.videocam,
  ),
  'Influencer': RoleInfo(
    name: 'Influencer',
    description: 'Build your influence and collaborate with brands.',
    icon: Icons.person_add,
  ),
  'UGC Creator': RoleInfo(
    name: 'UGC Creator',
    description: 'Create authentic user-generated content for brands.',
    icon: Icons.create,
  ),
  'Host': RoleInfo(
    name: 'Host',
    description: 'Provide spaces and venues for events and promotions.',
    icon: Icons.home,
  ),
  'TV Station': RoleInfo(
    name: 'TV Station',
    description: 'Manage and broadcast television content and advertising.',
    icon: Icons.tv,
  ),
  'Radio Station': RoleInfo(
    name: 'Radio Station',
    description: 'Operate and monetize radio broadcasting services.',
    icon: Icons.radio,
  ),
  'Media House': RoleInfo(
    name: 'Media House',
    description: 'Publish content across multiple media platforms.',
    icon: Icons.newspaper,
  ),
  'Creatives': RoleInfo(
    name: 'Creatives',
    description: 'Showcase your creative work and collaborate with brands.',
    icon: Icons.brush,
  ),
  'Designer': RoleInfo(
    name: 'Designer',
    description: 'Offer creative design services and portfolio showcase.',
    icon: Icons.palette,
  ),
  'Talent Manager': RoleInfo(
    name: 'Talent Manager',
    description: 'Manage and represent talent across various industries.',
    icon: Icons.people,
  ),
};
