import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../re_useable/custom_dropdown_field.dart';
import '../re_useable/custom_multiselect_dropdown_field.dart';

/// Factory/builder for creating form fields based on type
class FormFieldBuilder {
  static Widget buildField({
    required Map<String, dynamic> fieldConfig,
    required TextEditingController? textController,
    required ValueChanged<dynamic> onChanged,
    List<Map<String, String>>? dropdownOptions,
  }) {
    final fieldType = fieldConfig['type'] as String? ?? 'text';
    final fieldName = fieldConfig['name'] as String;
    final label = fieldConfig['label'] as String;
    final hint = fieldConfig['hint'] as String?;
    final isRequired = fieldConfig['isRequired'] as bool? ?? true;

    switch (fieldType) {
      case 'dropdown':
        return CustomDropdownField(
          label: label,
          hint: hint,
          options: dropdownOptions ?? [],
          isRequired: isRequired,
          onChanged: (value) => onChanged(value),
        );

      case 'multiselect':
        return CustomMultiselectDropdownField(
          label: label,
          hint: hint,
          options: dropdownOptions ?? [],
          isRequired: isRequired,
          onChanged: (values) => onChanged(values),
        );

      case 'text':
      default:
        return _buildTextField(
          label: label,
          hint: hint,
          controller: textController,
          isRequired: isRequired,
          onChanged: onChanged,
          maxLines: fieldConfig['maxLines'] as int? ?? 1,
        );
    }
  }

  static Widget _buildTextField({
    required String label,
    required String? hint,
    required TextEditingController? controller,
    required bool isRequired,
    required ValueChanged<String> onChanged,
    required int maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: maxLines == 1 ? 1 : null,
          onChanged: onChanged,
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return '$label is required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    );
  }
}
