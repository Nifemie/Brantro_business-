import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class HostFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'Host';
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    return [
      {'name': 'businessName', 'label': 'Business Name', 'type': 'text', 'hint': 'Enter business name', 'required': true},
      {'name': 'permitNumber', 'label': 'Permit Number', 'type': 'text', 'hint': 'e.g., PERMIT2024001', 'required': true},
      {'name': 'businessAddress', 'label': 'Business Address', 'type': 'text', 'hint': 'Enter business address', 'required': true},
      {'name': 'businessWebsite', 'label': 'Business Website (Optional)', 'type': 'text', 'hint': 'https://yourcompany.com'},
      {'name': 'industry', 'label': 'Industry', 'type': 'dropdown', 'hint': 'Select industry', 'options': HOST_INDUSTRY_OPTIONS, 'required': true},
      {'name': 'operatingCities', 'label': 'Operating Cities', 'type': 'multiselect', 'hint': 'Select operating cities', 'options': OPERATING_REGIONS_OPTIONS, 'required': true},
      {'name': 'yearsOfOperation', 'label': 'Years of Operation (Optional)', 'type': 'dropdown', 'hint': 'Select years of operation', 'options': YEARS_OF_EXPERIENCE_OPTIONS},
      {'name': 'idType', 'label': 'ID Type', 'type': 'dropdown', 'hint': 'Select ID Type', 'options': ID_TYPE_OPTIONS, 'required': true},
      {'name': 'idNumber', 'label': 'ID Number', 'type': 'text', 'hint': 'Enter ID Number', 'required': true},
      {'name': 'tinNumber', 'label': 'TIN Number', 'type': 'text', 'hint': 'Enter TIN Number', 'required': true},
    ];
  }
}
