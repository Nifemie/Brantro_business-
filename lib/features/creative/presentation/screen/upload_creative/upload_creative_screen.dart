import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../../core/data/repositories/file_repository.dart';
import '../../../../../core/utils/thousands_separator_input_formatter.dart';
import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
import '../../../logic/creative_notifier.dart';
import '../../../logic/creative_provider.dart';
import '../../../logic/upload_creative_form_provider.dart';
import 'package:brantro_business/features/creative/data/models/creative_model.dart';
import 'widgets/creative_attributes_form.dart';
import 'widgets/creative_file_upload_section.dart';
import 'widgets/creative_information_form.dart';

class UploadCreativeScreen extends ConsumerStatefulWidget {
  final CreativeModel? creative;
  final bool isUpdate;

  const UploadCreativeScreen({
    super.key,
    this.creative,
    this.isUpdate = false,
  });

  @override
  ConsumerState<UploadCreativeScreen> createState() => _UploadCreativeScreenState();
}

class _UploadCreativeScreenState extends ConsumerState<UploadCreativeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for Creative Information
  final _titleController = TextEditingController();
  final _fileSizeController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.creative != null) {
      final c = widget.creative!;
      _titleController.text = c.name;
      _descriptionController.text = c.description;
      _priceController.text = c.price.toStringAsFixed(0);
      _discountController.text = c.discount.toStringAsFixed(0);
      _fileSizeController.text = c.fileSizeMB > 0 ? c.fileSizeMB.toString() : '';
      _durationController.text = c.durationInSeconds > 0 ? c.durationInSeconds.toString() : '';
      _widthController.text = c.width > 0 ? c.width.toString() : '';
      _heightController.text = c.height > 0 ? c.height.toString() : '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final formNotifier = ref.read(uploadCreativeFormProvider.notifier);
        if (c.type.isNotEmpty) {
          formNotifier.setType(c.type);
        }
        if (c.format.isNotEmpty) {
          formNotifier.setFormat(c.format);
        }
        formNotifier.setFeatures(c.features);
        formNotifier.setTags(c.tags);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fileSizeController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(uploadCreativeFormProvider);
    final formNotifier = ref.read(uploadCreativeFormProvider.notifier);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const SidebarMenu(),
      body: SafeArea(
        child: Column(
          children: [
            DashboardAppBar(title: widget.isUpdate ? 'EDIT CREATIVE' : 'UPLOAD CREATIVE'),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Creative Information Section
                    CreativeInformationForm(
                      formKey: _formKey,
                      titleController: _titleController,
                      fileSizeController: _fileSizeController,
                      durationController: _durationController,
                      priceController: _priceController,
                      discountController: _discountController,
                      widthController: _widthController,
                      heightController: _heightController,
                      descriptionController: _descriptionController,
                      selectedType: formState.selectedType,
                      selectedCategoryId: formState.selectedCategoryId,
                      selectedFormat: formState.selectedFormat,
                      onTypeChanged: (type) => formNotifier.setType(type),
                      onCategoryChanged: (id) => formNotifier.setCategory(id),
                      onFormatChanged: (format) => formNotifier.setFormat(format),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    CreativeAttributesForm(
                      selectedType: formState.selectedType,
                      features: formState.features,
                      tags: formState.tags,
                      onFeaturesChanged: (f) => formNotifier.setFeatures(f),
                      onTagsChanged: (t) => formNotifier.setTags(t),
                    ),

                    SizedBox(height: 16.h),
                    
                    // File Upload Section
                    CreativeFileUploadSection(
                      onSubmit: _handleSubmit,
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

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final formState = ref.read(uploadCreativeFormProvider);

      if (formState.selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category'), backgroundColor: Colors.red));
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
          formState.thumbnailPath!,
          prefix: 'creative-thumbnail',
        );

        String? fileUrl = formState.creativeFileUrl;
        if (formState.creativeFilePath != null) {
          fileUrl = await fileRepository.uploadFile(
            formState.creativeFilePath!,
            prefix: 'creative-file',
          );
        }

        if (fileUrl == null || fileUrl.isEmpty) {
          if (mounted) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Creative file URL cannot be empty'), backgroundColor: Colors.red));
          }
          return;
        }

        final payload = {
          'title': _titleController.text,
          'categoryId': formState.selectedCategoryId,
          'description': _descriptionController.text,
          'type': formState.selectedType?.toUpperCase(),
          'format': formState.selectedFormat?.toUpperCase(),
          'fileUrl': fileUrl ?? '',
          'thumbnail': thumbnailUrl,
          'price': ThousandsSeparatorInputFormatter.tryParseDouble(_priceController.text) ?? 0,
          'discount': ThousandsSeparatorInputFormatter.tryParseDouble(_discountController.text) ?? 0,
          'durationInSeconds': int.tryParse(_durationController.text) ?? 0,
          'width': int.tryParse(_widthController.text) ?? 0,
          'height': int.tryParse(_heightController.text) ?? 0,
          'features': formState.features,
          'tags': formState.tags,
          'fileSizeMB': double.tryParse(_fileSizeController.text) ?? 0,
          'status': 'ACTIVE',
        };

        final success = await ref.read(creativeProvider.notifier).createCreative(payload);

        if (mounted) {
          context.pop(); // Remove loading dialog

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Creative uploaded successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            ref.read(uploadCreativeFormProvider.notifier).reset();
            context.go('/creative-marketplace');
          } else {
            final error = ref.read(creativeProvider).message ?? 'Failed to upload creative';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          context.pop(); // Remove loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}
