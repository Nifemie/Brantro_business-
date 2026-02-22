import 'package:flutter/material.dart';
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final handler = RoleDetailsHandler(ref, context);
      final formData = handler.collectFormData(_formStateManager.controllers);

      handler.handleSubmit(
        role: widget.role,
        accountType: _selectedAccountType,
        formData: formData,
        setLoading: (loading) {
          if (mounted) {
            setState(() => _isLoading = loading);
          }
        },
      );
    }
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

                  if (fieldType == 'dropdown') {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: CustomDropdownField(
                        label: field['label'] as String,
                        hint: field['hint'] as String?,
                        options: field['options'] as List<Map<String, String>>,
                        isRequired: field['isRequired'] as bool? ?? field['required'] as bool? ?? true,
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
                        label: field['label'] as String,
                        hint: field['hint'] as String?,
                        options: field['options'] as List<Map<String, String>>,
                        isRequired: field['isRequired'] as bool? ?? field['required'] as bool? ?? true,
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
                        label: field['label'] as String,
                        hint: field['hint'] as String?,
                        maxLines: field['maxLines'] as int? ?? 1,
                        isRequired:
                            field['isRequired'] as bool? ??
                            field['required'] as bool? ??
                            true,
                        isPassword: isPassword,
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
    bool isPassword = false,
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
          obscureText: isPassword,
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
    _formStateManager.dispose();
    super.dispose();
  }
}
