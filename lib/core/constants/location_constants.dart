/// Location Helper for Nigerian States and LGAs
/// This file provides utilities for location selection throughout the app.
/// 
/// Uses the nigerian_states_and_lga package for Nigerian locations
/// and country_picker for international country selection.
/// 
/// Usage:
/// 1. Use CountryPicker for country selection
/// 2. Use NigerianStatesAndLGA for Nigerian states and LGAs
/// 3. Use LocationHelper methods for programmatic access

import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';

class LocationHelper {
  LocationHelper._();

  /// Safe method to get LGAs for any Nigerian state, including FCT/Abuja
  static List<String> getLGAsForState(String state) {
    final cleanState = state.trim();
    if (cleanState.isEmpty) return [];

    final lower = cleanState.toLowerCase();
    if (lower == 'fct' ||
        lower.contains('abuja') ||
        lower.contains('capital') ||
        lower == 'fct(abuja)') {
      return const [
        "Abaji",
        "Abuja Municipal",
        "Bwari",
        "Gwagwalada",
        "Kuje",
        "Kwali",
      ];
    }

    try {
      return NigerianStatesAndLGA.getStateLGAs(cleanState);
    } catch (_) {
      for (final s in NigerianStatesAndLGA.allStates) {
        if (s.toLowerCase() == lower) {
          try {
            return NigerianStatesAndLGA.getStateLGAs(s);
          } catch (_) {}
        }
      }
      return [];
    }
  }

  /// Get country code from country name
  static String? getCountryCode(String countryName) {
    final countryMap = {
      'Nigeria': 'NG',
      'Ghana': 'GH',
      'Kenya': 'KE',
      'South Africa': 'ZA',
      'United States': 'US',
      'United Kingdom': 'GB',
      'Canada': 'CA',
    };
    return countryMap[countryName];
  }

  /// Get country name from country code
  static String? getCountryName(String countryCode) {
    final codeMap = {
      'NG': 'Nigeria',
      'GH': 'Ghana',
      'KE': 'Kenya',
      'ZA': 'South Africa',
      'US': 'United States',
      'GB': 'United Kingdom',
      'CA': 'Canada',
    };
    return codeMap[countryCode];
  }
}

/// Legacy constants for backward compatibility
const List<Map<String, String>> COUNTRY_OPTIONS = [
  {"label": "Nigeria", "value": "Nigeria", "code": "NG"},
  {"label": "Ghana", "value": "Ghana", "code": "GH"},
  {"label": "Kenya", "value": "Kenya", "code": "KE"},
  {"label": "South Africa", "value": "South Africa", "code": "ZA"},
];

