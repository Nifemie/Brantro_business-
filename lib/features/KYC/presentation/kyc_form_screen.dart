import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/kyc_constants.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/custom_dropdown_field.dart';
import '../../../core/service/session_service.dart';
import '../data/kyc_models.dart';
import '../logic/kyc_provider.dart';

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

  String _selectedDocumentType = 'NIN'; // Default to NIN matching mockup
  bool _isBusinessAccount = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await ref.read(kycProvider.notifier).fetchKycStatus();
        if (mounted) {
          final kycState = ref.read(kycProvider);
          final statusResp = kycState.statusResponse;
          final status = kycState.verificationStatus;

          final isFaceReq = statusResp?.status == 'FACE_REQUIRED' ||
              statusResp?.message?.contains('NIN verification completed') == true;

          if (isFaceReq ||
              status == KycVerificationStatus.inReview ||
              status == KycVerificationStatus.pending) {
            context.go('/kyc/status');
          } else if (status == KycVerificationStatus.approved) {
            context.go('/dashboard');
          }
        }
      }
    });
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
    if (value == null || value.trim().isEmpty) {
      return 'Document number is required';
    }
    return KycValidationRules.getDocumentNumberError(
      _selectedDocumentType,
      value.trim(),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final request = KycVerificationRequest(
        documentType: _selectedDocumentType,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final kycState = ref.watch(kycProvider);

    return Scaffold(
      backgroundColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Identity Verification',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
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
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  // CARD 1: KYC Verification Form
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? theme.cardTheme.color ?? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: KYC Verification & Account type badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'KYC Verification',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Account: ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF5E72E4).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      _isBusinessAccount ? 'BUSINESS' : 'INDIVIDUAL',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF5E72E4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Divider(color: isDark ? Colors.grey[800] : Colors.grey[100]),
                          SizedBox(height: 16.h),

                          // Document Type
                          _buildLabel('Document Type', required: true),
                          SizedBox(height: 8.h),
                          CustomDropdownField(
                            label: '',
                            hint: 'Select document type',
                            initialValue: _selectedDocumentType,
                            options: _getDocumentTypeOptions(),
                            isRequired: true,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedDocumentType = value;
                                  _documentNumberController.clear();
                                });
                              }
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Document Number
                          _buildLabel(
                            _selectedDocumentType == 'NIN'
                                ? 'NIN Number (11 digits)'
                                : _selectedDocumentType == 'CAC'
                                    ? 'CAC Registration Number'
                                    : 'Document Number',
                            required: true,
                          ),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: _documentNumberController,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 14.sp,
                            ),
                            decoration: _inputDecoration(
                              _selectedDocumentType == 'NIN'
                                  ? 'e.g. 12345678901 (11 digits)'
                                  : _selectedDocumentType == 'CAC'
                                      ? 'e.g. RC1234567'
                                      : 'Enter number',
                              isDark,
                            ),
                            keyboardType: _selectedDocumentType == 'NIN'
                                ? TextInputType.number
                                : TextInputType.text,
                            inputFormatters: _selectedDocumentType == 'NIN'
                                ? [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ]
                                : [
                                    LengthLimitingTextInputFormatter(14),
                                  ],
                            textCapitalization: TextCapitalization.characters,
                            validator: _validateDocumentNumber,
                          ),
                          SizedBox(height: 16.h),

                          // Full Name
                          _buildLabel('Full Name', required: true),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: _fullNameController,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 14.sp,
                            ),
                            decoration: _inputDecoration(
                              _isBusinessAccount
                                  ? 'Enter business name'
                                  : 'Enter your full legal name',
                              isDark,
                            ),
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Full name is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Phone Number
                          _buildLabel('Phone Number', required: true),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: _phoneNumberController,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 14.sp,
                            ),
                            decoration: _inputDecoration('e.g. 08012345678', isDark),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              if (!KycValidationRules.isValidPhoneNumber(value)) {
                                return 'Enter a valid 10 or 11 digit Nigerian phone number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Row 3: Address (Takes full width for better form presentation)
                          _buildLabel('Address', required: true),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: _addressController,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 14.sp,
                            ),
                            decoration: _inputDecoration(
                              _isBusinessAccount
                                  ? 'Enter business address'
                                  : 'Enter residential address',
                              isDark,
                            ),
                            maxLines: 2,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                  return 'Address is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),

                          // Continue Button aligned to bottom right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF003380),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // CARD 2: My KYC Status
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? theme.cardTheme.color ?? Colors.grey[900] : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Title & Refresh button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My KYC Status',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref.read(kycProvider.notifier).fetchKycStatus();
                              },
                              icon: Icon(
                                Icons.refresh,
                                size: 18.sp,
                                color: isDark ? Colors.white70 : Colors.grey[700],
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              style: IconButton.styleFrom(
                                backgroundColor: isDark ? Colors.grey[800] : const Color(0xFFEDF2F7),
                                padding: EdgeInsets.all(8.w),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Divider(color: isDark ? Colors.grey[800] : Colors.grey[100]),
                        SizedBox(height: 16.h),

                        // Current Status Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current Status',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark ? Colors.grey[300] : Colors.grey[600],
                              ),
                            ),
                            _buildStatusBadge(kycState.verificationStatus, kycState.statusResponse?.status),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Inner Details Box
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isDark ? Colors.grey[800]! : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Document',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    kycState.statusResponse?.submittedData?.documentType ?? _selectedDocumentType,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Number',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                                    ),
                                  ),
                                  Text(
                                    kycState.statusResponse?.submittedData?.documentNumber ?? '-',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // History section
                        Text(
                          'History',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey[300] : const Color(0xFF4A5568),
                          ),
                        ),
                        SizedBox(height: 12.h),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isDark ? Colors.grey[800]! : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'History',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF1A2B4B),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'No history available',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusBadge(KycVerificationStatus statusEnum, String? statusText) {
    Color bg = const Color(0xFF718096).withOpacity(0.15);
    Color text = const Color(0xFF718096);
    String label = 'N/A';

    switch (statusEnum) {
      case KycVerificationStatus.approved:
        bg = const Color(0xFF2D3748); // Dark color matching mockup badge
        text = Colors.white;
        label = 'APPROVED';
        break;
      case KycVerificationStatus.pending:
      case KycVerificationStatus.inReview:
        bg = const Color(0xFFD69E2E).withOpacity(0.15);
        text = const Color(0xFFD69E2E);
        label = 'PENDING';
        break;
      case KycVerificationStatus.rejected:
        bg = const Color(0xFFE53E3E).withOpacity(0.15);
        text = const Color(0xFFE53E3E);
        label = 'REJECTED';
        break;
      default:
        bg = const Color(0xFF718096).withOpacity(0.15);
        text = const Color(0xFF718096);
        label = statusText?.toUpperCase() ?? 'N/A';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.grey[300] : const Color(0xFF4A5568),
        ),
        children: required
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ]
            : [],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: isDark ? Colors.white38 : Colors.grey[400],
      ),
      filled: true,
      fillColor: isDark ? Colors.grey[850] : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    );
  }
}
