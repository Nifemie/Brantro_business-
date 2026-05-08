import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../widgets/upload_billboard_form.dart';
import '../../logic/billboard_provider.dart';
import '../../../../core/data/repositories/file_repository.dart';

class UploadBillboardScreen extends ConsumerStatefulWidget {
  const UploadBillboardScreen({super.key});

  @override
  ConsumerState<UploadBillboardScreen> createState() => _UploadBillboardScreenState();
}

class _UploadBillboardScreenState extends ConsumerState<UploadBillboardScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Form data
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _featuresController = TextEditingController();
  final _specificationsController = TextEditingController();
  final _addressController = TextEditingController();
  final _rateAmountController = TextEditingController();
  final _totalSlotsController = TextEditingController();
  
  String? _selectedType;
  int? _selectedCategoryId;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  String? _selectedRateUnit;
  String? _thumbnailImage;
  String? _videoClip;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _featuresController.dispose();
    _specificationsController.dispose();
    _addressController.dispose();
    _rateAmountController.dispose();
    _totalSlotsController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (_titleController.text.trim().isEmpty) {
      _showError('Title is required'); 
      return false;
    }
    if (_selectedType == null) {
      _showError('Type is required');
      return false;
    }
    if (_selectedCategoryId == null) {
      _showError('Category is required');
      return false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showError('Description is required');
      return false;
    }
    if (_selectedCountry == null) {
      _showError('Country is required');
      return false;
    }
    if (_selectedState == null) {
      _showError('State is required');
      return false;
    }
    if (_selectedCity == null) {
      _showError('City is required');
      return false;
    }
    if (_addressController.text.trim().isEmpty) {
      _showError('Address is required');
      return false;
    }
    if (_rateAmountController.text.trim().isEmpty) {
      _showError('Rate amount is required');
      return false;
    }
    if (_selectedRateUnit == null) {
      _showError('Rate unit is required');
      return false;
    }
    if (_totalSlotsController.text.trim().isEmpty) {
      _showError('Total slots is required');
      return false;
    }
    // Note: Thumbnail is optional until file upload endpoint is available
    
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_validateForm()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload thumbnail if selected
      String? thumbnailUrl;
      if (_thumbnailImage != null) {
        try {
          final fileRepository = ref.read(fileRepositoryProvider);
          thumbnailUrl = await fileRepository.uploadFile(
            _thumbnailImage!,
            prefix: 'location-thumbnail',
          );
        } catch (e) {
          throw Exception('Failed to upload thumbnail: ${e.toString().replaceAll('Exception: ', '')}');
        }
      }

      // Upload video if selected
      String? videoUrl;
      if (_videoClip != null) {
        try {
          final fileRepository = ref.read(fileRepositoryProvider);
          videoUrl = await fileRepository.uploadFile(
            _videoClip!,
            prefix: 'location-video',
          );
        } catch (e) {
          throw Exception('Failed to upload video: ${e.toString().replaceAll('Exception: ', '')}');
        }
      }

      // Prepare form data with uploaded URLs
      final formData = {
        'title': _titleController.text.trim(),
        'type': _selectedType,
        'categoryId': _selectedCategoryId,
        'description': _descriptionController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _selectedCity,
        'state': _selectedState,
        'country': _selectedCountry,
        'rateAmount': double.parse(_rateAmountController.text.trim()),
        'rateUnit': _selectedRateUnit,
        'totalSlots': int.parse(_totalSlotsController.text.trim()),
      };

      // Add optional fields
      if (_featuresController.text.trim().isNotEmpty) {
        formData['features'] = _featuresController.text.trim();
      }
      if (_specificationsController.text.trim().isNotEmpty) {
        formData['specifications'] = _specificationsController.text.trim();
      }
      if (thumbnailUrl != null) {
        formData['thumbnail'] = thumbnailUrl;
      }
      if (videoUrl != null) {
        formData['videoClip'] = videoUrl;
      }

      await ref.read(billboardProvider.notifier).uploadBillboard(formData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Billboard uploaded successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        context.go('/billboard-marketplace');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString().replaceAll('Exception: ', '')}'),
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'UPLOAD BILLBOARD'),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: UploadBillboardForm(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  featuresController: _featuresController,
                  specificationsController: _specificationsController,
                  addressController: _addressController,
                  rateAmountController: _rateAmountController,
                  totalSlotsController: _totalSlotsController,
                  selectedType: _selectedType,
                  selectedCategoryId: _selectedCategoryId,
                  selectedCountry: _selectedCountry,
                  selectedState: _selectedState,
                  selectedCity: _selectedCity,
                  selectedRateUnit: _selectedRateUnit,
                  thumbnailImage: _thumbnailImage,
                  videoClip: _videoClip,
                  onTypeChanged: (value) => setState(() => _selectedType = value),
                  onCategoryChanged: (value) => setState(() => _selectedCategoryId = value),
                  onCountryChanged: (value) => setState(() {
                    _selectedCountry = value;
                    _selectedState = null;
                    _selectedCity = null;
                  }),
                  onStateChanged: (value) => setState(() {
                    _selectedState = value;
                    _selectedCity = null;
                  }),
                  onCityChanged: (value) => setState(() => _selectedCity = value),
                  onRateUnitChanged: (value) => setState(() => _selectedRateUnit = value),
                  onThumbnailChanged: (value) => setState(() => _thumbnailImage = value),
                  onVideoClipChanged: (value) => setState(() => _videoClip = value),
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
                    color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
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
                    backgroundColor: const Color(0xFF003D82),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
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
                          'Upload Billboard',
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
