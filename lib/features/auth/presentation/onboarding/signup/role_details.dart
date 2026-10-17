import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/color_utils.dart';
import '../../../../../core/utils/platform_responsive.dart';
import '../../../../../controllers/re_useable/custom_dropdown_field.dart';
import '../../../../../controllers/re_useable/custom_multiselect_dropdown_field.dart';
import '../../../../../controllers/re_useable/account_type_tab.dart';
import '../../../logic/role_form_configs/role_form_config_factory.dart';
import '../../../logic/role_details_handler.dart';
import '../../../logic/role_form_state_manager.dart';

class RoleDetailsScreen extends ConsumerStatefulWidget {
  final String role;
  final String accountType;

  const RoleDetailsScreen({
    required this.role,
    required this.accountType,
    super.key,
  });

  @override
  ConsumerState<RoleDetailsScreen> createState() => _RoleDetailsScreenState();
}

class _RoleDetailsScreenState extends ConsumerState<RoleDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String _selectedAccountType;
  late RoleFormStateManager _formStateManager;

  @override
  void initState() {
    super.initState();
    _selectedAccountType = widget.accountType;
    final formConfig = RoleFormConfigFactory.getConfig(widget.role);
    _formStateManager = RoleFormStateManager(formConfig);
    _formStateManager.initializeControllers(_selectedAccountType);
  }

  List<Map<String, dynamic>> _getFormFields() {
    return _formStateManager.getFormFields(_selectedAccountType);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final handler = RoleDetailsHandler(ref, context);
        final formData = handler.collectFormData(_formStateManager.controllers);

        await handler.handleSubmit(
          role: widget.role,
          accountType: _selectedAccountType,
          formData: formData,
          setLoading: (loading) {
            if (mounted) {
              setState(() => _isLoading = loading);
            }
          },
        );
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted && _isLoading) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryBg = isDark ? const Color(0xFF12151B) : Colors.white;
    final fields = _getFormFields();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: primaryBg,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '${widget.role} Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      backgroundColor: primaryBg,
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
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Please fill in the details below to set up your account',
                  style: TextStyle(
                    fontSize: 14.rsp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 32.h),

                if (_formStateManager.formConfig.supportsAccountTypes) ...[
                  AccountTypeTab(
                    selectedType: _selectedAccountType,
                    onTypeChanged: (newType) {
                      setState(() {
                        _selectedAccountType = newType;
                        _formStateManager.clearControllers();
                        _formStateManager.initializeControllers(newType);
                      });
                    },
                  ),
                  SizedBox(height: 32.h),
                ],

                // Dynamic Form Fields
                ...fields.map((field) {
                  final fieldType = field['type'] as String? ?? 'text';
                  final fieldName = field['name'] as String;
                  final fieldLabel = field['label'] as String;
                  final bool isOptional = fieldLabel.toLowerCase().contains('optional') ||
                      field['required'] == false ||
                      field['isRequired'] == false;
                  final isFieldRequired = !isOptional &&
                      ((field['isRequired'] as bool?) ??
                          (field['required'] as bool?) ??
                          false);

                  if (fieldType == 'dropdown') {
                    final currentValue = _formStateManager.controllers[fieldName]?.text;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CustomDropdownField(
                        key: ValueKey('dropdown_$fieldName'),
                        label: fieldLabel,
                        hint: field['hint'] as String?,
                        initialValue: currentValue != null && currentValue.isNotEmpty ? currentValue : null,
                        options: field['options'] as List<Map<String, String>>,
                        isRequired: isFieldRequired,
                        onChanged: (value) {
                          setState(() {
                            _formStateManager.handleDropdownChange(fieldName, value);
                          });
                        },
                      ),
                    );
                  } else if (fieldType == 'multiselect') {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CustomMultiselectDropdownField(
                        label: fieldLabel,
                        hint: field['hint'] as String?,
                        options: field['options'] as List<Map<String, String>>,
                        isRequired: isFieldRequired,
                        onChanged: (values) {
                          setState(() {
                            _formStateManager.handleMultiselectChange(fieldName, values);
                          });
                        },
                      ),
                    );
                  } else {
                    // Text or password field
                    final isPassword = fieldType == 'password';
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _buildTextField(
                        controller: _formStateManager.controllers[fieldName]!,
                        fieldName: fieldName,
                        label: fieldLabel,
                        hint: field['hint'] as String?,
                        maxLines: field['maxLines'] as int? ?? 1,
                        isRequired: isFieldRequired,
                        isPassword: isPassword,
                        isDark: isDark,
                      ),
                    );
                  }
                }).toList(),

                SizedBox(height: 24.h),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
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
    String fieldName = '',
    int maxLines = 1,
    bool isRequired = true,
    bool isPassword = false,
    bool isDark = false,
  }) {
    final lowerLabel = label.toLowerCase();
    final lowerName = fieldName.toLowerCase();
    final isPhoneField = lowerName.contains('phone') || lowerLabel.contains('phone') || lowerLabel.contains('telephone');

    Widget? phonePrefix;
    if (isPhoneField) {
      phonePrefix = Container(
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
      );
    }

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
          obscureText: isPassword,
          keyboardType: isPhoneField ? TextInputType.phone : null,
          inputFormatters: isPhoneField
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ]
              : (lowerName.contains('tin') || lowerLabel.contains('tin'))
                  ? [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                    ]
                  : null,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14.rsp),
          decoration: _inputDecoration(isPhoneField ? '8012345678' : hint, isDark, prefixIcon: phonePrefix),
          validator: (value) {
            final val = value?.trim() ?? '';
            if (isRequired && val.isEmpty) {
              return '$label is required';
            }
            if (val.isNotEmpty) {
              // Phone validation: +234 represents the beginning 0
              if (isPhoneField) {
                final digits = val.replaceAll(RegExp(r'\D'), '');
                if (digits.startsWith('0')) {
                  if (digits.length != 11) {
                    return 'Enter a valid 11-digit phone number starting with 0';
                  }
                } else {
                  if (digits.length != 10) {
                    return 'Enter 10 digits after +234 (e.g. 8012345678)';
                  }
                }
              }

              // Full Name validation (BRT-004, BRT-043)
              if (lowerName.contains('fullname') || lowerLabel == 'full name' || lowerLabel == 'name') {
                if (RegExp(r'^\d+$').hasMatch(val)) {
                  return 'Name cannot contain only numbers';
                }
                if (val.length < 2) {
                  return 'Name must be at least 2 characters';
                }
              }

              // Email validation (BRT-043, BRT-004)
              if (lowerName.contains('email') || lowerLabel.contains('email')) {
                final emailRegex = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$');
                if (!emailRegex.hasMatch(val) || !val.contains('.')) {
                  return 'Please enter a valid email address';
                }
              }

              // Password validation (BRT-047)
              if (isPassword || lowerName.contains('password') || lowerLabel.contains('password')) {
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
              }

              // Website & Portfolio validation (BRT-044, BRT-036)
              if (lowerLabel.contains('website') || lowerLabel.contains('portfolio') || lowerName.contains('website') || lowerName.contains('portfolio')) {
                final urlRegex = RegExp(r'^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(\/.*)?$');
                if (!urlRegex.hasMatch(val) && !val.contains('.')) {
                  return 'Please enter a valid URL (e.g. example.com)';
                }
              }

              // TIN validation (BRT-038, BRT-044)
              if (lowerName.contains('tin') || lowerLabel.contains('tin')) {
                if (!RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(val)) {
                  return 'TIN can only contain numbers, letters, and hyphens';
                }
              }

              // ID Number validation (BRT-038, BRT-044)
              if (lowerName.contains('idnumber') || lowerLabel.contains('id number')) {
                if (!RegExp(r'^[a-zA-Z0-9/-]+$').hasMatch(val)) {
                  return 'ID Number can only contain numbers, letters, and hyphens';
                }
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String? hint, bool isDark, {Widget? prefixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? const Color(0xFF1E232D) : Colors.grey[50],
      hintText: hint,
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      contentPadding: PlatformResponsive.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  @override
  void dispose() {
    _formStateManager.dispose();
    super.dispose();
  }
}
