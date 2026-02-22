import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class MediaHouseFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'Media House';
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    return [
      {'name': 'businessName', 'label': 'Media House Name', 'type': 'text', 'hint': 'Enter media house name', 'required': true},
      {'name': 'businessAddress', 'label': 'Business Address', 'type': 'text', 'hint': 'Enter business address', 'required': true},
      {'name': 'rcNumber', 'label': 'RC Number', 'type': 'text', 'hint': 'e.g., RC123456', 'required': true},
      {'name': 'tinNumber', 'label': 'TIN Number', 'type': 'text', 'hint': 'Enter your Tax Identification Number', 'required': true},
      {'name': 'contactPhone', 'label': 'Contact Phone', 'type': 'text', 'hint': '+234XXXXXXXXXX', 'required': true},
      {'name': 'businessWebsite', 'label': 'Website (Optional)', 'type': 'text', 'hint': 'https://yourwebsite.com'},
      {'name': 'operatingRegions', 'label': 'Operating Regions', 'type': 'multiselect', 'hint': 'Select operating regions', 'options': OPERATING_REGIONS_OPTIONS, 'required': true},
      {'name': 'mediaTypes', 'label': 'Media Types', 'type': 'multiselect', 'hint': 'Select media types', 'options': MEDIA_HOUSE_TYPE_OPTIONS, 'required': true},
      {'name': 'contentFocus', 'label': 'Content Focus', 'type': 'multiselect', 'hint': 'Select content focus', 'options': MEDIA_HOUSE_CONTENT_FOCUS_OPTIONS, 'required': true},
      {'name': 'yearsOfOperation', 'label': 'Years of Operation (Optional)', 'type': 'dropdown', 'hint': 'Select years of operation', 'options': YEARS_OF_EXPERIENCE_OPTIONS},
      {'name': 'estimatedMonthlyReach', 'label': 'Estimated Monthly Reach (Optional)', 'type': 'text', 'hint': 'e.g., 500000'},
    ];
  }
}
