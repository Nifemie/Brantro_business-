import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class InfluencerFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'Influencer';
  
  @override
  List<Map<String, dynamic>> getFormFields(String accountType) {
    return [
      {'name': 'displayName', 'label': 'Display Name', 'type': 'text', 'hint': 'Enter your name'},
      {'name': 'primaryPlatform', 'label': 'Primary Platform', 'type': 'dropdown', 'hint': 'Select your primary platform', 'options': INFLUENCER_PLATFORMS},
      {'name': 'contentCategory', 'label': 'Content Category', 'type': 'dropdown', 'hint': 'Select content category', 'options': INFLUENCER_CONTENT_CATEGORIES},
      {'name': 'niche', 'label': 'Niche', 'type': 'dropdown', 'hint': 'Select your niche', 'options': INFLUENCER_CONTENT_CATEGORIES},
      {'name': 'contentFormats', 'label': 'Content Formats', 'type': 'multiselect', 'hint': 'Select content formats', 'options': CONTENT_FORMAT_OPTIONS},
      {'name': 'audienceSizeRange', 'label': 'Audience Size Range', 'type': 'dropdown', 'hint': 'Select your audience size', 'options': AUDIENCE_SIZE_OPTIONS},
      {'name': 'averageEngagementRate', 'label': 'Average Engagement Rate (%)', 'type': 'text', 'hint': 'e.g., 5.5', 'isNumber': true},
      {'name': 'portfolioLink', 'label': 'Portfolio Link (Optional)', 'type': 'text', 'hint': 'https://yourportfolio.com'},
      {'name': 'availabilityType', 'label': 'Availability', 'type': 'dropdown', 'hint': 'Select your availability', 'options': AVAILABILITY_OPTIONS, 'required': true},
    ];
  }
}
