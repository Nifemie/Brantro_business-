import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../core/data/repositories/file_repository.dart';
import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../../../logic/template_provider.dart';
import '../../../logic/upload_template_form_provider.dart';
import 'widgets/template_information_form.dart';
import 'widgets/pricing_details_form.dart';
import 'widgets/additional_details_form.dart';
import 'widgets/file_upload_section.dart';

class UploadTemplateScreen extends ConsumerStatefulWidget {
  const UploadTemplateScreen({super.key});

  @override
  ConsumerState<UploadTemplateScreen> createState() => _UploadTemplateScreenState();
}

class _UploadTemplateScreenState extends ConsumerState<UploadTemplateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fileUploadFormKey = GlobalKey<FormState>();
  final _templateNameController = TextEditingController();
  final _tagsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _featuresController = TextEditingController();
  final _specificationsController = TextEditingController();

  @override
  void dispose() {
    _templateNameController.dispose();
    _tagsController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _featuresController.dispose();
    _specificationsController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final formState = ref.read(uploadTemplateFormProvider);
    
    if (formState.thumbnailFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a thumbnail image'), backgroundColor: Colors.red),
      );
      return;
    }
    
    if (formState.designFile == null && (formState.designFileUrl == null || formState.designFileUrl!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a design file or provide a URL'), backgroundColor: Colors.red),
      );
      return;
    }
    
    if (!formState.agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and conditions'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final fileRepository = ref.read(fileRepositoryProvider);
      
      final thumbnailUrl = await fileRepository.uploadFile(
        formState.thumbnailFile!.path,
        prefix: 'template-thumbnail',
      );

      String? designFileUrl = formState.designFileUrl;
      if (formState.designFile != null) {
        designFileUrl = await fileRepository.uploadFile(
          formState.designFile!.path,
          prefix: 'template-design',
        );
      }

      final tags = _tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final payload = {
        'title': _templateNameController.text,
        'description': _descriptionController.text,
        'categoryId': formState.selectedCategoryId,
        'type': formState.selectedType?.toUpperCase().replaceAll(' ', '_'),
        'tags': tags,
        'designUrl': designFileUrl ?? '',
        'fileUrl': '',
        'thumbnail': thumbnailUrl,
        'specifications': _specificationsController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'discount': double.tryParse(_discountController.text) ?? 0.0,
        'status': 'ACTIVE',
      };

      final success = await ref.read(templateProvider.notifier).createTemplate(payload);

      if (mounted) {
        context.pop(); // Remove loading dialog

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Template uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/template-marketplace');
        } else {
          final error = ref.read(templateProvider).message ?? 'Failed to upload template';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(uploadTemplateFormProvider);
    final formNotifier = ref.read(uploadTemplateFormProvider.notifier);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const SidebarMenu(),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'UPLOAD TEMPLATE'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // Template Information Section
                    TemplateInformationForm(
                      formKey: _formKey,
                      templateNameController: _templateNameController,
                      tagsController: _tagsController,
                      descriptionController: _descriptionController,
                      selectedType: formState.selectedType,
                      selectedCategoryId: formState.selectedCategoryId,
                      onTypeChanged: formNotifier.setType,
                      onCategoryChanged: formNotifier.setCategory,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Pricing Details Section
                    PricingDetailsForm(
                      priceController: _priceController,
                      discountController: _discountController,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Additional Details Section
                    AdditionalDetailsForm(
                      featuresController: _featuresController,
                      specificationsController: _specificationsController,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // File Upload Section
                    FileUploadSection(
                      formKey: _fileUploadFormKey,
                      agreeToTerms: formState.agreeToTerms,
                      onTermsChanged: formNotifier.setAgreeToTerms,
                      onSubmit: _handleSubmit,
                      onThumbnailSelected: formNotifier.setThumbnail,
                      onDesignFileSelected: formNotifier.setDesignFile,
                      onDesignUrlChanged: formNotifier.setDesignUrl,
                      onVideoSelected: formNotifier.setVideoFile,
                      onVideoUrlChanged: formNotifier.setVideoUrl,
                    ),
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
