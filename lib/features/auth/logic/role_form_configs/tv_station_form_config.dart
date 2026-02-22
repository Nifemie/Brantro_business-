import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class TVStationFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'TV Station';
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    return [
      {'name': 'businessName', 'label': 'TV Station Name', 'type': 'text', 'hint': 'Enter station name', 'required': true},
      {'name': 'businessAddress', 'label': 'Business Address', 'type': 'text', 'hint': 'Enter business address', 'required': true},
      {'name': 'rcNumber', 'label': 'RC Number', 'type': 'text', 'hint': 'e.g., RC123456', 'required': true},
      {'name': 'tinNumber', 'label': 'TIN Number', 'type': 'text', 'hint': 'Enter your Tax Identification Number', 'required': true},
      {'name': 'contactPhone', 'label': 'Telephone Number', 'type': 'text', 'hint': '+234XXXXXXXXXX', 'required': true},
      {'name': 'businessWebsite', 'label': 'Website (Optional)', 'type': 'text', 'hint': 'https://yourwebsite.com'},
      {'name': 'broadcastType', 'label': 'Broadcast Type', 'type': 'dropdown', 'hint': 'Select broadcast type', 'options': TV_BROADCAST_TYPE_OPTIONS, 'required': true},
      {'name': 'channelType', 'label': 'Channel Type', 'type': 'dropdown', 'hint': 'Select channel type', 'options': TV_CHANNEL_TYPE_OPTIONS, 'required': true},
      {'name': 'operatingRegions', 'label': 'Operating Regions', 'type': 'multiselect', 'hint': 'Select operating regions', 'options': OPERATING_REGIONS_OPTIONS, 'required': true},
      {'name': 'contentFocus', 'label': 'Content Focus', 'type': 'multiselect', 'hint': 'Select content focus', 'options': TV_CONTENT_FOCUS_OPTIONS, 'required': true},
      {'name': 'yearsOfOperation', 'label': 'Years of Operation (Optional)', 'type': 'dropdown', 'hint': 'Select years of operation', 'options': YEARS_OF_EXPERIENCE_OPTIONS},
      {'name': 'averageDailyViewership', 'label': 'Average Daily Viewership (Optional)', 'type': 'text', 'hint': 'e.g., 2000000'},
    ];
  }
}
