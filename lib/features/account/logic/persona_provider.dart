import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Active persona filter for multi-role users.
/// null = All Roles (Unified Mode), otherwise 'HOST', 'INFLUENCER', 'CREATOR', 'ARTIST', etc.
final activePersonaProvider = StateProvider<String?>((ref) => null);

class PersonaHelper {
  static String formatPersonaName(String? persona) {
    if (persona == null || persona.isEmpty || persona.toUpperCase() == 'ALL') {
      return 'All Personas';
    }
    switch (persona.toUpperCase()) {
      case 'HOST':
        return 'Host';
      case 'INFLUENCER':
        return 'Influencer';
      case 'CREATOR':
      case 'CREATIVE':
        return 'Creator';
      case 'DESIGNER':
        return 'Designer';
      case 'ARTIST':
        return 'Artist';
      case 'PRODUCER':
        return 'Producer';
      case 'TV_STATION':
        return 'TV Station';
      case 'RADIO_STATION':
        return 'Radio Station';
      case 'MEDIA_HOUSE':
        return 'Media House';
      case 'UGC_CREATOR':
        return 'UGC Creator';
      default:
        return persona.replaceAll('_', ' ');
    }
  }
}
