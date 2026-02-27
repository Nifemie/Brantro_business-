import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class TalentManagerFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'Talent Manager';
  
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
      {'name': 'managerDisplayName', 'label': 'Manager Display Name', 'type': 'text', 'hint': 'Enter your display name', 'required': true},
      {'name': 'numberOfTalentsManaged', 'label': 'Number of Talents Managed', 'type': 'dropdown', 'hint': 'Select an option', 'options': TALENTS_MANAGED_COUNT_OPTIONS, 'required': true},
      {'name': 'talentCategories', 'label': 'Talent Categories', 'type': 'multiselect', 'hint': 'Select options', 'options': TALENT_CATEGORY_OPTIONS, 'required': true},
      {'name': 'yearsOfExperience', 'label': 'Years of Experience', 'type': 'dropdown', 'hint': 'Select an option', 'options': YEARS_OF_EXPERIENCE_OPTIONS},
    ];
  }
  
  List<Map<String, dynamic>> _getBusinessFields() {
    return [
      {'name': 'businessName', 'label': 'Business Name', 'type': 'text', 'hint': 'Enter business name', 'required': true},
      {'name': 'businessAddress', 'label': 'Business Address', 'type': 'text', 'hint': 'Enter business address', 'required': true},
      {'name': 'businessTelephoneNumber', 'label': 'Business Telephone Number', 'type': 'text', 'hint': '+234XXXXXXXXXX', 'required': true},
      {'name': 'numberOfTalentsManaged', 'label': 'Number of Talents Managed', 'type': 'dropdown', 'hint': 'Select an option', 'options': TALENTS_MANAGED_COUNT_OPTIONS, 'required': true},
      {'name': 'talentCategories', 'label': 'Talent Categories', 'type': 'multiselect', 'hint': 'Select options', 'options': TALENT_CATEGORY_OPTIONS, 'required': true},
      {'name': 'yearsOfExperience', 'label': 'Years of Experience', 'type': 'dropdown', 'hint': 'Select an option', 'options': YEARS_OF_EXPERIENCE_OPTIONS},
      {'name': 'website', 'label': 'Website (Optional)', 'type': 'text', 'hint': 'https://yourwebsite.com'},
      {'name': 'businessRegistrationNumber', 'label': 'Business Registration (RC) Number', 'type': 'text', 'hint': 'e.g., RC123456', 'required': true},
      {'name': 'tinNumber', 'label': 'TIN Number', 'type': 'text', 'hint': 'Enter your Tax Identification Number', 'required': true},
    ];
  }
}
