import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../core/widgets/option_picker_sheet.dart';
import '../../../../core/constants/nigerian_locations.dart';
import '../../../category/logic/category_provider.dart';

class UploadScreenForm extends ConsumerWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController featuresController;
  final TextEditingController specificationsController;
  final TextEditingController addressController;
  final TextEditingController rateAmountController;
  final TextEditingController totalSlotsController;
  
  final String? selectedType;
  final int? selectedCategoryId;
  final String? selectedCountry;
  final String? selectedState;
  final String? selectedCity;
  final String? selectedRateUnit;
  final String? thumbnailImage;
  final String? videoClip;
  
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<int?> onCategoryChanged;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onStateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onRateUnitChanged;
  final ValueChanged<String?> onThumbnailChanged;
  final ValueChanged<String?> onVideoClipChanged;

  const UploadScreenForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.featuresController,
    required this.specificationsController,
    required this.addressController,
    required this.rateAmountController,
    required this.totalSlotsController,
    required this.selectedType,
    required this.selectedCategoryId,
    required this.selectedCountry,
    required this.selectedState,
    required this.selectedCity,
    required this.selectedRateUnit,
    required this.thumbnailImage,
    required this.videoClip,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    required this.onRateUnitChanged,
    required this.onThumbnailChanged,
    required this.onVideoClipChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categoryState = ref.watch(categoryProvider);
    final locationCategories = categoryState.locationCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Screen Information', isDark),
        SizedBox(height: 16.h),
        
        _buildTextField(
          controller: titleController,
          label: 'Title',
          hint: 'Wuse Digital Screen',
          isDark: isDark,
        ),

        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                context: context,
                label: 'Type',
                value: selectedType,
                hint: 'Select type',
                onTap: () => _showTypePicker(context),
                isDark: isDark,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildDropdownField(
                context: context,
                label: 'Category',
                value: selectedCategoryId != null && locationCategories.isNotEmpty
                    ? locationCategories
                        .firstWhere(
                          (cat) => cat.id == selectedCategoryId,
                          orElse: () => locationCategories.first,
                        )
                        .name
                    : null,
                hint: categoryState.isLoading 
                    ? 'Loading...' 
                    : (locationCategories.isEmpty ? 'No categories' : 'Choose a category'),
                onTap: () => _showCategoryPicker(context, ref),
                isDark: isDark,
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),
        
        _buildTextField(
          controller: descriptionController,
          label: 'Description',
          hint: 'Describe the screen location...',
          isDark: isDark,
          maxLines: 5,
        ),

        SizedBox(height: 16.h),
        
        _buildTextField(
          controller: featuresController,
          label: 'Features (Optional)',
          hint: 'Describe features',
          isDark: isDark,
          maxLines: 3,
          isRequired: false,
        ),

        SizedBox(height: 16.h),
        
        _buildTextField(
          controller: specificationsController,
          label: 'Specifications (Optional)',
          hint: 'Technical specifications',
          isDark: isDark,
          maxLines: 3,
          isRequired: false,
        ),

        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                context: context,
                label: 'Country',
                value: selectedCountry,
                hint: 'Nigeria',
                onTap: () => _showCountryPicker(context),
                isDark: isDark,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildDropdownField(
                context: context,
                label: 'State',
                value: selectedState,
                hint: 'Select state',
                onTap: () => _showStatePicker(context),
                isDark: isDark,
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                context: context,
                label: 'City',
                value: selectedCity,
                hint: 'Select state first',
                onTap: selectedState != null ? () => _showCityPicker(context) : null,
                isDark: isDark,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTextField(
                controller: addressController,
                label: 'Address',
                hint: 'Zone 6, Wuse',
                isDark: isDark,
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: rateAmountController,
                label: 'Rate Amount',
                hint: '0',
                isDark: isDark,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildDropdownField(
                context: context,
                label: 'Rate Unit',
                value: selectedRateUnit,
                hint: 'Day',
                onTap: () => _showRateUnitPicker(context),
                isDark: isDark,
              ),
            ),
          ],
        ),

        SizedBox(height: 24.h),
        
        _buildSectionTitle('Media Files', isDark),
        SizedBox(height: 16.h),
        
        Text(
          'Thumbnail Image',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        
        InkWell(
          onTap: () => _pickThumbnail(context),
          child: Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: thumbnailImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Stack(
                      children: [
                        Image.file(
                          File(thumbnailImage!),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 48.sp,
                                color: isDark ? Colors.white38 : Colors.grey[400],
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: IconButton(
                            onPressed: () => onThumbnailChanged(null),
                            icon: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48.sp,
                        color: isDark ? Colors.white38 : Colors.grey[400],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Click to upload thumbnail',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        SizedBox(height: 16.h),
        
        Text(
          'Video Clip (Optional)',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        
        InkWell(
          onTap: () => _pickVideo(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: videoClip != null
                ? Row(
                    children: [
                      Icon(
                        Icons.video_library,
                        color: AppColors.primaryColor,
                        size: 32.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          videoClip!.split('/').last,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => onVideoClipChanged(null),
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_call_outlined,
                        size: 32.sp,
                        color: isDark ? Colors.white38 : Colors.grey[400],
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Click to upload video',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        SizedBox(height: 24.h),
        
        _buildTextField(
          controller: totalSlotsController,
          label: 'Total Slots',
          hint: '0',
          isDark: isDark,
          keyboardType: TextInputType.number,
        ),

        SizedBox(height: 32.h),
      ],
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
    TextInputType? keyboardType,
    bool isRequired = true,
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
          keyboardType: keyboardType,
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
    required VoidCallback? onTap,
    required bool isDark,
  }) {
    final isDisabled = onTap == null;
    
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
          onTap: isDisabled ? null : onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: isDisabled 
                  ? (isDark ? Colors.grey[900] : Colors.grey[100])
                  : (isDark ? Colors.grey[850] : Colors.grey[50]),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? hint,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: value == null
                        ? (isDark ? Colors.white38 : Colors.grey[400])
                        : (isDark ? Colors.white : AppColors.textPrimary),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: isDisabled 
                      ? (isDark ? Colors.grey[800] : Colors.grey[300])
                      : (isDark ? Colors.white60 : Colors.grey[600]),
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
        title: 'Select Type',
        options: ['BILLBOARD', 'SCREEN', 'WALL'],
      ),
    );
    
    if (result != null) {
      onTypeChanged(result);
    }
  }

  Future<void> _showCategoryPicker(BuildContext context, WidgetRef ref) async {
    final categoryState = ref.read(categoryProvider);
    
    if (categoryState.isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading categories...')),
      );
      return;
    }

    if (categoryState.locationCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No categories available')),
      );
      return;
    }

    final categoryNames = categoryState.locationCategories
        .map((cat) => cat.name)
        .toList();

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionPickerSheet(
        title: 'Select Category',
        options: categoryNames,
      ),
    );
    
    if (result != null) {
      final selectedCategory = categoryState.locationCategories
          .firstWhere((cat) => cat.name == result);
      onCategoryChanged(selectedCategory.id);
    }
  }

  Future<void> _showCountryPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const OptionPickerSheet(
        title: 'Select Country',
        options: ['Nigeria'],
      ),
    );
    
    if (result != null) {
      onCountryChanged(result);
    }
  }

  Future<void> _showStatePicker(BuildContext context) async {
    final states = NigerianLocations.getAllStates();
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionPickerSheet(
        title: 'Select State',
        options: states,
      ),
    );
    
    if (result != null) {
      onStateChanged(result);
    }
  }

  Future<void> _showCityPicker(BuildContext context) async {
    if (selectedState == null) return;
    
    final cities = _getCitiesForState(selectedState!);
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionPickerSheet(
        title: 'Select City',
        options: cities,
      ),
    );
    
    if (result != null) {
      onCityChanged(result);
    }
  }

  Future<void> _showRateUnitPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const OptionPickerSheet(
        title: 'Select Rate Unit',
        options: ['SECOND', 'MINUTE', 'HOUR', 'DAY', 'WEEK', 'MONTH', 'QUARTER', 'HALF_YEAR', 'YEAR'],
      ),
    );
    
    if (result != null) {
      onRateUnitChanged(result);
    }
  }

  List<String> _getCitiesForState(String state) {
    return NigerianLocations.getCitiesForState(state);
  }

  Future<void> _pickThumbnail(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        onThumbnailChanged(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking thumbnail: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final video = await picker.pickVideo(source: ImageSource.gallery);
      
      if (video != null) {
        onVideoClipChanged(video.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking video: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
