import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../widgets/upload_wall_form.dart';
import '../../logic/wall_provider.dart';

class UploadWallScreen extends ConsumerStatefulWidget {
  const UploadWallScreen({super.key});

  @override
  ConsumerState<UploadWallScreen> createState() => _UploadWallScreenState();
}

class _UploadWallScreenState extends ConsumerState<UploadWallScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Form data
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _featuresController = TextEditingController();
  final _addressController = TextEditingController();
  final _rateAmountController = TextEditingController();
  final _totalSlotsController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  
  String? _selectedType;
  String? _selectedCategory;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  String? _selectedRateUnit;
  String? _thumbnailImage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _featuresController.dispose();
    _addressController.dispose();
    _rateAmountController.dispose();
    _totalSlotsController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final wallData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'features': _featuresController.text,
        'address': _addressController.text,
        'type': _selectedType,
        'category': _selectedCategory,
        'country': _selectedCountry,
        'state': _selectedState,
        'city': _selectedCity,
        'rateAmount': _rateAmountController.text,
        'rateUnit': _selectedRateUnit,
        'totalSlots': _totalSlotsController.text,
        'latitude': _latitudeController.text,
        'longitude': _longitudeController.text,
        'images': _thumbnailImage != null ? [_thumbnailImage!] : [],
      };

      await ref.read(wallProvider.notifier).uploadWall(wallData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wall uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/wall-marketplace');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'UPLOAD WALL'),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _formKey,
                  child: UploadWallForm(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    featuresController: _featuresController,
                    addressController: _addressController,
                    rateAmountController: _rateAmountController,
                    totalSlotsController: _totalSlotsController,
                    latitudeController: _latitudeController,
                    longitudeController: _longitudeController,
                    selectedType: _selectedType,
                    selectedCategory: _selectedCategory,
                    selectedCountry: _selectedCountry,
                    selectedState: _selectedState,
                    selectedCity: _selectedCity,
                    selectedRateUnit: _selectedRateUnit,
                    thumbnailImage: _thumbnailImage,
                    onTypeChanged: (value) => setState(() => _selectedType = value),
                    onCategoryChanged: (value) => setState(() => _selectedCategory = value),
                    onCountryChanged: (value) => setState(() => _selectedCountry = value),
                    onStateChanged: (value) => setState(() => _selectedState = value),
                    onCityChanged: (value) => setState(() => _selectedCity = value),
                    onRateUnitChanged: (value) => setState(() => _selectedRateUnit = value),
                    onThumbnailChanged: (value) => setState(() => _thumbnailImage = value),
                  ),
                ),
              ),
            ),

            // Submit Button
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Upload Wall',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
