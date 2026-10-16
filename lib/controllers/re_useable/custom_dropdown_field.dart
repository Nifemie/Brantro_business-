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
  void didUpdateWidget(CustomDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedValue = widget.initialValue;
    }
    if (_selectedValue != null &&
        !widget.options.any((option) => option['value'] == _selectedValue)) {
      _selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
        final hasValidValue = field.value != null &&
            widget.options.any((option) => option['value'] == field.value);
        final effectiveValue = hasValidValue ? field.value : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label.isNotEmpty) ...[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
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
            ],
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[50],
                border: Border.all(
                  color: field.hasError ? Colors.red : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  menuMaxHeight: 320.h,
                  borderRadius: BorderRadius.circular(12.r),
                  dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                  hint: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      widget.hint ?? 'Select ${widget.label}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white38 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  value: effectiveValue,
                  items: widget.options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option['value'],
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          option['label'] ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
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
