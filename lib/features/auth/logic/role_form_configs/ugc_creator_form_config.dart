import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class UGCCreatorFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'UGC Creator';
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    return [
      {'name': 'displayName', 'label': 'Display Name', 'type': 'text', 'hint': 'Enter your display name', 'required': true},
      {'name': 'contentStyle', 'label': 'Content Style', 'type': 'multiselect', 'hint': 'Select content styles', 'options': UGC_CONTENT_STYLE_OPTIONS, 'required': true},
      {'name': 'niches', 'label': 'Niches', 'type': 'multiselect', 'hint': 'Select niches', 'options': UGC_NICHE_OPTIONS, 'required': true},
      {'name': 'contentFormats', 'label': 'Content Formats', 'type': 'multiselect', 'hint': 'Select formats', 'options': UGC_CONTENT_FORMAT_OPTIONS, 'required': true},
      {'name': 'yearsOfExperience', 'label': 'Years of Experience (Optional)', 'type': 'dropdown', 'hint': 'Select years of experience', 'options': YEARS_OF_EXPERIENCE_OPTIONS},
      {'name': 'portfolioLink', 'label': 'Portfolio Link (Optional)', 'type': 'text', 'hint': 'https://yourportfolio.com'},
      {'name': 'availabilityType', 'label': 'Availability', 'type': 'dropdown', 'hint': 'Select your availability', 'options': AVAILABILITY_OPTIONS, 'required': true},
    ];
  }
}
