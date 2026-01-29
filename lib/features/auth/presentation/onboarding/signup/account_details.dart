import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../../core/utils/color_utils.dart' hide AppColors;
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../core/constants/location_constants.dart';
import '../../../../../controllers/re_useable/country_picker_field.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../logic/auth_notifiers.dart';
import '../../../data/models/signup_request.dart';
import '../../../../../core/constants/enum.dart';

class AccountDetailsScreen extends ConsumerStatefulWidget {
  final String role;
  final String accountType;
  final Map<String, dynamic> roleData;

  const AccountDetailsScreen({
    required this.role,
    required this.accountType,
    required this.roleData,
    super.key,
  });

  @override
  ConsumerState<AccountDetailsScreen> createState() =>
      _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  int _currentStep = 1; // 1 or 2
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Step 1 Controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  String? _selectedAccountType;

  // Step 2 Controllers
  late TextEditingController _addressController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _cityController;
  late TextEditingController _idTypeController;
  late TextEditingController _idNumberController;
  late TextEditingController _tinNumberController;
  Country? _selectedCountry;
  String? _selectedState;

  // Location data
  final Map<String, List<String>> statesByCountry = STATES_BY_COUNTRY;
  final Map<String, List<String>> citiesByState = CITIES_BY_STATE;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _cityController = TextEditingController();
    _idTypeController = TextEditingController();
    _idNumberController = TextEditingController();
    _tinNumberController = TextEditingController();
    // Normalize accountType to match dropdown values
    _selectedAccountType = _normalizeAccountType(widget.accountType);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  String _normalizeAccountType(String accountType) {
    if (accountType.toLowerCase().contains('individual') ||
        accountType.toLowerCase().contains('personal')) {
      return 'INDIVIDUAL';
    } else if (accountType.toLowerCase().contains('business')) {
      return 'BUSINESS';
    }
    return accountType.toUpperCase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cityController.dispose();
    _idTypeController.dispose();
    _idNumberController.dispose();
    _tinNumberController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() => _currentStep = 2);
    }
  }

  void _previousStep() {
    setState(() => _currentStep = 1);
  }

  List<String> _getGenresList(dynamic genreData) {
    if (genreData == null) return [];
    if (genreData is List) {
      return genreData.map((e) => e.toString()).toList();
    }
    if (genreData is String) {
      return [genreData];
    }
    return [];
  }

  int _extractIntValue(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;

    // Try to parse as string
    String strValue = value.toString();

    // Try direct parse first
    int? parsed = int.tryParse(strValue);
    if (parsed != null) return parsed;

    // Extract first number from string like "1-3 years" or "5-10"
    RegExp regExp = RegExp(r'\d+');
    Match? match = regExp.firstMatch(strValue);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 0;
    }

    return 0;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      switch (widget.role.toUpperCase()) {
        case 'ARTIST':
          await _handleArtistSignup();
          break;
        case 'ADVERTISER':
          await _handleAdvertiserSignup();
          break;
        case 'SCREEN / BILLBOARD':
          await _handleScreenBillboardSignup();
          break;
        case 'CONTENT PRODUCER':
          await _handleContentProducerSignup();
          break;
        case 'INFLUENCER':
          await _handleInfluencerSignup();
          break;
        case 'UGC CREATOR':
          await _handleUGCCreatorSignup();
          break;
        case 'HOST':
          await _handleHostSignup();
          break;
        case 'TV STATION':
          await _handleTVStationSignup();
          break;
        case 'RADIO STATION':
          await _handleRadioStationSignup();
          break;
        case 'MEDIA HOUSE':
          await _handleMediaHouseSignup();
          break;
        case 'CREATIVES':
          await _handleCreativesSignup();
          break;
        case 'DESIGNER':
          await _handleDesignerSignup();
          break;
        case 'TALENT MANAGER':
          await _handleTalentManagerSignup();
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Signup for ${widget.role} is not yet implemented.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
      }
    }
  }

  Future<void> _handleCreativesSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // Convert comma-separated strings to lists
    final List<String> skills = widget.roleData['skills'] != null
        ? (widget.roleData['skills'] as String)
              .split(',')
              .map((s) => s.trim())
              .toList()
        : [];

    final List<String> toolsUsed = widget.roleData['toolsUsed'] != null
        ? (widget.roleData['toolsUsed'] as String)
              .split(',')
              .map((s) => s.trim())
              .toList()
        : [];

    final creativeInfo = CreativeInfo(
      displayName: widget.roleData['displayName'],
      creativeType: widget.roleData['creativeType'],
      skills: skills,
      specialization: widget.roleData['specialization'],
      toolsUsed: toolsUsed,
      yearsOfExperience: _extractIntValue(widget.roleData['yearsOfExperience']),
      numberOfProjects: _extractIntValue(widget.roleData['numberOfProjects']),
      portfolioLink: widget.roleData['portfolioLink'],
      availabilityType: widget.roleData['availabilityType'],
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.DESIGNER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.INDIVIDUAL.value,
      creativeInfo: creativeInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleDesignerSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final designerInfo = DesignerInfo(
      businessName: widget.roleData['businessName'],
      businessAddress: widget.roleData['businessAddress'],
      businessWebsite: widget.roleData['businessWebsite'],
      telephoneNumber: widget.roleData['telephoneNumber'],
      portfolioUrl: widget.roleData['portfolioUrl'],
      bio: widget.roleData['bio'],
      skillTags: widget.roleData['skillTags'],
      experienceLevel: widget.roleData['experienceLevel'],
      pricingModel: widget.roleData['pricingModel'],
      price: double.tryParse(widget.roleData['price']?.toString() ?? ''),
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.DESIGNER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.INDIVIDUAL.value,
      designerInfo: designerInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
      idType: _idTypeController.text.isNotEmpty ? _idTypeController.text : null,
      idNumber: _idNumberController.text.isNotEmpty
          ? _idNumberController.text
          : null,
      tinNumber: _tinNumberController.text.isNotEmpty
          ? _tinNumberController.text
          : null,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleTalentManagerSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final talentManagerInfo = TalentManagerInfo(
      managerDisplayName: widget.roleData['managerDisplayName'],
      businessName: widget.roleData['businessName'],
      businessAddress: widget.roleData['businessAddress'],
      businessTelephoneNumber: widget.roleData['businessTelephoneNumber'],
      numberOfTalentsManaged: widget.roleData['numberOfTalentsManaged'],
      talentCategories: _getGenresList(widget.roleData['talentCategories']),
      yearsOfExperience: widget.roleData['yearsOfExperience'],
      website: widget.roleData['website'],
      businessRegistrationNumber: widget.roleData['businessRegistrationNumber'],
      tinNumber: widget.roleData['tinNumber'] ?? _tinNumberController.text,
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.TALENT_MANAGER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.INDIVIDUAL.value,
      talentManagerInfo: talentManagerInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleHostSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final hostInfo = HostInfo(
      businessName: widget.roleData['businessName'],
      permitNumber: widget.roleData['permitNumber'],
      businessAddress: widget.roleData['businessAddress'],
      businessWebsite: widget.roleData['businessWebsite'],
      industry: widget.roleData['industry'],
      operatingCities: _getGenresList(widget.roleData['operatingCities']),
      yearsOfOperation: _extractIntValue(widget.roleData['yearsOfOperation']),
      idType: widget.roleData['idType'],
      idNumber: widget.roleData['idNumber'],
      tinNumber: widget.roleData['tinNumber'],
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.HOST.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.BUSINESS.value,
      hostInfo: hostInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleTVStationSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final tvStationInfo = TVStationInfo(
      businessName: widget.roleData['businessName'] ?? '',
      businessAddress: widget.roleData['businessAddress'] ?? '',
      rcNumber: widget.roleData['rcNumber'] ?? '',
      tinNumber: widget.roleData['tinNumber'] ?? '',
      contactPhone: widget.roleData['contactPhone'] ?? '',
      businessWebsite: widget.roleData['businessWebsite'],
      broadcastType: widget.roleData['broadcastType'] ?? '',
      channelType: widget.roleData['channelType'] ?? '',
      operatingRegions: _getGenresList(widget.roleData['operatingRegions']),
      contentFocus: _getGenresList(widget.roleData['contentFocus']),
      yearsOfOperation: _extractIntValue(widget.roleData['yearsOfOperation']),
      averageDailyViewership: _extractIntValue(
        widget.roleData['averageDailyViewership'],
      ),
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.TV_STATION.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.BUSINESS.value,
      tvStationInfo: tvStationInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleRadioStationSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final radioStationInfo = RadioStationInfo(
      businessName: widget.roleData['businessName'] ?? '',
      businessAddress: widget.roleData['businessAddress'] ?? '',
      rcNumber: widget.roleData['rcNumber'] ?? '',
      tinNumber: widget.roleData['tinNumber'] ?? '',
      contactPhone: widget.roleData['contactPhone'] ?? '',
      businessWebsite: widget.roleData['businessWebsite'],
      broadcastBand: widget.roleData['broadcastBand'] ?? '',
      primaryLanguage: widget.roleData['primaryLanguage'] ?? '',
      operatingRegions: _getGenresList(widget.roleData['operatingRegions']),
      contentFocus: _getGenresList(widget.roleData['contentFocus']),
      yearsOfOperation: _extractIntValue(widget.roleData['yearsOfOperation']),
      averageDailyListenership: _extractIntValue(
        widget.roleData['averageDailyListenership'],
      ),
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.RADIO_STATION.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.BUSINESS.value,
      radioStationInfo: radioStationInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleMediaHouseSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final mediaHouseInfo = MediaHouseInfo(
      businessName: widget.roleData['businessName'] ?? '',
      businessAddress: widget.roleData['businessAddress'] ?? '',
      rcNumber: widget.roleData['rcNumber'] ?? '',
      tinNumber: widget.roleData['tinNumber'] ?? '',
      contactPhone: widget.roleData['contactPhone'] ?? '',
      businessWebsite: widget.roleData['businessWebsite'],
      mediaTypes: _getGenresList(widget.roleData['mediaTypes']),
      operatingRegions: _getGenresList(widget.roleData['operatingRegions']),
      yearsOfOperation: _extractIntValue(widget.roleData['yearsOfOperation']),
      contentFocus: _getGenresList(widget.roleData['contentFocus']),
      estimatedMonthlyReach: _extractIntValue(
        widget.roleData['estimatedMonthlyReach'],
      ),
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.MEDIA_HOUSE.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.BUSINESS.value,
      mediaHouseInfo: mediaHouseInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleInfluencerSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final influencerInfo = InfluencerInfo(
      displayName: widget.roleData['displayName'],
      primaryPlatform: widget.roleData['primaryPlatform'],
      contentCategory: widget.roleData['contentCategory'],
      niche: widget.roleData['niche'],
      audienceSizeRange: widget.roleData['audienceSizeRange'],
      averageEngagementRate: double.tryParse(
        widget.roleData['averageEngagementRate']?.toString() ?? '',
      ),
      contentFormats: _getGenresList(widget.roleData['contentFormats']),
      portfolioLink: widget.roleData['portfolioLink'],
      availabilityType: widget.roleData['availabilityType'] ?? '',
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.INFLUENCER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.INDIVIDUAL.value,
      influencerInfo: influencerInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleUGCCreatorSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final ugcInfo = UGCInfo(
      displayName: widget.roleData['displayName'] ?? '',
      contentStyle: _getGenresList(widget.roleData['contentStyle']),
      niches: _getGenresList(widget.roleData['niches']),
      contentFormats: _getGenresList(widget.roleData['contentFormats']),
      yearsOfExperience: _extractIntValue(widget.roleData['yearsOfExperience']),
      portfolioLink: widget.roleData['portfolioLink'],
      availabilityType: widget.roleData['availabilityType'] ?? '',
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.UGC_CREATOR.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.INDIVIDUAL.value,
      ugcInfo: ugcInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleScreenBillboardSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // Screen Billboard seems to be business-centric based on fields,
    // but we support generic account type selection at the top level.
    // However, the fields are consistent.

    final screenBillboardInfo = ScreenBillboardInfo(
      businessName: widget.roleData['businessName'] ?? '',
      permitNumber: widget.roleData['permitNumber'] ?? '',
      industry: widget.roleData['industry'] ?? '',
      operatingStates: _getGenresList(
        widget.roleData['operatingStates'],
      ), // Reusing list helper
      yearsOfOperation: widget.roleData['yearsOfOperation'],
      businessWebsite: widget.roleData['businessWebsite'],
      businessAddress: widget.roleData['businessAddress'] ?? '',
      idType: widget.roleData['idType'] ?? 'CAC',
      idRcNumber: widget.roleData['idRcNumber'] ?? '',
      tinNumber: widget.roleData['tinNumber'] ?? '',
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.SCREEN_BILLBOARD.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.BUSINESS.value,
      screenBillboardInfo: screenBillboardInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleContentProducerSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final contentProducerInfo = ContentProducerInfo(
      producerName: widget.roleData['producerName'],
      businessName: widget.roleData['businessName'],
      specialization: widget.roleData['specialization'],
      serviceTypes: _getGenresList(widget.roleData['serviceTypes']),
      yearsOfExperience: _extractIntValue(widget.roleData['yearsOfExperience']),
      numberOfProductions: _extractIntValue(
        widget.roleData['numberOfProductions'],
      ),
      portfolioLink: widget.roleData['portfolioLink'],
      availabilityType: widget.roleData['availabilityType'],
      businessAddress: widget.roleData['businessAddress'],
      businessWebsite: widget.roleData['businessWebsite'],
      idType: widget.roleData['idType'],
      idNumber: widget.roleData['idNumber'],
      tinNumber:
          widget.roleData['tinNumber'] ?? _tinNumberController.text, // fallback
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.PRODUCER.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.INDIVIDUAL.value,
      contentProducerInfo: contentProducerInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleAdvertiserSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    AdvertiserInfo? advertiserInfo;

    // Only parameters populated for BUSINESS account type
    if (_selectedAccountType == 'BUSINESS') {
      advertiserInfo = AdvertiserInfo(
        businessName: widget.roleData['businessName'],
        businessAddress: widget.roleData['businessAddress'],
        industry: widget.roleData['industry'],
        telephoneNumber: widget.roleData['businessTelephoneNumber'],
        businessWebsite: widget.roleData['businessWebsite'],
        // Use ID Type controller or default to 'CAC' if RC number is present
        idType: _idTypeController.text.isNotEmpty
            ? _idTypeController.text
            : (widget.roleData['businessRegistrationNumber'] != null
                  ? 'CAC'
                  : null),
        // Prioritize roleData RC number, fallback to ID controller
        idNumber:
            widget.roleData['businessRegistrationNumber'] ??
            _idNumberController.text,
        // Prioritize roleData TIN, fallback to TIN controller
        tinNumber: widget.roleData['tinNumber'] ?? _tinNumberController.text,
      );
    }

    final signUpRequest = SignUpRequest(
      role: 'USER', // Backend requires USER for all roles
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.INDIVIDUAL.value,
      advertiserInfo: advertiserInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleArtistSignup() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // Build ArtistInfo from roleData
    final artistInfo = ArtistInfo(
      stageName: widget.roleData['stageName'] ?? '',
      primaryProfession: widget.roleData['profession'] ?? '',
      specialization: widget.roleData['specialization'] ?? '',
      genres: _getGenresList(widget.roleData['genre']),
      yearsOfExperience: _extractIntValue(widget.roleData['yearsOfExperience']),
      numberOfProductions: _extractIntValue(
        widget.roleData['numberOfProductions'],
      ),
      availabilityType: widget.roleData['availabilityType'] ?? '',
      portfolioLink: widget.roleData['portfolioLink'],
      managementType: widget.roleData['whoManagesYou'] ?? 'SELF',
    );

    final signUpRequest = SignUpRequest(
      role: UserRole.ARTIST.value,
      authProvider: AuthProvider.INTERNAL.value,
      accountType: _selectedAccountType ?? AccountType.INDIVIDUAL.value,
      artistInfo: artistInfo,
      name: _nameController.text,
      emailAddress: _emailController.text,
      phoneNumber: _phoneController.text,
      password: _passwordController.text,
      country: _selectedCountry?.name ?? 'Nigeria',
      state: _selectedState,
      city: _cityController.text.isEmpty ? null : _cityController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
    );

    await authNotifier.signupUser(signUpRequest);
    await _handleSignupResponse();
  }

  Future<void> _handleSignupResponse() async {
    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);

    if (authState.isDataAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.message ?? 'Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to verification screen with email and phone number
      context.push(
        '/verify-identity',
        extra: {
          'email': _emailController.text,
          'phoneNumber': _phoneController.text,
        },
      );
    } else if (authState.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.message!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentStep == 1
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: _previousStep,
              ),
        centerTitle: true,
        title: Text(
          'Account Details',
          style: TextStyle(
            fontSize: 18.rsp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 60.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${_currentStep} of 2',
                  style: TextStyle(
                    fontSize: 12.rsp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.rsp),
                  child: LinearProgressIndicator(
                    value: _currentStep == 1 ? 0.5 : 1.0,
                    minHeight: 6.h,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF2196F3), // Blue color
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Form(
              key: _formKey,
              child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
            ),
            SizedBox(height: 32.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18.rsp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildTextField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: '+234XXXXXXXXXX',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'Enter your email',
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Email is required';
              if (!value!.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location & Security',
          style: TextStyle(
            fontSize: 18.rsp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: CountryPickerField(
            label: 'Country',
            onCountryChanged: (country) {
              setState(() {
                _selectedCountry = country;
                _selectedState = null;
                _cityController.clear();
              });
            },
          ),
        ),
        if (_selectedCountry != null)
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'State/Region',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  decoration: _inputDecoration('Select state/region'),
                  items: (statesByCountry[_selectedCountry!.name] ?? [])
                      .map(
                        (state) =>
                            DropdownMenuItem(value: state, child: Text(state)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedState = value;
                    _cityController.clear();
                  }),
                  validator: (value) =>
                      value == null ? 'State is required' : null,
                ),
              ],
            ),
          ),
        if (_selectedState != null)
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'City',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                DropdownButtonFormField<String>(
                  value: _cityController.text.isEmpty
                      ? null
                      : _cityController.text,
                  decoration: _inputDecoration('Select city'),
                  items: (citiesByState[_selectedState] ?? [])
                      .map(
                        (city) =>
                            DropdownMenuItem(value: city, child: Text(city)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _cityController.text = value;
                      setState(() {});
                    }
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'City is required'
                      : null,
                ),
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildTextField(
            controller: _addressController,
            label: 'Address',
            hint: 'Enter your address',
            maxLines: 2,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            isPassword: true,
            passwordVisible: _passwordVisible,
            onPasswordToggle: () =>
                setState(() => _passwordVisible = !_passwordVisible),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Password is required';
              if ((value?.length ?? 0) < 6)
                return 'Password must be at least 6 characters';
              return null;
            },
          ),
        ),
        // Business-specific fields - only for Advertiser and Host roles with BUSINESS account type
        if (_selectedAccountType == 'BUSINESS' &&
                (widget.role.toUpperCase() == 'ADVERTISER' ||
                    widget.role.toUpperCase() == 'HOST') ||
            widget.role.toUpperCase() == 'DESIGNER') ...[
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildTextField(
              controller: _idTypeController,
              label: 'ID Type (Optional)',
              hint: 'e.g., National ID, International Passport',
              isRequired: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildTextField(
              controller: _idNumberController,
              label: 'ID Number',
              hint: 'Enter your ID number',
              validator: (value) => value?.isEmpty ?? true
                  ? 'ID Number is required for business accounts'
                  : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildTextField(
              controller: _tinNumberController,
              label: 'TIN Number',
              hint: 'Enter your Tax Identification Number',
            ),
          ),
        ],
        Padding(
          padding: EdgeInsets.only(bottom: 0),
          child: _buildTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Confirm your password',
            isPassword: true,
            passwordVisible: _confirmPasswordVisible,
            onPasswordToggle: () => setState(
              () => _confirmPasswordVisible = !_confirmPasswordVisible,
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please confirm your password';
              if (value != _passwordController.text)
                return 'Passwords do not match';
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    bool isRequired = true,
    String? Function(String?)? validator,
    bool isPassword = false,
    bool? passwordVisible,
    VoidCallback? onPasswordToggle,
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
          obscureText: isPassword && !(passwordVisible ?? false),
          decoration: _inputDecoration(
            hint,
            isPassword: isPassword,
            passwordVisible: passwordVisible,
            onPasswordToggle: onPasswordToggle,
          ),
          validator:
              validator ??
              (isRequired
                  ? (value) =>
                        value?.isEmpty ?? true ? '$label is required' : null
                  : null),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
    String hint, {
    bool isPassword = false,
    bool? passwordVisible,
    VoidCallback? onPasswordToggle,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.rsp),
      suffixIcon: isPassword
          ? IconButton(
              onPressed: onPasswordToggle,
              icon: Icon(
                passwordVisible ?? false
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
            )
          : null,
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
        borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.rsp),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.rsp),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      contentPadding: PlatformResponsive.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

  Widget _buildActionButtons() {
    final authState = ref.watch(authNotifierProvider);
    final isApiLoading = authState.isInitialLoading;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: isApiLoading
                ? null
                : _currentStep == 1
                ? _nextStep
                : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.rsp),
              ),
              elevation: 0,
            ),
            child: isApiLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _currentStep == 1 ? 'Next' : 'Create Account',
                    style: TextStyle(
                      fontSize: 16.rsp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
