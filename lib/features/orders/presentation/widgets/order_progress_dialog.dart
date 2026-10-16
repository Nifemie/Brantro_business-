import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_button.dart';
import '../../logic/order_action_notifier.dart';

class OrderProgressDialog extends ConsumerStatefulWidget {
  final dynamic itemId;
  final VoidCallback onSuccess;

  const OrderProgressDialog({
    super.key,
    required this.itemId,
    required this.onSuccess,
  });

  @override
  ConsumerState<OrderProgressDialog> createState() => _OrderProgressDialogState();
}

class _OrderProgressDialogState extends ConsumerState<OrderProgressDialog> {
  final _remarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _percent = 10.0;

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    ref.read(orderActionNotifierProvider.notifier).updateProgress(
      itemId: widget.itemId,
      remark: _remarkController.text.trim(),
      percent: _percent.toInt(),
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
                      'Update Progress',
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
                  'Keep your customer updated on the status of their order.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24.h),

                Text(
                  'Completion Status: ${_percent.toInt()}%',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Slider(
                  value: _percent,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  activeColor: AppColors.primaryColor,
                  inactiveColor: isDark ? Colors.grey[800] : Colors.grey[300],
                  label: '${_percent.toInt()}%',
                  onChanged: (value) {
                    setState(() {
                      _percent = value;
                    });
                  },
                ),
                SizedBox(height: 20.h),

                Text(
                  'Remarks / Notes',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _remarkController,
                  maxLines: 3,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. Initial concepts completed',
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
                      return 'Remark is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),

                SizedBox(
                  width: double.infinity,
                  child: FullWidthButton(
                    text: 'Submit Progress',
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
