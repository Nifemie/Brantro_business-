import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../widgets/upload_screen_form.dart';
import '../../logic/screen_provider.dart';
import '../../data/models/screen_model.dart';

class UploadScreenScreen extends ConsumerStatefulWidget {
  final bool isUpdate;
  final ScreenModel? screen;

  const UploadScreenScreen({
    super.key,
    this.isUpdate = false,
    this.screen,
  });

  @override
  ConsumerState<UploadScreenScreen> createState() => _UploadScreenScreenState();
}

class _UploadScreenScreenState extends ConsumerState<UploadScreenScreen> {
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
  final _estimatedReachController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  
  String? _selectedType = 'SCREEN';
  int? _selectedCategoryId = 23;
  String? _selectedClass;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  String? _selectedRateUnit;
  String? _thumbnailImage;
  String? _videoClip;
  final List<String> _galleryImages = [];

  bool _isLocalFile(String path) {
    if (path.isEmpty) return false;
    if (path.startsWith('http://') || path.startsWith('https://')) return false;
    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.screen != null) {
      final s = widget.screen!;
      _titleController.text = s.name;
      _descriptionController.text = s.description;
      _featuresController.text = s.featuresText;
      _specificationsController.text = s.specifications;
      _addressController.text = s.address;
      _rateAmountController.text = s.price > 0 ? s.price.toString() : '';
      _totalSlotsController.text = (s.totalAdSlots ?? 1).toString();
      _estimatedReachController.text = (s.estimatedReach ?? 0).toString();
      if (s.latitude != null) _latitudeController.text = s.latitude.toString();
      if (s.longitude != null) _longitudeController.text = s.longitude.toString();

      _selectedType = s.type.isNotEmpty ? s.type : 'SCREEN';
      _selectedState = s.location.isNotEmpty ? s.location : null;
      _selectedCountry = 'Nigeria';
      _thumbnailImage = s.thumbnail.isNotEmpty ? s.thumbnail : null;
      if (s.images.isNotEmpty) {
        _galleryImages.addAll(s.images);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _featuresController.dispose();
    _specificationsController.dispose();
    _addressController.dispose();
    _rateAmountController.dispose();
    _totalSlotsController.dispose();
    _estimatedReachController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (_titleController.text.trim().isEmpty) {
      _showError('Title is required');
      return false;
    }
    if (_selectedCategoryId == null) {
      _showError('Category is required');
      return false;
    }
    if (_selectedClass == null) {
      _showError('Class is required');
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
    if (_thumbnailImage == null) {
      _showError('Thumbnail Image is required');
      return false;
    }
    
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
      // Upload thumbnail if local file
      String? thumbnailUrl;
      if (_thumbnailImage != null && _thumbnailImage!.isNotEmpty) {
        if (_isLocalFile(_thumbnailImage!)) {
          try {
            final repository = ref.read(screenProvider.notifier).repository;
            thumbnailUrl = await repository.uploadFile(_thumbnailImage!, prefix: 'location-thumbnail');
          } catch (e) {
            throw Exception('Failed to upload thumbnail: ${e.toString().replaceAll('Exception: ', '')}');
          }
        } else {
          thumbnailUrl = _thumbnailImage;
        }
      }

      // Upload video if local file
      String? videoUrl;
      if (_videoClip != null && _videoClip!.isNotEmpty) {
        if (_isLocalFile(_videoClip!)) {
          try {
            final repository = ref.read(screenProvider.notifier).repository;
            videoUrl = await repository.uploadFile(_videoClip!, prefix: 'location-video');
          } catch (e) {
            throw Exception('Failed to upload video: ${e.toString().replaceAll('Exception: ', '')}');
          }
        } else {
          videoUrl = _videoClip;
        }
      }

      // Upload gallery images if local file
      final List<String> uploadedGalleryUrls = [];
      if (_galleryImages.isNotEmpty) {
        try {
          final repository = ref.read(screenProvider.notifier).repository;
          for (final imagePath in _galleryImages) {
            if (_isLocalFile(imagePath)) {
              final url = await repository.uploadFile(
                imagePath,
                prefix: 'location-gallery',
              );
              uploadedGalleryUrls.add(url);
            } else {
              uploadedGalleryUrls.add(imagePath);
            }
          }
        } catch (e) {
          throw Exception('Failed to upload gallery image: ${e.toString().replaceAll('Exception: ', '')}');
        }
      }

      // Prepare form data with uploaded URLs
      final formData = {
        'title': _titleController.text.trim(),
        'type': _selectedType,
        'class': _selectedClass,
        'coverageAreas': [],
        'estimatedReach': [int.tryParse(_estimatedReachController.text.trim()) ?? 0],
        'categoryId': _selectedCategoryId,
        'description': _descriptionController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _selectedCity,
        'state': _selectedState,
        'country': _selectedCountry,
        'latitude': double.tryParse(_latitudeController.text.trim()) ?? 0.0,
        'longitude': double.tryParse(_longitudeController.text.trim()) ?? 0.0,
        'rate': double.parse(_rateAmountController.text.trim()),
        'rateUnit': _selectedRateUnit,
        'status': 'ACTIVE',
        'totalAdSlots': int.parse(_totalSlotsController.text.trim()),
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
      if (uploadedGalleryUrls.isNotEmpty) {
        formData['gallery'] = uploadedGalleryUrls;
      }

      if (widget.isUpdate && widget.screen != null) {
        await ref.read(screenProvider.notifier).updateScreen(widget.screen!.id, formData);
      } else {
        await ref.read(screenProvider.notifier).uploadScreen(formData);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isUpdate ? 'Screen updated successfully!' : 'Screen uploaded successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        context.go('/screen-marketplace');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.isUpdate ? "Update" : "Upload"} failed: ${e.toString().replaceAll('Exception: ', '')}'),
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
            DashboardAppBar(title: widget.isUpdate ? 'EDIT SCREEN' : 'UPLOAD SCREEN'),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: UploadScreenForm(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  featuresController: _featuresController,
                  specificationsController: _specificationsController,
                  addressController: _addressController,
                  rateAmountController: _rateAmountController,
                  totalSlotsController: _totalSlotsController,
                  estimatedReachController: _estimatedReachController,
                  latitudeController: _latitudeController,
                  longitudeController: _longitudeController,
                  selectedType: _selectedType,
                  selectedClass: _selectedClass,
                  selectedCategoryId: _selectedCategoryId,
                  selectedCountry: _selectedCountry,
                  selectedState: _selectedState,
                  selectedCity: _selectedCity,
                  selectedRateUnit: _selectedRateUnit,
                  thumbnailImage: _thumbnailImage,
                  videoClip: _videoClip,
                  galleryImages: _galleryImages,
                  onTypeChanged: (value) => setState(() => _selectedType = value),
                  onClassChanged: (value) => setState(() => _selectedClass = value),
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
                  onGalleryImagesChanged: (value) => setState(() {
                    _galleryImages.clear();
                    _galleryImages.addAll(value);
                  }),
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
                          widget.isUpdate ? 'Update Screen' : 'Upload Screen',
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
