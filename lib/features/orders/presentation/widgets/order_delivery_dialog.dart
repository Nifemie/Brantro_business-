import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_button.dart';
import '../../../../core/data/repositories/file_repository.dart';
import '../../logic/order_action_notifier.dart';

class OrderDeliveryDialog extends ConsumerStatefulWidget {
  final dynamic itemId;
  final VoidCallback onSuccess;

  const OrderDeliveryDialog({
    super.key,
    required this.itemId,
    required this.onSuccess,
  });

  @override
  ConsumerState<OrderDeliveryDialog> createState() => _OrderDeliveryDialogState();
}

class _OrderDeliveryDialogState extends ConsumerState<OrderDeliveryDialog> {
  final _feedbackController = TextEditingController();
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isUploadingFile = false;
  String? _pickedFileName;

  @override
  void dispose() {
    _feedbackController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;
        setState(() {
          _isUploadingFile = true;
          _pickedFileName = fileName;
        });

        final fileRepo = ref.read(fileRepositoryProvider);
        final uploadedUrl = await fileRepo.uploadFile(
          filePath,
          prefix: 'service-delivery',
        );

        if (mounted) {
          setState(() {
            _urlController.text = uploadedUrl;
            _isUploadingFile = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploadingFile = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    ref.read(orderActionNotifierProvider.notifier).deliverWork(
      itemId: widget.itemId,
      feedback: _feedbackController.text.trim(),
      attachmentUrl: _urlController.text.trim().isNotEmpty ? _urlController.text.trim() : null,
      onSuccess: () {
        Navigator.of(context).pop();
        widget.onSuccess();
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final actionState = ref.watch(orderActionNotifierProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Deliver Work',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'Submit the final completed work to the customer.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24.h),

                Text(
                  'Final Feedback / Message',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 4,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. Final logo files delivered. Thank you for your business!',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Feedback message is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                Text(
                  'Attachment URL (Optional)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _urlController,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. https://google-drive.com/link-to-files',
                    prefixIcon: Icon(
                      Icons.link,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isUploadingFile ? null : _pickAndUploadFile,
                        icon: _isUploadingFile
                            ? SizedBox(
                                width: 16.r,
                                height: 16.r,
                                child: const CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(Icons.upload_file, size: 18.sp, color: AppColors.primaryColor),
                        label: Text(
                          _isUploadingFile
                              ? 'Uploading File...'
                              : (_pickedFileName != null ? 'Change File' : 'Upload From Device'),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryColor),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_pickedFileName != null) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16.sp, color: Colors.green),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            _pickedFileName!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 32.h),

                SizedBox(
                  width: double.infinity,
                  child: FullWidthButton(
                    text: 'Submit Delivery',
                    isLoading: actionState.isLoading || _isUploadingFile,
                    onPressed: (actionState.isLoading || _isUploadingFile) ? null : _submit,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
