import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable dropdown form field widget
class CustomDropdownField extends StatefulWidget {
  final String label;
  final String? hint;
  final List<Map<String, String>> options;
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final bool isRequired;

  const CustomDropdownField({
    required this.label,
    required this.options,
    required this.onChanged,
    this.hint,
    this.initialValue,
    this.validator,
    this.isRequired = true,
    super.key,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  late String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _selectedValue,
      validator:
          widget.validator ??
          (value) {
            if (widget.isRequired && (value == null || value.isEmpty)) {
              return '${widget.label} is required';
            }
            return null;
          },
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (widget.isRequired)
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: field.hasError ? Colors.red : Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    widget.hint ?? 'Select ${widget.label}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  value: field.value,
                  items: widget.options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option['value'],
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          option['label'] ?? '',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    field.didChange(value);
                    _selectedValue = value;
                    widget.onChanged(value);
                  },
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  field.errorText ?? '',
                  style: TextStyle(fontSize: 12.sp, color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
