import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class RadioStationFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'Radio Station';
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    return [
      {'name': 'businessName', 'label': 'Radio Station Name', 'type': 'text', 'hint': 'Enter station name', 'required': true},
      {'name': 'businessAddress', 'label': 'Business Address', 'type': 'text', 'hint': 'Enter business address', 'required': true},
      {'name': 'rcNumber', 'label': 'RC Number', 'type': 'text', 'hint': 'e.g., RC456789', 'required': true},
      {'name': 'tinNumber', 'label': 'TIN Number', 'type': 'text', 'hint': 'Enter your Tax Identification Number', 'required': true},
      {'name': 'contactPhone', 'label': 'Contact Phone', 'type': 'text', 'hint': '+234XXXXXXXXXX', 'required': true},
      {'name': 'businessWebsite', 'label': 'Website (Optional)', 'type': 'text', 'hint': 'https://yourwebsite.com'},
      {'name': 'broadcastBand', 'label': 'Broadcast Band', 'type': 'dropdown', 'hint': 'Select broadcast band', 'options': RADIO_BROADCAST_BAND_OPTIONS, 'required': true},
      {'name': 'primaryLanguage', 'label': 'Primary Language', 'type': 'dropdown', 'hint': 'Select primary language', 'options': LANGUAGE_OPTIONS, 'required': true},
      {'name': 'operatingRegions', 'label': 'Operating Regions', 'type': 'multiselect', 'hint': 'Select operating regions', 'options': OPERATING_REGIONS_OPTIONS, 'required': true},
      {'name': 'contentFocus', 'label': 'Content Focus', 'type': 'multiselect', 'hint': 'Select content focus', 'options': RADIO_CONTENT_FOCUS_OPTIONS, 'required': true},
      {'name': 'yearsOfOperation', 'label': 'Years of Operation (Optional)', 'type': 'dropdown', 'hint': 'Select years of operation', 'options': YEARS_OF_EXPERIENCE_OPTIONS},
      {'name': 'averageDailyListenership', 'label': 'Average Daily Listenership (Optional)', 'type': 'text', 'hint': 'e.g., 500000'},
    ];
  }
}
