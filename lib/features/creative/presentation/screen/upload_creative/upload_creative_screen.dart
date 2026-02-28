import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../controllers/re_useable/app_color.dart';
import '../../../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../../../dashboard/presentation/widgets/sidebar_menu.dart';
import 'widgets/creative_information_form.dart';
import 'widgets/creative_file_upload_section.dart';

class UploadCreativeScreen extends ConsumerStatefulWidget {
  const UploadCreativeScreen({super.key});

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
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _fileSizeController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            const DashboardAppBar(title: 'UPLOAD CREATIVE'),
            
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
                      widthController: _widthController,
                      heightController: _heightController,
                      descriptionController: _descriptionController,
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

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Creative uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back to creative marketplace
      context.go('/creative-marketplace');
    }
  }
}
