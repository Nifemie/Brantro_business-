import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/re_useable/app_color.dart';

class OptionPickerSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? selectedOption;
  final bool allowMultiple;
  final bool allowCustomInput;
  final String? customInputHint;

  const OptionPickerSheet({
    super.key,
    required this.title,
    required this.options,
    this.selectedOption,
    this.allowMultiple = false,
    this.allowCustomInput = false,
    this.customInputHint,
  });

  @override
  State<OptionPickerSheet> createState() => _OptionPickerSheetState();
}

class _OptionPickerSheetState extends State<OptionPickerSheet> {
  String? _selectedOption;
  final _customInputController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  @override
  void dispose() {
    _customInputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitCustomValue() {
    final value = _customInputController.text.trim();
    if (value.isNotEmpty) {
      Navigator.pop(context, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : AppColors.grey300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: isDark ? Colors.white70 : AppColors.grey700,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Custom Input Bar (if enabled)
          if (widget.allowCustomInput) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customInputController,
                      focusNode: _focusNode,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.customInputHint ?? 'Type your own custom value...',
                        hintStyle: TextStyle(
                          fontSize: 13.sp,
                          color: isDark ? Colors.white38 : AppColors.grey400,
                        ),
                        prefixIcon: const Icon(Icons.edit, size: 18),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onSubmitted: (_) => _submitCustomValue(),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: _submitCustomValue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Use',
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
          ],

          Divider(height: 1, color: isDark ? Colors.grey[800] : AppColors.grey200),

          // Options List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isHeader = option.startsWith('##HEADER##');
                final displayText = isHeader ? option.substring(10) : option;

                if (isHeader) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: 16.h,
                      bottom: 8.h,
                    ),
                    child: Text(
                      displayText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                final isSelected = _selectedOption == option;

                return InkWell(
                  onTap: () {
                    setState(() => _selectedOption = option);
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (!context.mounted) return;
                      Navigator.pop(context, option);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.1)
                          : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            displayText,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : (isDark ? Colors.white : AppColors.textPrimary),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primaryColor,
                            size: 22.sp,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
