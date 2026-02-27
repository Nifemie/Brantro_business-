import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class CreativesFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'Creatives';
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    return [
      {'name': 'displayName', 'label': 'Display Name', 'type': 'text', 'hint': 'Enter your display name', 'required': true},
      {'name': 'creativeType', 'label': 'Creative Type', 'type': 'text', 'hint': 'e.g., Motion Designer, Graphic Designer, UI/UX Designer', 'required': true},
      {'name': 'specialization', 'label': 'Specialization', 'type': 'text', 'hint': 'e.g., Motion Graphics & Animation', 'required': true},
      {'name': 'skills', 'label': 'Skills (Comma Separated)', 'type': 'text', 'hint': 'e.g., Motion Graphics, 3D Animation, VFX', 'required': true},
      {'name': 'toolsUsed', 'label': 'Tools Used (Comma Separated)', 'type': 'text', 'hint': 'e.g., Adobe After Effects, Cinema 4D, Blender', 'required': true},
      {'name': 'yearsOfExperience', 'label': 'Years of Experience', 'type': 'dropdown', 'hint': 'Select an option', 'options': YEARS_OF_EXPERIENCE_OPTIONS},
      {'name': 'numberOfProjects', 'label': 'Number of Projects', 'type': 'dropdown', 'hint': 'Select an option', 'options': NUMBER_OF_PRODUCTIONS_OPTIONS},
      {'name': 'portfolioLink', 'label': 'Portfolio Link', 'type': 'text', 'hint': 'https://yourportfolio.com'},
      {'name': 'availabilityType', 'label': 'Availability', 'type': 'dropdown', 'hint': 'Select your availability', 'options': AVAILABILITY_OPTIONS, 'required': true},
    ];
  }
}
