import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class ProducerFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'Content Producer';
  
  @override
  bool get supportsAccountTypes => true;
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    if (accountType.toLowerCase().contains('personal') ||
        accountType.toLowerCase().contains('individual')) {
      return _getIndividualFields();
    } else {
      return _getBusinessFields();
    }
  }
  
  List<Map<String, dynamic>> _getIndividualFields() {
    return [
      {'name': 'producerName', 'label': 'Producer Name', 'type': 'text', 'hint': 'Enter your producer name', 'required': true},
      {'name': 'specialization', 'label': 'Specialization', 'type': 'dropdown', 'hint': 'Select specialization', 'options': PRODUCER_SPECIALIZATION_OPTIONS, 'required': true},
      {'name': 'serviceTypes', 'label': 'Service Types', 'type': 'multiselect', 'hint': 'Select options', 'options': PRODUCER_SERVICE_TYPE_OPTIONS, 'required': true},
      {'name': 'yearsOfExperience', 'label': 'Years of Experience', 'type': 'dropdown', 'hint': 'Select an option', 'options': YEARS_OF_EXPERIENCE_OPTIONS},
      {'name': 'numberOfProductions', 'label': 'Number of Productions', 'type': 'dropdown', 'hint': 'Select an option', 'options': NUMBER_OF_PRODUCTIONS_OPTIONS},
      {'name': 'portfolioLink', 'label': 'Portfolio Link (Optional)', 'type': 'text', 'hint': 'https://yourportfolio.com'},
      {'name': 'availabilityType', 'label': 'Availability', 'type': 'dropdown', 'hint': 'Select your availability', 'options': AVAILABILITY_OPTIONS, 'required': true},
    ];
  }
  
  List<Map<String, dynamic>> _getBusinessFields() {
    return [
      {'name': 'businessName', 'label': 'Business Name', 'type': 'text', 'hint': 'Enter business name', 'required': true},
      {'name': 'businessAddress', 'label': 'Business Address', 'type': 'text', 'hint': 'Enter business address', 'required': true},
      {'name': 'businessWebsite', 'label': 'Website (Optional)', 'type': 'text', 'hint': 'https://yourcompany.com'},
      {'name': 'serviceTypes', 'label': 'Service Types', 'type': 'multiselect', 'hint': 'Select options', 'options': PRODUCER_SERVICE_TYPE_OPTIONS, 'required': true},
      {'name': 'idType', 'label': 'ID Type', 'type': 'dropdown', 'hint': 'Select ID type', 'options': ID_TYPE_OPTIONS, 'required': true},
      {'name': 'idNumber', 'label': 'ID Number', 'type': 'text', 'hint': 'Enter your ID number', 'required': true},
      {'name': 'tinNumber', 'label': 'TIN Number', 'type': 'text', 'hint': 'Enter your Tax Identification Number', 'required': true},
      {'name': 'yearsOfExperience', 'label': 'Years of Experience', 'type': 'dropdown', 'hint': 'Select an option', 'options': YEARS_OF_EXPERIENCE_OPTIONS},
      {'name': 'numberOfProductions', 'label': 'Number of Productions', 'type': 'dropdown', 'hint': 'Select an option', 'options': NUMBER_OF_PRODUCTIONS_OPTIONS},
      {'name': 'portfolioLink', 'label': 'Portfolio Link (Optional)', 'type': 'text', 'hint': 'https://yourportfolio.com'},
    ];
  }
}
