import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../core/service/session_service.dart';
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
  void initState() {
    super.initState();
    _prefillUserData();
  }

  Future<void> _prefillUserData() async {
    final user = await SessionService.getUser();
    if (user != null && mounted) {
      setState(() {
        if (_nameController.text.isEmpty && user['fullName'] != null) {
          _nameController.text = user['fullName'].toString();
        }
        if (_emailController.text.isEmpty && user['email'] != null) {
          _emailController.text = user['email'].toString();
        }
        if (_phoneController.text.isEmpty && user['phoneNumber'] != null) {
          _phoneController.text = user['phoneNumber'].toString();
        }
        if (_addressController.text.isEmpty && user['address'] != null) {
          _addressController.text = user['address'].toString();
        }
      });
    }
  }

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

    final request = ContactMessageRequest(
      name: _nameController.text.trim(),
      emailAddress: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
      address: _addressController.text.trim(),
    );

    await ref.read(contactNotifierProvider.notifier).sendMessage(request);

    final state = ref.read(contactNotifierProvider);

    if (mounted) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      if (state.isDataAvailable && state.singleData != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E232D) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Column(
              children: [
                Icon(Icons.check_circle_rounded, color: AppColors.success, size: 56.sp),
                SizedBox(height: 12.h),
                Text(
                  'Message Sent',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            content: Text(
              state.singleData!.message,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.white70 : AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (context.canPop()) {
                      context.pop();
                    }
                    ref.read(contactNotifierProvider.notifier).reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (state.message != null && !state.isDataAvailable) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1E232D) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: AppColors.error, size: 24.sp),
                SizedBox(width: 10.w),
                Text(
                  'Unable to Send',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            content: Text(
              state.message!,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.white70 : AppColors.grey700,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ref.read(contactNotifierProvider.notifier).clearMessage();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final contactState = ref.watch(contactNotifierProvider);
    final isSubmitting = contactState.isInitialLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isDark ? const Color(0xFF12151B) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF12151B) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 12.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ContactHeader(),

                SizedBox(height: 20.h),

                ContactFormFields(
                  nameController: _nameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  subjectController: _subjectController,
                  addressController: _addressController,
                  messageController: _messageController,
                ),

                SizedBox(height: 28.h),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.5),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: isSubmitting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 18.w,
                                width: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Sending Message...',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Submit Message',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
