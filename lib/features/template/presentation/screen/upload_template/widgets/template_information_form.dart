import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/constants/template_constants.dart';
import '../../../../../../core/widgets/option_picker_sheet.dart';

class TemplateInformationForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController templateNameController;
  final TextEditingController tagsController;
  final TextEditingController descriptionController;
  final String? selectedType;
  final String? selectedCategory;
  final Function(String?) onTypeChanged;
  final Function(String?) onCategoryChanged;

  const TemplateInformationForm({
    super.key,
    required this.formKey,
    required this.templateNameController,
    required this.tagsController,
    required this.descriptionController,
    required this.selectedType,
    required this.selectedCategory,
    required this.onTypeChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.grey[800]! : AppColors.grey200,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                'Template Information',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),

            // Form Fields
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Template Name
                  _buildLabel('Template Name', isRequired: true, isDark: isDark),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: templateNameController,
                    style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
                    decoration: _inputDecoration('Enter template name', isDark),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Template name is required';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Type
                  _buildLabel('Type', isRequired: true, isDark: isDark),
                  SizedBox(height: 8.h),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: selectedType ?? ''),
                    style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
                    decoration: _inputDecoration('Select...', isDark).copyWith(
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: isDark ? Colors.white60 : AppColors.grey600,
                      ),
                    ),
                    onTap: () async {
                      final result = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => OptionPickerSheet(
                          title: 'Select Type',
                          options: TemplateConstants.fileFormats,
                          selectedOption: selectedType,
                        ),
                      );
                      
                      if (result != null) {
                        onTypeChanged(result);
                      }
                    },
                    validator: (value) {
                      if (selectedType == null || selectedType!.isEmpty) {
                        return 'Type is required';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Template Category
                  _buildLabel('Template Category', isRequired: true, isDark: isDark),
                  SizedBox(height: 8.h),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: selectedCategory ?? ''),
                    style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
                    decoration: _inputDecoration('Choose a category', isDark).copyWith(
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: isDark ? Colors.white60 : AppColors.grey600,
                      ),
                    ),
                    onTap: () async {
                      final result = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => OptionPickerSheet(
                          title: 'Choose a category',
                          options: TemplateConstants.templateCategories,
                          selectedOption: selectedCategory,
                        ),
                      );
                      
                      if (result != null) {
                        onCategoryChanged(result);
                      }
                    },
                    validator: (value) {
                      if (selectedCategory == null || selectedCategory!.isEmpty) {
                        return 'Category is required';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Tags
                  _buildLabel('Tags', isDark: isDark),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: tagsController,
                    style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
                    decoration: _inputDecoration('Photoshop, Illustrator', isDark),
                  ),

                  SizedBox(height: 20.h),

                  // Description
                  _buildLabel('Description', isRequired: true, isDark: isDark),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : AppColors.grey300,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextFormField(
                      controller: descriptionController,
                      maxLines: 8,
                      style: TextStyle(color: isDark ? Colors.white : AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Write a detailed description...',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.white38 : AppColors.grey400,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.w),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false, required bool isDark}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.grey700,
        ),
        children: isRequired
            ? [
                TextSpan(
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
        color: isDark ? Colors.white38 : AppColors.grey400,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[700]! : AppColors.grey300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[700]! : AppColors.grey300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.red),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
    );
  }
}
