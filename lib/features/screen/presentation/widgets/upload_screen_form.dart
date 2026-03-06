import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadScreenForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController featuresController;
  final TextEditingController addressController;
  final TextEditingController rateAmountController;
  final TextEditingController totalSlotsController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final String? selectedType;
  final String? selectedCategory;
  final String? selectedCountry;
  final String? selectedState;
  final String? selectedCity;
  final String? selectedRateUnit;
  final String? thumbnailImage;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onStateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onRateUnitChanged;
  final ValueChanged<String?> onThumbnailChanged;

  const UploadScreenForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.featuresController,
    required this.addressController,
    required this.rateAmountController,
    required this.totalSlotsController,
    required this.latitudeController,
    required this.longitudeController,
    required this.selectedType,
    required this.selectedCategory,
    required this.selectedCountry,
    required this.selectedState,
    required this.selectedCity,
    required this.selectedRateUnit,
    required this.thumbnailImage,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    required this.onRateUnitChanged,
    required this.onThumbnailChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Screen Title', hintText: 'Enter screen name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
          validator: (value) => value == null || value.isEmpty ? 'Please enter screen title' : null,
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: descriptionController,
          maxLines: 3,
          decoration: InputDecoration(labelText: 'Description', hintText: 'Enter screen description', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: addressController,
          decoration: InputDecoration(labelText: 'Address', hintText: 'Enter screen address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
          validator: (value) => value == null || value.isEmpty ? 'Please enter address' : null,
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: featuresController,
          decoration: InputDecoration(labelText: 'Size/Features', hintText: 'e.g., 55 inch LED', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: rateAmountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Price', hintText: 'Enter price', prefixText: '₦', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r))),
          validator: (value) => value == null || value.isEmpty ? 'Please enter price' : null,
        ),
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 20.sp),
              SizedBox(width: 12.w),
              Expanded(child: Text('Fill in all required fields to upload your screen', style: TextStyle(fontSize: 13.sp, color: Colors.blue))),
            ],
          ),
        ),
      ],
    );
  }
}
