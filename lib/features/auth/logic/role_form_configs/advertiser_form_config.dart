import 'base_role_form_config.dart';
import '../../../../core/constants/form_constants.dart';

class AdvertiserFormConfig extends BaseRoleFormConfig {
  @override
  String get roleName => 'Advertiser';
  
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
      {
        'name': 'fullName',
        'label': 'Full Name',
        'type': 'text',
        'hint': 'Enter your full name',
        'required': true,
      },
      {
        'name': 'email',
        'label': 'Email Address',
        'type': 'text',
        'hint': 'Enter your email address',
        'required': true,
      },
      {
        'name': 'phoneNumber',
        'label': 'Phone Number',
        'type': 'text',
        'hint': '+234XXXXXXXXXX',
        'required': true,
      },
      {
        'name': 'state',
        'label': 'State',
        'type': 'dropdown',
        'hint': 'Select an option',
        'options': OPERATING_REGIONS_OPTIONS,
        'required': true,
      },
      {
        'name': 'city',
        'label': 'City / Local Government',
        'type': 'dropdown',
        'hint': 'Select a state first',
        'options': <Map<String, String>>[],
        'required': true,
        'dependsOn': 'state',
      },
      {
        'name': 'streetAddress',
        'label': 'Street Address',
        'type': 'text',
        'hint': 'House number and street name',
        'required': true,
      },
      {
        'name': 'password',
        'label': 'Password',
        'type': 'password',
        'hint': 'Enter your password',
        'required': true,
      },
    ];
  }
  
  List<Map<String, dynamic>> _getBusinessFields() {
    return [
      {
        'name': 'businessName',
        'label': 'Business Name',
        'type': 'text',
        'hint': 'Enter business name',
        'required': true,
      },
      {
        'name': 'businessRegistrationNumber',
        'label': 'Business Registration (RC) Number',
        'type': 'text',
        'hint': 'e.g., RC123456',
        'required': true,
      },
      {
        'name': 'tinNumber',
        'label': 'TIN Number',
        'type': 'text',
        'hint': 'Enter your Tax Identification Number',
        'required': true,
      },
      {
        'name': 'industry',
        'label': 'Industry',
        'type': 'dropdown',
        'hint': 'Select your industry',
        'options': ADVERTISER_BUSINESS_INDUSTRIES
            .map((industry) => {'label': industry, 'value': industry})
            .toList(),
        'required': true,
      },
      {
        'name': 'businessTelephoneNumber',
        'label': 'Business Telephone Number',
        'type': 'text',
        'hint': '+234XXXXXXXXXX',
        'required': true,
      },
      {
        'name': 'businessWebsite',
        'label': 'Website (Optional)',
        'type': 'text',
        'hint': 'https://yourcompany.com',
      },
      {
        'name': 'businessAddress',
        'label': 'Business Address',
        'type': 'text',
        'hint': 'Enter business address',
        'required': true,
      },
    ];
  }
}
