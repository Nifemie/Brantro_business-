import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_button.dart';
import '../../logic/order_action_notifier.dart';

class OrderDecisionDialog extends ConsumerStatefulWidget {
  final dynamic itemId;
  final bool isAccept;
  final VoidCallback onSuccess;

  const OrderDecisionDialog({
    super.key,
    required this.itemId,
    required this.isAccept,
    required this.onSuccess,
  });

  @override
  ConsumerState<OrderDecisionDialog> createState() => _OrderDecisionDialogState();
}

class _OrderDecisionDialogState extends ConsumerState<OrderDecisionDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  final _remarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // Reset end date if it's before new start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    if (widget.isAccept) {
      if (_startDate == null) {
        _showError('Please select a start date');
        return;
      }
      if (_endDate == null) {
        _showError('Please select an end date');
        return;
      }
    }

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    
    ref.read(orderActionNotifierProvider.notifier).makeDecision(
      itemId: widget.itemId,
      decision: widget.isAccept ? 'ACCEPTED' : 'REJECTED',
      startDate: _startDate != null ? formatter.format(_startDate!) : null,
      endDate: _endDate != null ? formatter.format(_endDate!) : null,
      remark: _remarkController.text.trim(),
      onSuccess: () {
        Navigator.of(context).pop();
        widget.onSuccess();
      },
      onError: (error) {
        _showError(error);
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
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
                    widget.isAccept ? 'Accept Order' : 'Reject Order',
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
                widget.isAccept 
                  ? 'Please set the estimated timeframe for completing this order.'
                  : 'Please provide a reason for rejecting this order.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              SizedBox(height: 24.h),

              if (widget.isAccept) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePicker(
                        context,
                        label: 'Start Date',
                        date: _startDate,
                        onTap: () => _selectDate(context, true),
                        isDark: isDark,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildDatePicker(
                        context,
                        label: 'End Date',
                        date: _endDate,
                        onTap: () {
                          if (_startDate == null) {
                            _showError('Please select a start date first');
                            return;
                          }
                          _selectDate(context, false);
                        },
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],

              Text(
                widget.isAccept ? 'Remarks / Notes (Optional)' : 'Reason for Rejection',
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
                  hintText: widget.isAccept 
                    ? 'e.g. Work starts immediately' 
                    : 'Explain why you cannot fulfill this order',
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
                validator: widget.isAccept ? null : (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Reason is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),

              SizedBox(
                width: double.infinity,
                child: FullWidthButton(
                  text: widget.isAccept ? 'Confirm Acceptance' : 'Confirm Rejection',
                  isLoading: actionState.isLoading,
                  onPressed: actionState.isLoading ? null : _submit,
                  // Note: FullWidthButton color might be fixed, if it doesn't take color, we use its default.
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

  Widget _buildDatePicker(BuildContext context, {required String label, required DateTime? date, required VoidCallback onTap, required bool isDark}) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null ? formatter.format(date) : 'Select date',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: date != null 
                      ? (isDark ? Colors.white : Colors.black)
                      : (isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
