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
  final _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedValues = widget.initialValues ?? [];
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (widget.isRequired)
                    TextSpan(
                      text: ' *',
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
                color: isDark ? Colors.grey[850] : Colors.grey[50],
                border: Border.all(
                  color: field.hasError 
                      ? Colors.red 
                      : (isDark ? Colors.grey[700]! : Colors.grey.shade300),
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
                            color: isDark ? Colors.white38 : Colors.grey.shade600,
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
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isDark ? Colors.white : Colors.blue.shade900,
                                ),
                              ),
                              onDeleted: () {
                                setState(() {
                                  _selectedValues.remove(value);
                                  field.didChange(_selectedValues);
                                  widget.onChanged(_selectedValues);
                                });
                              },
                              backgroundColor: isDark ? Colors.blue.shade900.withOpacity(0.4) : Colors.blue.shade50,
                              deleteIcon: Icon(
                                Icons.close, 
                                size: 18.sp,
                                color: isDark ? Colors.white70 : Colors.blue.shade900,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            dropdownColor: isDark ? Colors.grey[850] : Colors.white,
                            iconEnabledColor: isDark ? Colors.white70 : Colors.black54,
                            hint: Text(
                              'Add more...',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark ? Colors.white38 : Colors.grey.shade600,
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
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
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
                        ),
                        Container(
                          width: 1,
                          height: 20.h,
                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _customController,
                            decoration: InputDecoration(
                              hintText: 'Or type custom...',
                              border: InputBorder.none,
                              isDense: true,
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                color: isDark ? Colors.white38 : Colors.grey.shade600,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.add, size: 20),
                                onPressed: () {
                                  final text = _customController.text.trim();
                                  if (text.isNotEmpty && !_selectedValues.contains(text)) {
                                    setState(() {
                                      _selectedValues.add(text);
                                      field.didChange(_selectedValues);
                                      widget.onChanged(_selectedValues);
                                      _customController.clear();
                                    });
                                  }
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            onSubmitted: (value) {
                              final text = value.trim();
                              if (text.isNotEmpty && !_selectedValues.contains(text)) {
                                setState(() {
                                  _selectedValues.add(text);
                                  field.didChange(_selectedValues);
                                  widget.onChanged(_selectedValues);
                                  _customController.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ],
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
