import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import '../../../../../../core/widgets/option_picker_sheet.dart';
import '../../../../../category/logic/category_provider.dart';
import 'form_field_widgets.dart';

class CreativeInformationForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController fileSizeController;
  final TextEditingController durationController;
  final TextEditingController priceController;
  final TextEditingController discountController;
  final TextEditingController widthController;
  final TextEditingController heightController;
  final TextEditingController descriptionController;
  final String? selectedType;
  final int? selectedCategoryId;
  final String? selectedFormat;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<String?> onFormatChanged;

  const CreativeInformationForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.fileSizeController,
    required this.durationController,
    required this.priceController,
    required this.discountController,
    required this.widthController,
    required this.heightController,
    required this.descriptionController,
    required this.selectedType,
    required this.selectedCategoryId,
    required this.selectedFormat,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    required this.onFormatChanged,
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
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleField(isDark),
                  SizedBox(height: 16.h),
                  
                  // Type and Category Row
                  Row(
                    children: [
                      Expanded(
                        child: CustomPickerField(
                          controller: TextEditingController(text: selectedType),
                          label: 'Type',
                          hint: 'Select...',
                          options: const ['IMAGE', 'VIDEO', 'AUDIO', 'DOCUMENT'],
                          isRequired: true,
                          isDark: isDark,
                          onChanged: onTypeChanged,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildCategoryDropdown(context, selectedCategoryName, categories, isDark),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Format and File Size Row
                  Row(
                    children: [
                      Expanded(
                        child: CustomPickerField(
                          controller: TextEditingController(text: selectedFormat),
                          label: 'Format',
                          hint: 'Select...',
                          options: const ['STANDARD_IMAGE', 'PREMIUM_VIDEO', 'BASIC_AUDIO', 'HIGH_RES_DOCUMENT'],
                          isRequired: true,
                          isDark: isDark,
                          onChanged: onFormatChanged,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomTextField(
                          controller: fileSizeController,
                          label: 'File Size',
                          hint: 'e.g. 2.3',
                          isRequired: true,
                          isDark: isDark,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Duration Row
                  CustomTextField(
                    controller: durationController,
                    label: 'Duration (Seconds)',
                    hint: 'e.g. 35',
                    isRequired: false,
                    isDark: isDark,
                    keyboardType: TextInputType.number,
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Price and Discount Row
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: priceController,
                          label: 'Price',
                          hint: 'e.g. 20000',
                          isRequired: true,
                          isDark: isDark,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomTextField(
                          controller: discountController,
                          label: 'Discount',
                          hint: 'e.g. 4000',
                          isRequired: false,
                          isDark: isDark,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Dimensions Row
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: widthController,
                          label: 'Width (px)',
                          hint: 'e.g. 1920',
                          isDark: isDark,
                          isRequired: false,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: CustomTextField(
                          controller: heightController,
                          label: 'Height (px)',
                          hint: 'e.g. 1080',
                          isDark: isDark,
                          isRequired: false,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                  _buildDescriptionField(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context, String? selectedCategoryName, List categories, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Category',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Text(' *', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
          ],
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () {
            showModalBottomSheet<String>(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => OptionPickerSheet(
                title: 'Select Category',
                options: categories.map((c) => c.name as String).toList(),
              ),
            ).then((selectedName) {
              if (selectedName != null) {
                final selected = categories.firstWhere((c) => c.name == selectedName);
                onCategoryChanged(selected.id);
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: isDark ? Colors.grey[700]! : AppColors.grey300),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedCategoryName ?? 'Select...',
                    style: TextStyle(
                      color: selectedCategoryName != null
                          ? (isDark ? Colors.white : AppColors.textPrimary)
                          : (isDark ? Colors.white38 : AppColors.grey400),
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: isDark ? Colors.white54 : AppColors.grey500),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
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
        'Creative Information',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTitleField(bool isDark) {
    return CustomTextField(
      controller: titleController,
      label: 'Title',
      hint: 'Enter creative title',
      isRequired: true,
      isDark: isDark,
    );
  }

  Widget _buildDescriptionField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
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
            maxLines: 5,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Enter creative description...',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.white38 : AppColors.grey400,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
            ),
          ),
        ),
      ],
    );
  }
}
