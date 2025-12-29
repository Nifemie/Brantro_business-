import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../controllers/re_useable/app_button.dart';
import '../../../../../core/constants/form_constants.dart';
import '../../../../../controllers/re_useable/custom_dropdown_field.dart';
import '../../../../../controllers/re_useable/custom_multiselect_dropdown_field.dart';
import '../../../../../controllers/re_useable/account_type_tab.dart';

class RoleDetailsScreen extends StatefulWidget {
  final String role;
  final String accountType;

  const RoleDetailsScreen({
    required this.role,
    required this.accountType,
    super.key,
  });

  @override
  State<RoleDetailsScreen> createState() => _RoleDetailsScreenState();
}

class _RoleDetailsScreenState extends State<RoleDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = false;
  late String _selectedAccountType;

  @override
  void initState() {
    super.initState();
    _selectedAccountType = widget.accountType;
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = _getFormFields();
    for (var field in fields) {
      // Only create text controllers for text fields, not for dropdowns
      if (field['type'] != 'dropdown' && field['type'] != 'multiselect') {
        _controllers[field['name']] = TextEditingController();
      }
    }
  }

  List<Map<String, dynamic>> _getFormFields() {
    switch (widget.role) {
      case 'Artist':
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
            'name': 'managerContact',
            'label': 'Manager Contact (Optional)',
            'type': 'text',
            'hint': '+234XXXXXXXXXX',
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
          {
            'name': 'bio',
            'label': 'Bio',
            'type': 'text',
            'hint': 'Tell us about yourself',
            'maxLines': 3,
          },
        ];

      case 'Advertiser':
        return [
          {
            'name': 'businessName',
            'label': 'Business Name',
            'type': 'text',
            'hint': 'Enter business name',
          },
          {
            'name': 'industry',
            'label': 'Industry',
            'type': 'dropdown',
            'hint': 'Select your industry',
            'options': ADVERTISER_BUSINESS_INDUSTRIES
                .map((industry) => {'label': industry, 'value': industry})
                .toList(),
          },
          {
            'name': 'businessAdress',
            'label': 'Business Address',
            'type': 'text',
            'hint': 'Enter business address',
          },
          {
            'name': 'businessWebsite',
            'label': 'Business Website',
            'type': 'text',
            'hint': 'https://yourcompany.com',
          },
          {
            'name': 'businessTelephoneNumber',
            'label': 'Business Telephone Number',
            'type': 'text',
            'hint': '+234XXXXXXXXXX',
            'isRequired': true,
          },
          {
            'name': 'tinNumber',
            'label': 'TIN Number',
            'type': 'text',
            'hint': 'Enter your Tax Identification Number',
            'isRequired': true,
          },
          {
            'name': 'businessRegistrationNumber',
            'label': 'Business Registration (RC) Number',
            'type': 'text',
            'hint': 'e.g., RC123456',
            'isRequired': true,
          },
        ];

      case 'Screen / Billboard':
        return [
          {
            'name': 'businessName',
            'label': 'Business Name',
            'type': 'text',
            'hint': 'Enter business name',
            'required': true,
          },
          {
            'name': 'permitNumber',
            'label': 'Permit Number',
            'type': 'text',
            'hint': 'Enter permit number',
            'required': true,
          },
          {
            'name': 'industry',
            'label': 'Industry',
            'type': 'dropdown',
            'hint': 'Select industry',
            'options': HOST_INDUSTRY_OPTIONS,
            'required': true,
          },
          {
            'name': 'operatingStates',
            'label': 'Operating States',
            'type': 'multiselect',
            'hint': 'Select operating states',
            'options': OPERATING_REGIONS_OPTIONS,
            'required': true,
          },
          {
            'name': 'yearsOfOperation',
            'label': 'Years of Operation (Optional)',
            'type': 'text',
            'hint': 'e.g., 1 year',
          },
          {
            'name': 'businessWebsite',
            'label': 'Business Website (Optional)',
            'type': 'text',
            'hint': 'https://yourwebsite.com',
          },
          {
            'name': 'businessAddress',
            'label': 'Business Address',
            'type': 'text',
            'hint': 'Enter business address',
            'required': true,
          },
          {
            'name': 'idType',
            'label': 'ID Type',
            'type': 'dropdown',
            'hint': 'Select ID type',
            'options': [
              {'label': 'CAC', 'value': 'CAC'},
              {'label': 'Business Permit', 'value': 'Business Permit'},
              {'label': 'License', 'value': 'License'},
            ],
            'required': true,
          },
          {
            'name': 'idRcNumber',
            'label': 'ID / RC Number',
            'type': 'text',
            'hint': 'Enter ID or RC number',
            'required': true,
          },
          {
            'name': 'tinNumber',
            'label': 'TIN Number',
            'type': 'text',
            'hint': 'Enter your Tax Identification Number',
            'required': true,
          },
        ];

      case 'Content Producer':
        // Check if it's Individual or Business account type
        if (_selectedAccountType.toLowerCase().contains('personal') ||
            _selectedAccountType.toLowerCase().contains('individual')) {
          // Individual Content Producer
          return [
            {
              'name': 'producerName',
              'label': 'Producer Name',
              'type': 'text',
              'hint': 'Enter your producer name',
              'required': true,
            },
            {
              'name': 'specialization',
              'label': 'Specialization',
              'type': 'dropdown',
              'hint': 'Select specialization',
              'options': PRODUCER_SPECIALIZATION_OPTIONS,
              'required': true,
            },
            {
              'name': 'serviceTypes',
              'label': 'Service Types',
              'type': 'multiselect',
              'hint': 'Select options',
              'options': PRODUCER_SERVICE_TYPE_OPTIONS,
              'required': true,
            },
            {
              'name': 'yearsOfExperience',
              'label': 'Years of Experience',
              'type': 'dropdown',
              'hint': 'Select an option',
              'options': YEARS_OF_EXPERIENCE_OPTIONS,
            },
            {
              'name': 'numberOfProductions',
              'label': 'Number of Productions',
              'type': 'dropdown',
              'hint': 'Select an option',
              'options': NUMBER_OF_PRODUCTIONS_OPTIONS,
            },
            {
              'name': 'portfolioLink',
              'label': 'Portfolio Link (Optional)',
              'type': 'text',
              'hint': 'https://yourportfolio.com',
            },
            {
              'name': 'availability',
              'label': 'Availability',
              'type': 'dropdown',
              'hint': 'Select your availability',
              'options': AVAILABILITY_OPTIONS,
              'required': true,
            },
          ];
        } else {
          // Business Content Producer
          return [
            {
              'name': 'businessName',
              'label': 'Business Name',
              'type': 'text',
              'hint': 'Enter business name',
              'required': true,
            },
            {
              'name': 'businessAddress',
              'label': 'Business Address',
              'type': 'text',
              'hint': 'Enter business address',
              'required': true,
            },
            {
              'name': 'website',
              'label': 'Website (Optional)',
              'type': 'text',
              'hint': 'https://yourcompany.com',
            },
            {
              'name': 'serviceTypes',
              'label': 'Service Types',
              'type': 'multiselect',
              'hint': 'Select options',
              'options': PRODUCER_SERVICE_TYPE_OPTIONS,
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
              'name': 'yearsOfExperience',
              'label': 'Years of Experience',
              'type': 'dropdown',
              'hint': 'Select an option',
              'options': YEARS_OF_EXPERIENCE_OPTIONS,
            },
            {
              'name': 'numberOfProductions',
              'label': 'Number of Productions',
              'type': 'dropdown',
              'hint': 'Select an option',
              'options': NUMBER_OF_PRODUCTIONS_OPTIONS,
            },
            {
              'name': 'portfolioLink',
              'label': 'Portfolio Link (Optional)',
              'type': 'text',
              'hint': 'https://yourportfolio.com',
            },
            {
              'name': 'availability',
              'label': 'Availability',
              'type': 'dropdown',
              'hint': 'Select your availability',
              'options': AVAILABILITY_OPTIONS,
              'required': true,
            },
          ];
        }

      case 'Influencer':
        return [
          {
            'name': 'displayName',
            'label': 'Display Name',
            'type': 'text',
            'hint': 'Enter your name',
          },
          {
            'name': 'primaryPlatform',
            'label': 'Primary Platform',
            'type': 'dropdown',
            'hint': 'Select your primary platform',
            'options': INFLUENCER_PLATFORMS,
          },
          {
            'name': 'niche',
            'label': 'Niche',
            'type': 'dropdown',
            'hint': 'Select your niche',
            'options': INFLUENCER_CONTENT_CATEGORIES,
          },
          {
            'name': 'contentFormat',
            'label': 'Content Format',
            'type': 'dropdown',
            'hint': 'Select your content format',
            'options': CONTENT_FORMAT_OPTIONS,
          },
          {
            'name': 'estimatedReach',
            'label': 'Estimated Reach',
            'type': 'dropdown',
            'hint': 'Select your audience size',
            'options': AUDIENCE_SIZE_OPTIONS,
          },
          {
            'name': 'location',
            'label': 'Location (State)',
            'type': 'dropdown',
            'hint': 'Select your state',
            'options': OPERATING_REGIONS_OPTIONS,
          },
          {
            'name': 'averageEngagementRate',
            'label': 'Average Engagement Rate (%)',
            'type': 'text',
            'hint': 'e.g., 5.5',
          },
          {
            'name': 'portfolioMediaKitLink',
            'label': 'Portfolio / Media Kit Link',
            'type': 'text',
            'hint': 'https://yourlink.com',
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
            'name': 'bio',
            'label': 'Bio',
            'type': 'text',
            'hint': 'Your bio or tagline',
            'maxLines': 2,
          },
        ];

      case 'UGC Creator':
        return [
          {
            'name': 'displayName',
            'label': 'Display Name',
            'type': 'text',
            'hint': 'Enter your display name',
            'required': true,
          },
          {
            'name': 'contentStyle',
            'label': 'Content Style',
            'type': 'multiselect',
            'hint': 'Select content styles',
            'options': INFLUENCER_CONTENT_CATEGORIES,
            'required': true,
          },
          {
            'name': 'niches',
            'label': 'Niches',
            'type': 'multiselect',
            'hint': 'Select niches',
            'options': INFLUENCER_NICHES,
            'required': true,
          },
          {
            'name': 'contentFormats',
            'label': 'Content Formats',
            'type': 'multiselect',
            'hint': 'Select formats',
            'options': UGC_CONTENT_FORMAT_OPTIONS,
            'required': true,
          },
          {
            'name': 'yearsOfExperience',
            'label': 'Years of Experience (Optional)',
            'type': 'dropdown',
            'hint': 'Select years of experience',
            'options': YEARS_OF_EXPERIENCE_OPTIONS,
          },
          {
            'name': 'portfolioLink',
            'label': 'Portfolio Link (Optional)',
            'type': 'text',
            'hint': 'https://yourportfolio.com',
          },
          {
            'name': 'availability',
            'label': 'Availability',
            'type': 'dropdown',
            'hint': 'Select your availability',
            'options': AVAILABILITY_OPTIONS,
            'required': true,
          },
        ];

      case 'Host':
        return [
          {
            'name': 'businessName',
            'label': 'Business Name',
            'hint': 'Enter business name',
          },
          {
            'name': 'businessAddress',
            'label': 'Business Address',
            'hint': 'Enter business address',
          },
          {
            'name': 'industry',
            'label': 'Industry',
            'hint': 'e.g., Outdoor Advertising',
          },
          {
            'name': 'telephoneNumber',
            'label': 'Telephone Number',
            'hint': '+234XXXXXXXXXX',
          },
          {
            'name': 'businessWebsite',
            'label': 'Business Website',
            'hint': 'https://yourcompany.com',
          },
          {
            'name': 'signagePermitNumber',
            'label': 'Signage Permit Number',
            'hint': 'e.g., FCTA-LED-2025-009',
          },
        ];

      case 'TV Station':
        return [
          {
            'name': 'stationName',
            'label': 'TV Station Name',
            'type': 'text',
            'hint': 'Enter station name',
            'required': true,
          },
          {
            'name': 'businessAddress',
            'label': 'Business Address',
            'type': 'text',
            'hint': 'Enter business address',
            'required': true,
          },
          {
            'name': 'rcNumber',
            'label': 'RC Number',
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
            'name': 'telephoneNumber',
            'label': 'Telephone Number',
            'type': 'text',
            'hint': '+234XXXXXXXXXX',
            'required': true,
          },
          {
            'name': 'website',
            'label': 'Website (Optional)',
            'type': 'text',
            'hint': 'https://yourwebsite.com',
          },
          {
            'name': 'broadcastType',
            'label': 'Broadcast Type',
            'type': 'dropdown',
            'hint': 'Select broadcast type',
            'options': TV_BROADCAST_TYPE_OPTIONS,
            'required': true,
          },
          {
            'name': 'channelType',
            'label': 'Channel Type',
            'type': 'dropdown',
            'hint': 'Select channel type',
            'options': TV_CHANNEL_TYPE_OPTIONS,
            'required': true,
          },
          {
            'name': 'operatingRegions',
            'label': 'Operating Regions',
            'type': 'multiselect',
            'hint': 'Select operating regions',
            'options': OPERATING_REGIONS_OPTIONS,
            'required': true,
          },
          {
            'name': 'contentFocus',
            'label': 'Content Focus',
            'type': 'multiselect',
            'hint': 'Select content focus',
            'options': TV_CONTENT_FOCUS_OPTIONS,
            'required': true,
          },
          {
            'name': 'yearsOfOperation',
            'label': 'Years of Operation (Optional)',
            'type': 'dropdown',
            'hint': 'Select years of operation',
            'options': YEARS_OF_EXPERIENCE_OPTIONS,
          },
          {
            'name': 'averageDailyViewership',
            'label': 'Average Daily Viewership (Optional)',
            'type': 'text',
            'hint': 'e.g., 500000',
          },
        ];

      case 'Radio Station':
        return [
          {
            'name': 'stationName',
            'label': 'Radio Station Name',
            'type': 'text',
            'hint': 'Enter station name',
            'required': true,
          },
          {
            'name': 'businessAddress',
            'label': 'Business Address',
            'type': 'text',
            'hint': 'Enter business address',
            'required': true,
          },
          {
            'name': 'rcNumber',
            'label': 'RC Number',
            'type': 'text',
            'hint': 'e.g., RC567890',
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
            'name': 'contactPhone',
            'label': 'Contact Phone',
            'type': 'text',
            'hint': '+234XXXXXXXXXX',
            'required': true,
          },
          {
            'name': 'website',
            'label': 'Website (Optional)',
            'type': 'text',
            'hint': 'https://yourwebsite.com',
          },
          {
            'name': 'broadcastBand',
            'label': 'Broadcast Band',
            'type': 'dropdown',
            'hint': 'Select broadcast band',
            'options': RADIO_BROADCAST_BAND_OPTIONS,
            'required': true,
          },
          {
            'name': 'primaryLanguage',
            'label': 'Primary Language',
            'type': 'dropdown',
            'hint': 'Select primary language',
            'options': LANGUAGE_OPTIONS,
            'required': true,
          },
          {
            'name': 'operatingRegions',
            'label': 'Operating Regions',
            'type': 'multiselect',
            'hint': 'Select operating regions',
            'options': OPERATING_REGIONS_OPTIONS,
            'required': true,
          },
          {
            'name': 'contentFocus',
            'label': 'Content Focus',
            'type': 'multiselect',
            'hint': 'Select content focus',
            'options': RADIO_CONTENT_FOCUS_OPTIONS,
            'required': true,
          },
          {
            'name': 'yearsOfOperation',
            'label': 'Years of Operation (Optional)',
            'type': 'dropdown',
            'hint': 'Select years of operation',
            'options': YEARS_OF_EXPERIENCE_OPTIONS,
          },
          {
            'name': 'averageDailyListenership',
            'label': 'Average Daily Listenership (Optional)',
            'type': 'text',
            'hint': 'e.g., 500000',
          },
        ];

      case 'Media House':
        return [
          {
            'name': 'mediaHouseName',
            'label': 'Media House Name',
            'type': 'text',
            'hint': 'Enter media house name',
            'required': true,
          },
          {
            'name': 'businessAddress',
            'label': 'Business Address',
            'type': 'text',
            'hint': 'Enter business address',
            'required': true,
          },
          {
            'name': 'rcNumber',
            'label': 'RC Number',
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
            'name': 'contactPhone',
            'label': 'Contact Phone',
            'type': 'text',
            'hint': '+234XXXXXXXXXX',
            'required': true,
          },
          {
            'name': 'website',
            'label': 'Website (Optional)',
            'type': 'text',
            'hint': 'https://yourwebsite.com',
          },
          {
            'name': 'operatingRegions',
            'label': 'Operating Regions',
            'type': 'multiselect',
            'hint': 'Select operating regions',
            'options': OPERATING_REGIONS_OPTIONS,
            'required': true,
          },
          {
            'name': 'mediaTypes',
            'label': 'Media Types',
            'type': 'multiselect',
            'hint': 'Select media types',
            'options': MEDIA_HOUSE_TYPE_OPTIONS,
            'required': true,
          },
          {
            'name': 'contentFocus',
            'label': 'Content Focus',
            'type': 'multiselect',
            'hint': 'Select content focus',
            'options': MEDIA_HOUSE_CONTENT_FOCUS_OPTIONS,
            'required': true,
          },
          {
            'name': 'yearsOfOperation',
            'label': 'Years of Operation (Optional)',
            'type': 'dropdown',
            'hint': 'Select years of operation',
            'options': YEARS_OF_EXPERIENCE_OPTIONS,
          },
          {
            'name': 'estimatedMonthlyReach',
            'label': 'Estimated Monthly Reach (Optional)',
            'type': 'text',
            'hint': 'e.g., 500000',
          },
        ];

      case 'Designer':
        return [
          {
            'name': 'displayName',
            'label': 'Display Name',
            'type': 'text',
            'hint': 'Enter your display name',
            'required': true,
          },
          {
            'name': 'creativeType',
            'label': 'Creative Type',
            'type': 'dropdown',
            'hint': 'Select your creative type',
            'options': CREATIVE_TYPE_OPTIONS,
            'required': true,
          },
          {
            'name': 'specialization',
            'label': 'Specialization',
            'type': 'dropdown',
            'hint': 'Select specialization',
            'options': CREATIVE_SPECIALIZATION_OPTIONS,
            'required': true,
          },
          {
            'name': 'skills',
            'label': 'Skills',
            'type': 'multiselect',
            'hint': 'Select skills',
            'options': CREATIVE_SKILLS_OPTIONS,
            'required': true,
          },
          {
            'name': 'toolsUsed',
            'label': 'Tools Used',
            'type': 'multiselect',
            'hint': 'Select tools',
            'options': CREATIVE_TOOLS_OPTIONS,
            'required': true,
          },
          {
            'name': 'yearsOfExperience',
            'label': 'Years of Experience',
            'type': 'dropdown',
            'hint': 'Select years',
            'options': YEARS_OF_EXPERIENCE_OPTIONS,
          },
          {
            'name': 'numberOfProjects',
            'label': 'Number of Projects',
            'type': 'dropdown',
            'hint': 'Select number of projects',
            'options': NUMBER_OF_PRODUCTIONS_OPTIONS,
          },
          {
            'name': 'portfolioLink',
            'label': 'Portfolio Link (Optional)',
            'type': 'text',
            'hint': 'https://yourportfolio.com',
          },
          {
            'name': 'availability',
            'label': 'Availability',
            'type': 'dropdown',
            'hint': 'Select your availability',
            'options': AVAILABILITY_OPTIONS,
            'required': true,
          },
        ];

      case 'Talent Manager':
        // Check if it's Individual or Business account type
        if (_selectedAccountType.toLowerCase().contains('personal') ||
            _selectedAccountType.toLowerCase().contains('individual')) {
          // Individual Talent Manager
          return [
            {
              'name': 'managerDisplayName',
              'label': 'Manager Display Name',
              'type': 'text',
              'hint': 'Enter your display name',
              'required': true,
            },
            {
              'name': 'numberOfTalentsManaged',
              'label': 'Number of Talents Managed',
              'type': 'dropdown',
              'hint': 'Select an option',
              'options': TALENTS_MANAGED_COUNT_OPTIONS,
              'required': true,
            },
            {
              'name': 'talentCategories',
              'label': 'Talent Categories',
              'type': 'multiselect',
              'hint': 'Select options',
              'options': TALENT_CATEGORY_OPTIONS,
              'required': true,
            },
            {
              'name': 'yearsOfExperience',
              'label': 'Years of Experience',
              'type': 'dropdown',
              'hint': 'Select an option',
              'options': YEARS_OF_EXPERIENCE_OPTIONS,
            },
          ];
        } else {
          // Business Talent Manager
          return [
            {
              'name': 'businessName',
              'label': 'Business Name',
              'type': 'text',
              'hint': 'Enter business name',
              'required': true,
            },
            {
              'name': 'businessAddress',
              'label': 'Business Address',
              'type': 'text',
              'hint': 'Enter business address',
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
              'name': 'numberOfTalentsManaged',
              'label': 'Number of Talents Managed',
              'type': 'dropdown',
              'hint': 'Select an option',
              'options': TALENTS_MANAGED_COUNT_OPTIONS,
              'required': true,
            },
            {
              'name': 'talentCategories',
              'label': 'Talent Categories',
              'type': 'multiselect',
              'hint': 'Select options',
              'options': TALENT_CATEGORY_OPTIONS,
              'required': true,
            },
            {
              'name': 'yearsOfExperience',
              'label': 'Years of Experience',
              'type': 'dropdown',
              'hint': 'Select an option',
              'options': YEARS_OF_EXPERIENCE_OPTIONS,
            },
            {
              'name': 'website',
              'label': 'Website (Optional)',
              'type': 'text',
              'hint': 'https://yourwebsite.com',
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
          ];
        }

      default:
        return [];
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Collect form data from both text controllers and form values
      final formData = <String, dynamic>{};
      _controllers.forEach((key, controller) {
        formData[key] = controller.text;
      });

      // Simulate API call
      Future.delayed(const Duration(milliseconds: 500)).then((_) {
        if (mounted) {
          setState(() => _isLoading = false);
          // Navigate to account details page with role data
          context.push(
            '/account-details',
            extra: {
              'role': widget.role,
              'accountType': widget.accountType,
              'roleData': formData,
            },
          );
        }
      });
    }
  }

  void _handleDropdownChange(String fieldName, String? value) {
    if (value != null && value.isNotEmpty) {
      // Store dropdown values in controllers or a separate map
      // For now, we'll add them to the form state
      setState(() {
        _controllers[fieldName] = TextEditingController(text: value);
      });
    }
  }

  void _handleMultiselectChange(String fieldName, List<String> values) {
    // Store multiselect values as comma-separated string or as a list
    setState(() {
      _controllers[fieldName] = TextEditingController(text: values.join(', '));
    });
  }

  @override
  Widget build(BuildContext context) {
    final fields = _getFormFields();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '${widget.role} Details',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 60.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Complete Your ${widget.role} Profile',
                  style: TextStyle(
                    fontSize: 24.rsp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Please fill in the details below to set up your account',
                  style: TextStyle(fontSize: 14.rsp, color: Colors.grey[600]),
                ),
                SizedBox(height: 32.h),

                // Account Type Tabs
                AccountTypeTab(
                  selectedType: _selectedAccountType,
                  onTypeChanged: (newType) {
                    setState(() {
                      _selectedAccountType = newType;
                      // Clear existing controllers when switching account type
                      _controllers.clear();
                      _initializeControllers();
                    });
                  },
                ),
                SizedBox(height: 32.h),

                // Dynamic Form Fields
                ...fields.map((field) {
                  final fieldType = field['type'] as String? ?? 'text';
                  final fieldName = field['name'] as String;

                  if (fieldType == 'dropdown') {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CustomDropdownField(
                        label: field['label'] as String,
                        hint: field['hint'] as String?,
                        options: field['options'] as List<Map<String, String>>,
                        isRequired: field['isRequired'] as bool? ?? true,
                        onChanged: (value) =>
                            _handleDropdownChange(fieldName, value),
                      ),
                    );
                  } else if (fieldType == 'multiselect') {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CustomMultiselectDropdownField(
                        label: field['label'] as String,
                        hint: field['hint'] as String?,
                        options: field['options'] as List<Map<String, String>>,
                        isRequired: field['isRequired'] as bool? ?? true,
                        onChanged: (values) =>
                            _handleMultiselectChange(fieldName, values),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _buildTextField(
                        controller: _controllers[fieldName]!,
                        label: field['label'] as String,
                        hint: field['hint'] as String?,
                        maxLines: field['maxLines'] as int? ?? 1,
                        isRequired: field['isRequired'] as bool? ?? true,
                      ),
                    );
                  }
                }).toList(),

                SizedBox(height: 50.h),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.rsp),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 24.h,
                            width: 24.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Complete Registration',
                            style: TextStyle(
                              fontSize: 16.rsp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? hint,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.rsp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: maxLines == 1 ? 1 : maxLines,
          decoration: _inputDecoration(hint),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.rsp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.rsp),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.rsp),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.rsp),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      contentPadding: PlatformResponsive.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
