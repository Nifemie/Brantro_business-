import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../logic/contact_notifier.dart';
import '../data/models/contact_message_request.dart';
import 'widgets/contact/contact_form_fields.dart';
import 'widgets/contact/contact_header.dart';

class ContactUsScreen extends ConsumerStatefulWidget {
  const ContactUsScreen({super.key});

  @override
  ConsumerState<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends ConsumerState<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Prepare the request
    final request = ContactMessageRequest(
      name: _nameController.text.trim(),
      emailAddress: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
      address: _addressController.text.trim(),
    );

    // Send message using notifier
    await ref.read(contactNotifierProvider.notifier).sendMessage(request);

    // Listen to state changes
    final state = ref.read(contactNotifierProvider);

    if (mounted) {
      if (state.isDataAvailable && state.singleData != null) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            title: Column(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 60.sp),
                SizedBox(height: 16.h),
                Text(
                  'Report Submitted',
                  style: AppTexts.h3(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            content: Text(
              state.singleData!.message,
              style: AppTexts.bodyMedium(color: AppColors.grey700),
              textAlign: TextAlign.center,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx); // Close dialog
                    Navigator.pop(context); // Go back to previous screen
                    // Reset notifier state
                    ref.read(contactNotifierProvider.notifier).reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: AppTexts.labelMedium(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (state.message != null && !state.isDataAvailable) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline, color: AppColors.error, size: 24.sp),
                SizedBox(width: 12.w),
                Text('Error', style: AppTexts.h3(color: AppColors.textPrimary)),
              ],
            ),
            content: Text(
              state.message!,
              style: AppTexts.bodyMedium(color: AppColors.grey700),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // Clear error message
                  ref.read(contactNotifierProvider.notifier).clearMessage();
                },
                child: Text(
                  'OK',
                  style: AppTexts.labelMedium(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactState = ref.watch(contactNotifierProvider);
    final isSubmitting = contactState.isInitialLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Contact Us',
          style: AppTexts.h3(color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  const ContactHeader(),

                  SizedBox(height: 24.h),

                  ContactFormFields(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    subjectController: _subjectController,
                    addressController: _addressController,
                    messageController: _messageController,
                  ),

                  SizedBox(height: 32.h),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        disabledBackgroundColor: AppColors.grey300,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Submit Report',
                              style: AppTexts.labelLarge(color: Colors.white),
                            ),
                    ),
                  ),

                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
