import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class ArtistFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'Artist';
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    return [
      {
        'name': 'stageName',
        'label': 'Stage Name',
        'type': 'text',
        'hint': 'Enter your stage name',
        'required': true,
      },
      {
        'name': 'profession',
        'label': 'Primary Profession',
        'type': 'dropdown',
        'hint': 'Select your profession',
        'options': PROFESSION_OPTIONS,
        'required': true,
      },
      {
        'name': 'specialization',
        'label': 'Specialization',
        'type': 'dropdown',
        'hint': 'Select your specialization',
        'options': SPECIALIZATION_OPTIONS,
        'required': true,
      },
      {
        'name': 'genre',
        'label': 'Genres',
        'type': 'multiselect',
        'hint': 'Select your genre(s)',
        'options': GENRE_OPTIONS,
        'required': true,
      },
      {
        'name': 'availability',
        'label': 'Availability',
        'type': 'dropdown',
        'hint': 'Select your availability',
        'options': AVAILABILITY_OPTIONS,
        'required': true,
      },
      {
        'name': 'yearsOfExperience',
        'label': 'Years of Experience',
        'type': 'dropdown',
        'hint': 'Select your years of experience',
        'options': YEARS_OF_EXPERIENCE_OPTIONS,
        'required': true,
      },
      {
        'name': 'numberOfProductions',
        'label': 'Number of Productions',
        'type': 'dropdown',
        'hint': 'Select number of productions',
        'options': NUMBER_OF_PRODUCTIONS_OPTIONS,
        'required': true,
      },
      {
        'name': 'whoManagesYou',
        'label': 'Who Manages You?',
        'type': 'dropdown',
        'hint': 'Select manager type',
        'options': TALENT_MANAGER_TYPE_OPTIONS,
        'required': true,
      },
      {
        'name': 'portfolioLink',
        'label': 'Portfolio Link (Optional)',
        'type': 'text',
        'hint': 'https://yourportfolio.com',
      },
    ];
  }
}
