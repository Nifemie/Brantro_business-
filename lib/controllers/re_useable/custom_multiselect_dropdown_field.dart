import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable multi-select dropdown form field widget
class CustomMultiselectDropdownField extends StatefulWidget {
  final String label;
  final String? hint;
  final List<Map<String, String>> options;
  final List<String>? initialValues;
  final ValueChanged<List<String>> onChanged;
  final FormFieldValidator<List<String>>? validator;
  final bool isRequired;

  const CustomMultiselectDropdownField({
    required this.label,
    required this.options,
    required this.onChanged,
    this.hint,
    this.initialValues,
    this.validator,
    this.isRequired = true,
    super.key,
  });

  @override
  State<CustomMultiselectDropdownField> createState() =>
      _CustomMultiselectDropdownFieldState();
}

class _CustomMultiselectDropdownFieldState
    extends State<CustomMultiselectDropdownField> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.initialValues ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: _selectedValues,
      validator:
          widget.validator ??
          (values) {
            if (widget.isRequired && (values == null || values.isEmpty)) {
              return '${widget.label} is required';
            }
            return null;
          },
      builder: (FormFieldState<List<String>> field) {
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedValues.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          widget.hint ?? 'Select ${widget.label}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: _selectedValues.map((value) {
                            final option = widget.options.firstWhere(
                              (opt) => opt['value'] == value,
                              orElse: () => {'label': value, 'value': value},
                            );
                            return Chip(
                              label: Text(
                                option['label'] ?? value,
                                style: TextStyle(fontSize: 13.sp),
                              ),
                              onDeleted: () {
                                setState(() {
                                  _selectedValues.remove(value);
                                  field.didChange(_selectedValues);
                                  widget.onChanged(_selectedValues);
                                });
                              },
                              backgroundColor: Colors.blue.shade50,
                              deleteIcon: Icon(Icons.close, size: 18.sp),
                            );
                          }).toList(),
                        ),
                      ),
                    DropdownButton<String>(
                      isExpanded: true,
                      underline: SizedBox(),
                      hint: Text(
                        'Add more...',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      value: null,
                      items: widget.options
                          .where(
                            (opt) => !_selectedValues.contains(opt['value']),
                          )
                          .map((option) {
                            return DropdownMenuItem<String>(
                              value: option['value'],
                              child: Text(
                                option['label'] ?? '',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            );
                          })
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedValues.add(value);
                            field.didChange(_selectedValues);
                            widget.onChanged(_selectedValues);
                          });
                        }
                      },
                      isDense: true,
                    ),
                  ],
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
