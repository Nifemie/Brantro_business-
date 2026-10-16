import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/widgets/option_picker_sheet.dart';
import '../../../../../category/logic/category_provider.dart';

class ServiceInfoForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController specificationsController;
  final String? selectedType;
  final int? selectedCategoryId;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<int?> onCategoryChanged;

  const ServiceInfoForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.specificationsController,
    required this.selectedType,
    required this.selectedCategoryId,
    required this.onTypeChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final categoryState = ref.watch(categoryProvider);
    final categories = categoryState.categories;
    
    final selectedCategoryName = categories
        .where((c) => c.id == selectedCategoryId)
        .firstOrNull
        ?.name;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Service Information', isDark),
          SizedBox(height: 16.h),
          
          _buildTextField(
            controller: titleController,
            label: 'Service Title *',
            hint: 'e.g. Modern Brand Logo Design & Guidelines',
            isDark: isDark,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Service title is required';
              }
              return null;
            },
          ),
          
          SizedBox(height: 16.h),
          
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  context: context,
                  label: 'Type *',
                  value: selectedType,
                  hint: 'Select...',
                  onTap: () => _showTypePicker(context),
                  isDark: isDark,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildDropdownField(
                  context: context,
                  label: 'Category *',
                  value: selectedCategoryName,
                  hint: 'Select...',
                  onTap: () {
                    showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => OptionPickerSheet(
                        title: 'Select Category',
                        options: categories.map((c) => c.name).toList(),
                      ),
                    ).then((selectedName) {
                      if (selectedName != null) {
                        final selected = categories.firstWhere((c) => c.name == selectedName);
                        onCategoryChanged(selected.id);
                      }
                    });
                  },
                  isDark: isDark,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          _buildTextField(
            controller: descriptionController,
            label: 'Description *',
            hint: 'Describe your service and what the client receives...',
            isDark: isDark,
            maxLines: 5,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description is required';
              }
              return null;
            },
          ),
          
          SizedBox(height: 16.h),
          
          _buildTextField(
            controller: specificationsController,
            label: 'Specifications (Optional)',
            hint: 'e.g. Dimensions, resolution, file standards, aspect ratio...',
            isDark: isDark,
            maxLines: 3,
            isRequired: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    int maxLines = 1,
    bool isRequired = true,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String? value,
    required String hint,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[50],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: value == null
                          ? (isDark ? Colors.white38 : Colors.grey[400])
                          : (isDark ? Colors.white : AppColors.textPrimary),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showTypePicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const OptionPickerSheet(
        title: 'Select Service Type',
        options: [
          '##HEADER##AUDIO',
          'Voice Over',
          'Audio Ad',
          'Jingle Production',
          'Sound Design',
          '##HEADER##DESIGN',
          'Ui Ux Design',
          'Packaging Design',
          'Print Design',
          '##HEADER##UGC CONTENT',
          'Ugc Video',
          'Ugc Photo',
          'Lifestyle Content',
          'Unboxing Video',
          '##HEADER##VIDEO MOTION',
          'Video Ad',
          'Video Editing',
          'Motion Graphics',
          'Animated Ad',
          'Short Form Video',
          'Long Form Video',
          'Explainer Video',
          '##HEADER##WRITING',
          'Caption Writing',
        ],
      ),
    );
    if (result != null) {
      onTypeChanged(result);
    }
  }
}
