import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
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
  
  String? selectedType;
  String? selectedCategory;
  bool agreeToTerms = false;

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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (!agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please agree to the Terms & Conditions'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // TODO: Handle template upload
      print('Template Name: ${_templateNameController.text}');
      print('Type: $selectedType');
      print('Category: $selectedCategory');
      print('Tags: ${_tagsController.text}');
      print('Description: ${_descriptionController.text}');
      print('Price: ${_priceController.text}');
      print('Discount: ${_discountController.text}');
      print('Features: ${_featuresController.text}');
      print('Specifications: ${_specificationsController.text}');
      print('Agree to Terms: $agreeToTerms');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
                      selectedType: selectedType,
                      selectedCategory: selectedCategory,
                      onTypeChanged: (value) {
                        setState(() => selectedType = value);
                      },
                      onCategoryChanged: (value) {
                        setState(() => selectedCategory = value);
                      },
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
                      agreeToTerms: agreeToTerms,
                      onTermsChanged: (value) {
                        setState(() => agreeToTerms = value);
                      },
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
}
