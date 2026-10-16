import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_button.dart';
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

  @override
  void dispose() {
    _feedbackController.dispose();
    _urlController.dispose();
    super.dispose();
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
                SizedBox(height: 32.h),

                SizedBox(
                  width: double.infinity,
                  child: FullWidthButton(
                    text: 'Submit Delivery',
                    isLoading: actionState.isLoading,
                    onPressed: actionState.isLoading ? null : _submit,
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
