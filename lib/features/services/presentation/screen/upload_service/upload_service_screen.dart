import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../../../logic/service_provider.dart';
import '../../../logic/upload_service_form_provider.dart';
import '../../../../../core/data/repositories/file_repository.dart';
import 'widgets/service_info_form.dart';
import 'widgets/pricing_delivery_form.dart';
import 'widgets/attributes_form.dart';
import 'widgets/media_upload_form.dart';

class UploadServiceScreen extends ConsumerStatefulWidget {
  const UploadServiceScreen({super.key});

  @override
  ConsumerState<UploadServiceScreen> createState() => _UploadServiceScreenState();
}

class _UploadServiceScreenState extends ConsumerState<UploadServiceScreen> {
  final _infoFormKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _specificationsController = TextEditingController();

  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _deliveryTimeController = TextEditingController();
  final _revisionCountController = TextEditingController();
  final _estimatedReachController = TextEditingController();

  final _featuresController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _sampleUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _specificationsController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _deliveryTimeController.dispose();
    _revisionCountController.dispose();
    _estimatedReachController.dispose();
    _featuresController.dispose();
    _requirementsController.dispose();
    _sampleUrlController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (!_infoFormKey.currentState!.validate()) {
      return false;
    }
    
    final formState = ref.read(uploadServiceFormProvider);
    
    if (formState.selectedType == null) {
      _showError('Service type is required');
      return false;
    }
    if (formState.selectedCategoryId == null) {
      _showError('Category is required');
      return false;
    }
    if (_priceController.text.trim().isEmpty) {
      _showError('Price is required');
      return false;
    }
    if (formState.selectedPricingUnit == null) {
      _showError('Pricing unit is required');
      return false;
    }
    if (_deliveryTimeController.text.trim().isEmpty) {
      _showError('Delivery time is required');
      return false;
    }
    if (formState.selectedTimeUnit == null) {
      _showError('Delivery time unit is required');
      return false;
    }
    if (formState.selectedDeliveryFormat == null) {
      _showError('Primary delivery format is required');
      return false;
    }
    if (formState.thumbnailPath == null) {
      _showError('Service thumbnail is required');
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
    if (!_validateForm()) return;

    final formState = ref.read(uploadServiceFormProvider);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final fileRepository = ref.read(fileRepositoryProvider);
      
      final thumbnailUrl = await fileRepository.uploadFile(
        formState.thumbnailPath!,
        prefix: 'service-thumbnail',
      );

      String? sampleUrl = _sampleUrlController.text;
      if (formState.sampleFilePath != null && formState.sampleFilePath!.isNotEmpty) {
        sampleUrl = await fileRepository.uploadFile(
          formState.sampleFilePath!,
          prefix: 'service-sample',
        );
      }

      final List<String> galleryUrls = [];
      for (final path in formState.galleryPaths) {
        final url = await fileRepository.uploadFile(
          path,
          prefix: 'service-gallery',
        );
        if (url != null) galleryUrls.add(url);
      }

      final featuresList = formState.features;
      final requirementsList = formState.requirements;

      final payload = {
        'categoryId': formState.selectedCategoryId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'specifications': _specificationsController.text,
        'type': formState.selectedType?.toUpperCase().replaceAll(' ', '_'),
        'features': featuresList,
        'requirements': requirementsList,
        'price': double.tryParse(_priceController.text) ?? 0,
        'pricingUnit': formState.selectedPricingUnit,
        'discount': double.tryParse(_discountController.text) ?? 0,
        'coverageAreas': formState.coverageAreas,
        'estimatedReach': int.tryParse(_estimatedReachController.text) ?? 0,
        'deliveryTime': int.tryParse(_deliveryTimeController.text) ?? 0,
        'deliveryTimeUnit': formState.selectedTimeUnit,
        'revisionCount': int.tryParse(_revisionCountController.text) ?? 0,
        'deliveryFormats': [formState.selectedDeliveryFormat],
        'thumbnail': thumbnailUrl,
        'sampleUrl': sampleUrl,
        'gallery': galleryUrls,
        'tags': formState.tags,
        'status': 'ACTIVE',
      };

      final success = await ref.read(serviceProvider.notifier).createService(payload);

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Service uploaded successfully!'), backgroundColor: Colors.green),
          );
          context.go('/service-marketplace');
        } else {
          final error = ref.read(serviceProvider).message ?? 'Failed to upload service';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading service: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final formState = ref.watch(uploadServiceFormProvider);
    final formNotifier = ref.read(uploadServiceFormProvider.notifier);
    final isUploading = ref.watch(serviceProvider).isInitialLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const SidebarMenu(),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'UPLOAD SERVICE'),
            Expanded(
              child: isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          ServiceInfoForm(
                            formKey: _infoFormKey,
                            titleController: _titleController,
                            descriptionController: _descriptionController,
                            specificationsController: _specificationsController,
                            selectedType: formState.selectedType,
                            selectedCategoryId: formState.selectedCategoryId,
                            onTypeChanged: formNotifier.setType,
                            onCategoryChanged: formNotifier.setCategory,
                          ),
                          
                          Divider(height: 40.h, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                          
                          PricingDeliveryForm(
                            priceController: _priceController,
                            discountController: _discountController,
                            deliveryTimeController: _deliveryTimeController,
                            revisionCountController: _revisionCountController,
                            estimatedReachController: _estimatedReachController,
                            selectedPricingUnit: formState.selectedPricingUnit,
                            selectedTimeUnit: formState.selectedTimeUnit,
                            onPricingUnitChanged: formNotifier.setPricingUnit,
                            onTimeUnitChanged: formNotifier.setTimeUnit,
                          ),
                          
                          Divider(height: 40.h, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                          
                          AttributesForm(
                            features: formState.features,
                            requirements: formState.requirements,
                            selectedDeliveryFormat: formState.selectedDeliveryFormat,
                            coverageAreas: formState.coverageAreas,
                            tags: formState.tags,
                            selectedType: formState.selectedType,
                            onFeaturesChanged: formNotifier.setFeatures,
                            onRequirementsChanged: formNotifier.setRequirements,
                            onDeliveryFormatChanged: formNotifier.setDeliveryFormat,
                            onCoverageAreasChanged: formNotifier.setCoverageAreas,
                            onTagsChanged: formNotifier.setTags,
                          ),
                          
                          Divider(height: 40.h, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                          
                          MediaUploadForm(
                            thumbnailPath: formState.thumbnailPath,
                            sampleFilePath: formState.sampleFilePath,
                            sampleUrlController: _sampleUrlController,
                            galleryPaths: formState.galleryPaths,
                            onThumbnailChanged: formNotifier.setThumbnailPath,
                            onSampleFileChanged: formNotifier.setSampleFilePath,
                            onGalleryChanged: formNotifier.setGalleryPaths,
                          ),
                          
                          SizedBox(height: 40.h),
                          
                          // Submit Button Row
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => context.pop(),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 14.h),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                    side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: isDark ? Colors.white70 : AppColors.textPrimary,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 14.h),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                  ),
                                  child: Text(
                                    'Upload Service',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
