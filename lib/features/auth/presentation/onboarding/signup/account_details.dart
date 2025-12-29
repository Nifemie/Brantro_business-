import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../core/constants/location_constants.dart';
import '../../../../../controllers/re_useable/country_picker_field.dart';

class AccountDetailsScreen extends StatefulWidget {
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
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Combine all data
      final submissionData = {
        'name': _nameController.text,
        'phoneNumber': _phoneController.text,
        'emailAddress': _emailController.text,
        'accountType': _selectedAccountType,
        'role': widget.role.toUpperCase(),
        'authProvider': 'INTERNAL',
        'country': _selectedCountry?.name ?? '',
        'countryCode': _selectedCountry?.countryCode ?? '',
        'state': _selectedState ?? '',
        'city': _cityController.text,
        'address': _addressController.text,
        'password': _passwordController.text,
        'roleData': widget.roleData,
        if (_selectedAccountType == 'BUSINESS' &&
            (widget.role.toUpperCase() == 'ADVERTISER' ||
                widget.role.toUpperCase() == 'HOST')) ...{
          'idType': _idTypeController.text,
          'idNumber': _idNumberController.text,
          'tinNumber': _tinNumberController.text,
        },
      };

      try {
        // TODO: Replace with actual API call
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          context.push(
            '/verify-identity',
            extra: {'email': _emailController.text},
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
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
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: 60.h,
        ),
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
                widget.role.toUpperCase() == 'HOST')) ...[
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
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : (_currentStep == 1 ? _nextStep : _submitForm),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3), // Blue color
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.rsp),
              ),
              elevation: 0,
            ),
            child: _isLoading
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
