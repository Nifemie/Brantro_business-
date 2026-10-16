import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../logic/withdrawal_accounts_notifier.dart';
import '../../data/models/withdrawal_account_model.dart';
import '../../../../controllers/re_useable/app_button.dart';

class AddWithdrawalAccountBottomSheet extends ConsumerStatefulWidget {
  const AddWithdrawalAccountBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddWithdrawalAccountBottomSheet(),
    );
  }

  @override
  ConsumerState<AddWithdrawalAccountBottomSheet> createState() => _AddWithdrawalAccountBottomSheetState();
}

class _AddWithdrawalAccountBottomSheetState extends ConsumerState<AddWithdrawalAccountBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  bool _isDefault = false;
  
  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newAccount = WithdrawalAccountModel(
        bankName: _bankNameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        accountName: _accountNameController.text.trim(),
        isDefault: _isDefault,
      );
      
      final success = await ref.read(withdrawalAccountsProvider.notifier).addAccount(newAccount);
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account added successfully!'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(withdrawalAccountsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black26,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Add Bank Account',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Enter your bank details to withdraw earnings.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
                SizedBox(height: 24.h),
                TextFormField(
                  controller: _bankNameController,
                  decoration: InputDecoration(
                    hintText: 'Bank Name (e.g. GTBank)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Bank name is required' : null,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Account Number',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Account number is required';
                    if (val.length < 10) return 'Account number must be 10 digits';
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _accountNameController,
                  decoration: InputDecoration(
                    hintText: 'Account Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Account name is required' : null,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Checkbox(
                      value: _isDefault,
                      activeColor: AppColors.primaryColor,
                      onChanged: (val) {
                        setState(() {
                          _isDefault = val ?? false;
                        });
                      },
                    ),
                    Text(
                      'Set as default account',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  child: state.isActionLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryButton(
                          text: 'Save Account',
                          onPressed: _submit,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
