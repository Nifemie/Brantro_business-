import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/kyc_constants.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/custom_dropdown_field.dart';
import '../../../core/service/session_service.dart';
import '../data/kyc_models.dart';

class KycFormScreen extends ConsumerStatefulWidget {
  const KycFormScreen({super.key});

  @override
  ConsumerState<KycFormScreen> createState() => _KycFormScreenState();
}

class _KycFormScreenState extends ConsumerState<KycFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _documentNumberController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedDocumentType;
  bool _isBusinessAccount = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userJson = await SessionService.getUser();
    if (userJson != null && mounted) {
      setState(() {
        // Pre-fill user data
        _fullNameController.text = userJson['name'] ?? '';
        _phoneNumberController.text = userJson['phoneNumber'] ?? '';
        _addressController.text = userJson['address'] ?? '';
        
        // Determine account type (INDIVIDUAL or BUSINESS)
        final accountType = userJson['accountType']?.toString().toUpperCase();
        _isBusinessAccount = accountType == 'BUSINESS';
        
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _documentNumberController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _getDocumentTypeOptions() {
    return _isBusinessAccount
        ? BUSINESS_DOCUMENT_TYPES
        : INDIVIDUAL_DOCUMENT_TYPES;
  }

  String? _validateDocumentNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Document number is required';
    }

    if (_selectedDocumentType != null) {
      return KycValidationRules.getDocumentNumberError(
        _selectedDocumentType!,
        value,
      );
    }

    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDocumentType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a document type')),
        );
        return;
      }

      final request = KycVerificationRequest(
        documentType: _selectedDocumentType!,
        documentNumber: _documentNumberController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        address: _addressController.text.trim(),
      );

      // Navigate to submission screen
      context.push('/kyc/submit', extra: request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'KYC Verification Form',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(20.w),
                  children: [
              // Account Type Indicator
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isBusinessAccount
                          ? Icons.business
                          : Icons.person_outline,
                      color: AppColors.primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _isBusinessAccount
                          ? 'Business Account Verification'
                          : 'Individual Account Verification',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Document Type Dropdown
              Text(
                'Document Type',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              CustomDropdownField(
                label: '',
                hint: 'Select document type',
                options: _getDocumentTypeOptions(),
                isRequired: true,
                onChanged: (value) {
                  setState(() {
                    _selectedDocumentType = value;
                    _documentNumberController.clear();
                  });
                },
              ),
              SizedBox(height: 20.h),

              // Document Number
              Text(
                'Document Number',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _documentNumberController,
                decoration: _inputDecoration(
                  _selectedDocumentType == 'NIN'
                      ? 'Enter 11-digit NIN'
                      : _selectedDocumentType == 'CAC'
                          ? 'Enter CAC number (e.g., RC1234567)'
                          : 'Enter document number',
                ),
                keyboardType: _selectedDocumentType == 'NIN'
                    ? TextInputType.number
                    : TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                validator: _validateDocumentNumber,
              ),
              SizedBox(height: 20.h),

              // Full Name
              Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _fullNameController,
                decoration: _inputDecoration(
                  _isBusinessAccount
                      ? 'Enter business name'
                      : 'Enter your full legal name',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Full name is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),

              // Phone Number
              Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _phoneNumberController,
                decoration: _inputDecoration('Enter phone number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!KycValidationRules.isValidPhoneNumber(value)) {
                    return 'Enter a valid Nigerian phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),

              // Address
              Text(
                'Address',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _addressController,
                decoration: _inputDecoration(
                  _isBusinessAccount
                      ? 'Enter business address'
                      : 'Enter your residential address',
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Address is required';
                  }
                  if (value.trim().length < 10) {
                    return 'Please enter a complete address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),

              // Info Box
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Please ensure all information matches your official documents. Incorrect information may delay verification.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.blue[900],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Submit for Verification',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: Colors.grey[400],
      ),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }
}
