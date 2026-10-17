import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../logic/auth_notifiers.dart';
import '../../../logic/signup_handlers/signup_handler_factory.dart';
import '../../../../../core/constants/enum.dart';
import '../../../../../core/constants/location_constants.dart';

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
  int _currentStep = 1;
  final _formKey = GlobalKey<FormState>();
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
  late TextEditingController _idTypeController;
  late TextEditingController _idNumberController;
  late TextEditingController _tinNumberController;
  Country? _selectedCountry;
  bool _countryError = false;
  String? _selectedState;
  String? _selectedLGA;
  List<String> _availableLGAs = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _idTypeController = TextEditingController();
    _idNumberController = TextEditingController();
    _tinNumberController = TextEditingController();

    if (widget.roleData['businessRegistrationNumber'] != null) {
      _idNumberController.text = widget.roleData['businessRegistrationNumber'].toString();
      _idTypeController.text = widget.roleData['idType']?.toString() ?? 'CAC';
    } else if (widget.roleData['idNumber'] != null) {
      _idNumberController.text = widget.roleData['idNumber'].toString();
      _idTypeController.text = widget.roleData['idType']?.toString() ?? 'CAC';
    }
    if (widget.roleData['tinNumber'] != null) {
      _tinNumberController.text = widget.roleData['tinNumber'].toString();
    }

    // Pre-fill business/personal details from roleData (BRT-039)
    final preName = widget.roleData['businessName'] ?? widget.roleData['fullName'] ?? widget.roleData['name'];
    if (preName != null && preName.toString().isNotEmpty) {
      _nameController.text = preName.toString();
    }
    final prePhone = widget.roleData['businessTelephoneNumber'] ?? widget.roleData['phoneNumber'];
    if (prePhone != null && prePhone.toString().isNotEmpty) {
      String cleanPhone = prePhone.toString().replaceAll(RegExp(r'\D'), '');
      if (cleanPhone.startsWith('234')) cleanPhone = cleanPhone.substring(3);
      if (cleanPhone.startsWith('0')) cleanPhone = cleanPhone.substring(1);
      _phoneController.text = cleanPhone;
    }
    final preEmail = widget.roleData['email'];
    if (preEmail != null && preEmail.toString().isNotEmpty) {
      _emailController.text = preEmail.toString().trim();
    }
    final preAddress = widget.roleData['businessAddress'] ?? widget.roleData['streetAddress'];
    if (preAddress != null && preAddress.toString().isNotEmpty) {
      _addressController.text = preAddress.toString();
    }
    if (widget.roleData['state'] != null && widget.roleData['state'].toString().isNotEmpty) {
      _selectedState = widget.roleData['state'].toString();
      _availableLGAs = LocationHelper.getLGAsForState(_selectedState!);
      if (widget.roleData['city'] != null && _availableLGAs.contains(widget.roleData['city'].toString())) {
        _selectedLGA = widget.roleData['city'].toString();
      }
    }

    final preCountry = widget.roleData['country']?.toString();
    if (preCountry != null && preCountry.isNotEmpty) {
      _selectedCountry = Country.tryParse(preCountry);
    }
    _selectedCountry ??= Country.tryParse('NG') ?? Country(
      phoneCode: '234',
      countryCode: 'NG',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'Nigeria',
      example: 'Nigeria',
      displayName: 'Nigeria',
      displayNameNoCountryCode: 'Nigeria',
      e164Key: '',
    );

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
    if (accountType.toUpperCase().contains('BUSINESS') ||
        accountType.toUpperCase().contains('COMPANY')) {
      return 'BUSINESS';
    }
    return 'PERSONAL';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _idTypeController.dispose();
    _idNumberController.dispose();
    _tinNumberController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: isError
              ? Colors.red.shade700
              : (message.toLowerCase().contains('please')
                  ? Colors.orange.shade800
                  : Colors.green.shade700),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          margin: EdgeInsets.all(16.w),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  void _nextStep() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() => _currentStep = 2);
    }
  }

  void _previousStep() {
    FocusScope.of(context).unfocus();
    setState(() => _currentStep = 1);
  }

  String _getFormattedPhoneNumber() {
    String cleanPhone = _phoneController.text.trim().replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.startsWith('234')) {
      cleanPhone = cleanPhone.substring(3);
    }
    if (!cleanPhone.startsWith('0')) {
      cleanPhone = '0$cleanPhone';
    }
    return cleanPhone;
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_selectedCountry == null) {
      setState(() => _countryError = true);
      _showSnackBar('Please select your country', isError: true);
      return;
    }

    final name = _nameController.text.trim();
    if (name.isEmpty || name.split(RegExp(r'\s+')).length < 2 || RegExp(r'^\d+$').hasMatch(name)) {
      setState(() => _currentStep = 1);
      _showSnackBar('Please enter a valid first and last name in Step 1', isError: true);
      return;
    }

    final formattedEmail = _emailController.text.trim().toLowerCase();
    final emailRegex = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$');
    if (!emailRegex.hasMatch(formattedEmail) || !formattedEmail.contains('.')) {
      setState(() => _currentStep = 1);
      _showSnackBar('Please enter a valid email address in Step 1', isError: true);
      return;
    }

    final phoneDigits = _phoneController.text.trim().replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.length < 10 || phoneDigits.length > 11) {
      setState(() => _currentStep = 1);
      _showSnackBar('Please enter a valid phone number in Step 1', isError: true);
      return;
    }

    final handler = SignupHandlerFactory.getHandler(widget.role);
    
    if (handler == null) {
      _showSnackBar('Signup for ${widget.role} is not yet implemented.', isError: true);
      return;
    }

    try {
      final formattedPhone = _getFormattedPhoneNumber();

      final signUpRequest = await handler.createSignupRequest(
        roleData: widget.roleData,
        name: _nameController.text.trim(),
        email: formattedEmail,
        phone: formattedPhone,
        password: _passwordController.text,
        country: _selectedCountry?.name,
        state: _selectedState,
        city: _selectedLGA,
        address: _addressController.text.isEmpty ? null : _addressController.text.trim(),
        accountType: _selectedAccountType ?? AccountType.INDIVIDUAL.value,
        idType: _idTypeController.text.isNotEmpty
            ? _idTypeController.text.trim()
            : (widget.roleData['businessRegistrationNumber'] != null ? 'CAC' : widget.roleData['idType']),
        idNumber: _idNumberController.text.isNotEmpty
            ? _idNumberController.text.trim()
            : (widget.roleData['businessRegistrationNumber'] ?? widget.roleData['idNumber']),
        tinNumber: _tinNumberController.text.isNotEmpty
            ? _tinNumberController.text.trim()
            : widget.roleData['tinNumber'],
      );

      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.signupUser(signUpRequest);
      await _handleSignupResponse(formattedEmail, formattedPhone);
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', isError: true);
    }
  }

  Future<void> _handleSignupResponse(String email, String phone) async {
    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);

    if (authState.isDataAvailable) {
      _showSnackBar(
        authState.message ?? 'Account created successfully!',
        isError: false,
      );
      context.push(
        '/verify-identity',
        extra: {
          'email': email,
          'phoneNumber': phone,
        },
      );
    } else if (authState.message != null) {
      _showSnackBar(authState.message!, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryBg = isDark ? const Color(0xFF12151B) : Colors.white;

    return Scaffold(
      backgroundColor: primaryBg,
      appBar: AppBar(
        backgroundColor: primaryBg,
        elevation: 0,
        leading: _currentStep == 1
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
                onPressed: () => context.pop(),
              )
            : IconButton(
                icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
                onPressed: _previousStep,
              ),
        centerTitle: true,
        title: Text(
          'Account Details',
          style: TextStyle(
            fontSize: 18.rsp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
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
                    color: isDark ? Colors.white : AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.rsp),
                  child: LinearProgressIndicator(
                    value: _currentStep == 1 ? 0.5 : 1.0,
                    minHeight: 6.h,
                    backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF2196F3),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Form(
              key: _formKey,
              child: _currentStep == 1 ? _buildStep1(isDark) : _buildStep2(isDark),
            ),
            SizedBox(height: 32.h),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18.rsp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            isDark: isDark,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full Name is required';
              }
              final trimmed = value.trim();
              if (RegExp(r'^\d+$').hasMatch(trimmed)) {
                return 'Name cannot contain only numbers';
              }
              if (trimmed.split(RegExp(r'\s+')).length < 2) {
                return 'Please enter your first and last name';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildTextField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: '8012345678',
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            prefixIcon: Container(
              margin: EdgeInsets.only(right: 8.w, left: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇳🇬', style: TextStyle(fontSize: 16.sp)),
                  SizedBox(width: 6.w),
                  Text(
                    '+234',
                    style: TextStyle(
                      fontSize: 14.rsp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 1,
                    height: 20.h,
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                ],
              ),
            ),
            isDark: isDark,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone number is required';
              }
              final digits = value.replaceAll(RegExp(r'\D'), '');
              if (digits.startsWith('0')) {
                if (digits.length != 11) {
                  return 'Enter a valid 11-digit phone number starting with 0';
                }
              } else {
                if (digits.length != 10) {
                  return 'Enter 10 digits after +234 (e.g. 8012345678)';
                }
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            isDark: isDark,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email address is required';
              }
              final email = value.trim();
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
              );
              if (!emailRegex.hasMatch(email) || !email.contains('.')) {
                return 'Please enter a valid email address (e.g., name@example.com)';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildStep2(bool isDark) {
    final nigerianStates = NigerianStatesAndLGA.allStates;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location & Security',
          style: TextStyle(
            fontSize: 18.rsp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 24.h),
        // Country Picker
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Country',
                      style: TextStyle(
                        fontSize: 14.rsp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
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
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    onSelect: (Country country) {
                      setState(() {
                        _selectedCountry = country;
                        _countryError = false;
                        _selectedState = null;
                        _selectedLGA = null;
                        _availableLGAs = [];
                      });
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E232D) : Colors.grey[50],
                    border: Border.all(
                      color: _countryError
                          ? Colors.red
                          : (isDark ? Colors.white12 : Colors.grey.shade300),
                      width: _countryError ? 1.5 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCountry?.name ?? 'Select Country',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: _selectedCountry == null
                              ? Colors.grey[400]
                              : (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: isDark ? Colors.grey[400] : Colors.grey),
                    ],
                  ),
                ),
              ),
              if (_countryError)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, left: 4.w),
                  child: Text(
                    'Country is required',
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
            ],
          ),
        ),
        // State Dropdown (for Nigeria)
        if (_selectedCountry?.name == 'Nigeria')
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'State',
                        style: TextStyle(
                          fontSize: 14.rsp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
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
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  dropdownColor: isDark ? const Color(0xFF1E232D) : Colors.white,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14.rsp),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E232D) : Colors.grey[50],
                    hintText: 'Select State',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.rsp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.rsp),
                      borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.rsp),
                      borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.rsp),
                      borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                    ),
                    contentPadding: PlatformResponsive.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  items: nigerianStates.map((state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state, style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black87)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value;
                      _selectedLGA = null;
                      if (value != null) {
                        _availableLGAs = LocationHelper.getLGAsForState(value);
                      } else {
                        _availableLGAs = [];
                      }
                    });
                  },
                  validator: (value) => value == null ? 'State is required' : null,
                ),
              ],
            ),
          ),
        // LGA/City Dropdown (for Nigeria)
        if (_selectedCountry?.name == 'Nigeria' && _selectedState != null)
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Local Government Area (LGA)',
                        style: TextStyle(
                          fontSize: 14.rsp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
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
                DropdownButtonFormField<String>(
                  key: ValueKey('lga_${_selectedState}_${_availableLGAs.length}'),
                  value: (_selectedLGA != null && _availableLGAs.contains(_selectedLGA)) ? _selectedLGA : null,
                  dropdownColor: isDark ? const Color(0xFF1E232D) : Colors.white,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14.rsp),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E232D) : Colors.grey[50],
                    hintText: _availableLGAs.isEmpty 
                        ? 'No LGAs available' 
                        : 'Select LGA',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.rsp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.rsp),
                      borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.rsp),
                      borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.rsp),
                      borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                    ),
                    contentPadding: PlatformResponsive.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  items: _availableLGAs.isEmpty
                      ? [
                          DropdownMenuItem<String>(
                            value: null,
                            enabled: false,
                            child: Text(
                              'No LGAs available for this state',
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                            ),
                          )
                        ]
                      : _availableLGAs.map((lga) {
                          return DropdownMenuItem<String>(
                            value: lga,
                            child: Text(lga, style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black87)),
                          );
                        }).toList(),
                  onChanged: _availableLGAs.isEmpty
                      ? null
                      : (value) {
                          setState(() {
                            _selectedLGA = value;
                          });
                        },
                  validator: (value) => value == null ? 'LGA is required' : null,
                ),
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildTextField(
            controller: _addressController,
            label: 'Street Address',
            hint: 'Enter your street address',
            maxLines: 2,
            isDark: isDark,
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
            isDark: isDark,
            onPasswordToggle: () =>
                setState(() => _passwordVisible = !_passwordVisible),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Password is required';
              final val = value.trim();
              if (val.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              if (!RegExp(r'[A-Z]').hasMatch(val)) {
                return 'Password must contain at least one uppercase letter';
              }
              if (!RegExp(r'[a-z]').hasMatch(val)) {
                return 'Password must contain at least one lowercase letter';
              }
              if (!RegExp(r'[0-9]').hasMatch(val)) {
                return 'Password must contain at least one number';
              }
              if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>\-_]').hasMatch(val)) {
                return 'Password must contain at least one special character';
              }
              return null;
            },
          ),
        ),
        if (_selectedAccountType == 'BUSINESS' &&
            widget.roleData['businessRegistrationNumber'] == null &&
            widget.roleData['idNumber'] == null) ...[
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildTextField(
              controller: _idTypeController,
              label: 'ID Type',
              hint: 'e.g., CAC, Business Permit, National ID',
              isRequired: true,
              isDark: isDark,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'ID Type is required for business accounts'
                  : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _buildTextField(
              controller: _idNumberController,
              label: 'ID / Registration Number',
              hint: 'Enter your ID or registration number',
              isRequired: true,
              isDark: isDark,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'ID Number is required for business accounts'
                  : null,
            ),
          ),
          if (widget.roleData['tinNumber'] == null)
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildTextField(
                controller: _tinNumberController,
                label: 'TIN Number (Optional)',
                hint: 'Enter your Tax Identification Number',
                isRequired: false,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                ],
                isDark: isDark,
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
            isDark: isDark,
            onPasswordToggle: () => setState(
              () => _confirmPasswordVisible = !_confirmPasswordVisible,
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please confirm your password';
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
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
    bool isDark = false,
    Widget? prefixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
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
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              if (isRequired)
                const TextSpan(
                  text: '*',
                  style: TextStyle(
                    fontSize: 14,
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
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14.rsp),
          decoration: _inputDecoration(
            hint,
            isPassword: isPassword,
            passwordVisible: passwordVisible,
            onPasswordToggle: onPasswordToggle,
            isDark: isDark,
            prefixIcon: prefixIcon,
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
    bool isDark = false,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? const Color(0xFF1E232D) : Colors.grey[50],
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.rsp),
      prefixIcon: prefixIcon,
      suffixIcon: isPassword
          ? IconButton(
              onPressed: onPasswordToggle,
              icon: Icon(
                passwordVisible ?? false
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: isDark ? Colors.grey[400] : Colors.grey,
              ),
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.rsp),
        borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.rsp),
        borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.rsp),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
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
