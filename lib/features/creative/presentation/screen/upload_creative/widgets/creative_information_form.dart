import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../controllers/re_useable/app_color.dart';
import 'form_field_widgets.dart';

class CreativeInformationForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController fileSizeController;
  final TextEditingController durationController;
  final TextEditingController priceController;
  final TextEditingController widthController;
  final TextEditingController heightController;
  final TextEditingController descriptionController;

  const CreativeInformationForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.fileSizeController,
    required this.durationController,
    required this.priceController,
    required this.widthController,
    required this.heightController,
    required this.descriptionController,
  });

  @override
  State<CreativeInformationForm> createState() => _CreativeInformationFormState();
}

class _CreativeInformationFormState extends State<CreativeInformationForm> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _formatController = TextEditingController();

  final List<String> _types = ['Image', 'Video', 'Audio', 'Document'];
  final List<String> _formats = ['Standard', 'Premium', 'Basic'];

  @override
  void dispose() {
    _typeController.dispose();
    _formatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: widget.formKey,
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
                  _buildTypeField(isDark),
                  SizedBox(height: 16.h),
                  _buildFormatSizeRow(isDark),
                  SizedBox(height: 16.h),
                  _buildDurationPriceRow(isDark),
                  SizedBox(height: 16.h),
                  _buildDimensionsRow(isDark),
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
      controller: widget.titleController,
      label: 'Title',
      hint: 'Enter creative title',
      isRequired: true,
      isDark: isDark,
    );
  }

  Widget _buildTypeField(bool isDark) {
    return CustomPickerField(
      controller: _typeController,
      label: 'Type',
      hint: 'Select type',
      options: _types,
      isRequired: true,
      isDark: isDark,
    );
  }

  Widget _buildFormatSizeRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: CustomPickerField(
            controller: _formatController,
            label: 'Format',
            hint: 'Select format',
            options: _formats,
            isRequired: true,
            isDark: isDark,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: CustomTextField(
            controller: widget.fileSizeController,
            label: 'File Size',
            hint: 'e.g., 3.6MB',
            isRequired: true,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationPriceRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: widget.durationController,
            label: 'Duration',
            hint: 'e.g., 10s or 5 Files',
            isRequired: true,
            isDark: isDark,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: CustomTextField(
            controller: widget.priceController,
            label: 'Price',
            hint: 'Enter price',
            isRequired: true,
            isDark: isDark,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildDimensionsRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: widget.widthController,
            label: 'Width (px)',
            hint: 'e.g., 1920',
            isDark: isDark,
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: CustomTextField(
            controller: widget.heightController,
            label: 'Height (px)',
            hint: 'e.g., 1080',
            isDark: isDark,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel('Description', isDark: isDark),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? Colors.grey[700]! : AppColors.grey300,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextFormField(
            controller: widget.descriptionController,
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
