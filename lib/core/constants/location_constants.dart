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

class LocationHelper {
  LocationHelper._();

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

