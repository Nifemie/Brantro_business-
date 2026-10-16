import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../widgets/upload_wall_form.dart';
import '../../logic/wall_provider.dart';
import '../../data/models/wall_model.dart';

class UploadWallScreen extends ConsumerStatefulWidget {
  final bool isUpdate;
  final WallModel? wall;

  const UploadWallScreen({
    super.key,
    this.isUpdate = false,
    this.wall,
  });

  @override
  ConsumerState<UploadWallScreen> createState() => _UploadWallScreenState();
}

class _UploadWallScreenState extends ConsumerState<UploadWallScreen> {
  bool _isLoading = false;

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
  
  String? _selectedType = 'WALL';
  int? _selectedCategoryId = 24;
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
    if (widget.isUpdate && widget.wall != null) {
      final w = widget.wall!;
      _titleController.text = w.name;
      _descriptionController.text = w.description;
      _featuresController.text = w.featuresText;
      _specificationsController.text = w.specifications;
      _addressController.text = w.address;
      _rateAmountController.text = w.price > 0 ? w.price.toString() : '';
      _totalSlotsController.text = (w.totalAdSlots ?? 1).toString();
      _estimatedReachController.text = (w.estimatedReach ?? 0).toString();
      if (w.latitude != null) _latitudeController.text = w.latitude.toString();
      if (w.longitude != null) _longitudeController.text = w.longitude.toString();

      _selectedType = w.type.isNotEmpty ? w.type : 'WALL';
      _selectedState = w.location.isNotEmpty ? w.location : null;
      _selectedCountry = 'Nigeria';
      _thumbnailImage = w.thumbnail.isNotEmpty ? w.thumbnail : null;
      if (w.images.isNotEmpty) {
        _galleryImages.addAll(w.images);
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
      final repository = ref.read(wallProvider.notifier).repository;

      // Upload thumbnail if local file
      String? thumbnailUrl;
      if (_thumbnailImage != null && _thumbnailImage!.isNotEmpty) {
        if (_isLocalFile(_thumbnailImage!)) {
          try {
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

      if (widget.isUpdate && widget.wall != null) {
        await ref.read(wallProvider.notifier).updateWall(widget.wall!.id, formData);
      } else {
        await ref.read(wallProvider.notifier).uploadWall(formData);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isUpdate ? 'Wall updated successfully!' : 'Wall uploaded successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        context.go('/wall-marketplace');
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
            DashboardAppBar(title: widget.isUpdate ? 'EDIT WALL' : 'UPLOAD WALL'),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: UploadWallForm(
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
                          widget.isUpdate ? 'Update Wall' : 'Upload Wall',
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
