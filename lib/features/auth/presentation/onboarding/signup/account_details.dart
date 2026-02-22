import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import '../../../../../core/utils/color_utils.dart' hide AppColors;
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../logic/auth_notifiers.dart';
import '../../../logic/signup_handlers/signup_handler_factory.dart';
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
    if (!_formKey.currentState!.validate()) return;

    final handler = SignupHandlerFactory.getHandler(widget.role);
    
    if (handler == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup for ${widget.role} is not yet implemented.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final signUpRequest = await handler.createSignupRequest(
        roleData: widget.roleData,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        country: _selectedCountry?.name,
        state: _selectedState,
        city: _selectedLGA,
        address: _addressController.text.isEmpty ? null : _addressController.text,
        accountType: _selectedAccountType ?? AccountType.INDIVIDUAL.value,
        idType: _idTypeController.text.isNotEmpty ? _idTypeController.text : null,
        idNumber: _idNumberController.text.isNotEmpty ? _idNumberController.text : null,
        tinNumber: _tinNumberController.text.isNotEmpty ? _tinNumberController.text : null,
      );

      final authNotifier = ref.read(authNotifierProvider.notifier);
      await authNotifier.signupUser(signUpRequest);
      await _handleSignupResponse();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                      const Color(0xFF2196F3),
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
    final nigerianStates = NigerianStatesAndLGA.allStates;
    
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
                        color: Colors.black,
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
                        // Reset state and LGA when country changes
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
                    border: Border.all(color: Colors.grey.shade300),
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
                              : Colors.black,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
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
                          color: Colors.black,
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
                  decoration: InputDecoration(
                    hintText: 'Select State',
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
                      borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
                    ),
                    contentPadding: PlatformResponsive.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  items: nigerianStates.map((state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state, style: TextStyle(fontSize: 14.sp)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value;
                      _selectedLGA = null;
                      if (value != null) {
                        _availableLGAs = NigerianStatesAndLGA.getStateLGAs(value);
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
                          color: Colors.black,
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
                  value: _selectedLGA,
                  decoration: InputDecoration(
                    hintText: _availableLGAs.isEmpty 
                        ? 'No LGAs available' 
                        : 'Select LGA',
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
                      borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
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
                            child: Text(lga, style: TextStyle(fontSize: 14.sp)),
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
