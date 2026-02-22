import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class BillboardFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'Screen / Billboard';
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    return [
      {'name': 'businessName', 'label': 'Business Name', 'type': 'text', 'hint': 'Enter business name', 'required': true},
      {'name': 'permitNumber', 'label': 'Permit Number', 'type': 'text', 'hint': 'Enter permit number', 'required': true},
      {'name': 'industry', 'label': 'Industry', 'type': 'dropdown', 'hint': 'Select industry', 'options': HOST_INDUSTRY_OPTIONS, 'required': true},
      {'name': 'operatingStates', 'label': 'Operating States', 'type': 'multiselect', 'hint': 'Select operating states', 'options': OPERATING_REGIONS_OPTIONS, 'required': true},
      {'name': 'yearsOfOperation', 'label': 'Years of Operation (Optional)', 'type': 'text', 'hint': 'e.g., 1 year'},
      {'name': 'businessWebsite', 'label': 'Business Website (Optional)', 'type': 'text', 'hint': 'https://yourwebsite.com'},
      {'name': 'businessAddress', 'label': 'Business Address', 'type': 'text', 'hint': 'Enter business address', 'required': true},
      {'name': 'idType', 'label': 'ID Type', 'type': 'dropdown', 'hint': 'Select ID type', 'options': [{'label': 'CAC', 'value': 'CAC'}, {'label': 'Business Permit', 'value': 'Business Permit'}, {'label': 'License', 'value': 'License'}], 'required': true},
      {'name': 'idRcNumber', 'label': 'ID / RC Number', 'type': 'text', 'hint': 'Enter ID or RC number', 'required': true},
      {'name': 'tinNumber', 'label': 'TIN Number', 'type': 'text', 'hint': 'Enter your Tax Identification Number', 'required': true},
    ];
  }
}
