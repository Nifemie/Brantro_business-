import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../../../controllers/re_useable/app_button.dart';
import '../../data/models/bank_model.dart';
import '../../data/models/withdrawal_account_model.dart';
import '../../logic/wallet_notifier.dart';
import '../../logic/withdrawal_accounts_notifier.dart';

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
  ConsumerState<AddWithdrawalAccountBottomSheet> createState() =>
      _AddWithdrawalAccountBottomSheetState();
}

class _AddWithdrawalAccountBottomSheetState
    extends ConsumerState<AddWithdrawalAccountBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();

  BankModel? _selectedBank;
  String? _resolvedAccountName;
  bool _isResolving = false;
  String? _resolutionError;
  bool _isDefault = false;

  Timer? _resolveDebounceTimer;

  @override
  void initState() {
    super.initState();
    _accountNumberController.addListener(_onAccountNumberChanged);
  }

  @override
  void dispose() {
    _resolveDebounceTimer?.cancel();
    _bankNameController.dispose();
    _accountNumberController.removeListener(_onAccountNumberChanged);
    _accountNumberController.dispose();
    super.dispose();
  }

  void _onAccountNumberChanged() {
    final text = _accountNumberController.text.trim();

    // If fewer than 10 digits, reset any previous resolution
    if (text.length < 10) {
      if (_resolvedAccountName != null || _resolutionError != null || _isResolving) {
        setState(() {
          _resolvedAccountName = null;
          _resolutionError = null;
          _isResolving = false;
        });
      }
      return;
    }

    // Exactly 10 digits entered
    if (text.length == 10) {
      if (_selectedBank == null) {
        setState(() {
          _resolvedAccountName = null;
          _resolutionError = 'Please select a bank to verify your account';
          _isResolving = false;
        });
        return;
      }

      _triggerResolution();
    }
  }

  void _triggerResolution() {
    _resolveDebounceTimer?.cancel();
    _resolveDebounceTimer = Timer(const Duration(milliseconds: 250), () {
      _resolveAccount();
    });
  }

  Future<void> _resolveAccount() async {
    final bank = _selectedBank;
    final accountNumber = _accountNumberController.text.trim();

    if (bank == null || accountNumber.length != 10) return;

    setState(() {
      _isResolving = true;
      _resolutionError = null;
      _resolvedAccountName = null;
    });

    try {
      final repository = ref.read(walletRepositoryProvider);
      final result = await repository.resolveAccount(
        bankId: bank.id,
        accountNumber: accountNumber,
      );

      if (!mounted) return;

      if (result.verified && result.accountName.isNotEmpty) {
        setState(() {
          _resolvedAccountName = result.accountName;
          _isResolving = false;
          _resolutionError = null;
        });
      } else {
        setState(() {
          _resolvedAccountName = null;
          _isResolving = false;
          _resolutionError =
              'We could not verify this account number for the selected bank.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        _resolvedAccountName = null;
        _isResolving = false;
        _resolutionError = msg;
      });
    }
  }

  void _showBankPicker(bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BankPickerModal(
        selectedBank: _selectedBank,
        isDark: isDark,
        onBankSelected: (bank) {
          setState(() {
            _selectedBank = bank;
            _bankNameController.text = bank.name;
            // Clear previous verification when bank changes
            _resolvedAccountName = null;
            _resolutionError = null;
          });

          // If 10 digits are already typed, automatically resolve with new bank
          if (_accountNumberController.text.trim().length == 10) {
            _triggerResolution();
          }
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a bank'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_resolvedAccountName == null || _resolvedAccountName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for account name verification before saving.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newAccount = WithdrawalAccountModel(
      bankId: _selectedBank!.id,
      bankName: _selectedBank!.name,
      accountNumber: _accountNumberController.text.trim(),
      accountName: _resolvedAccountName!,
      isDefault: _isDefault,
    );

    final success = await ref
        .read(withdrawalAccountsProvider.notifier)
        .addAccount(newAccount);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (!success && mounted) {
      final errorMsg = ref.read(withdrawalAccountsProvider).actionErrorMessage ??
          'Failed to save account. Please verify bank details.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(withdrawalAccountsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isVerified = _resolvedAccountName != null &&
        _resolvedAccountName!.isNotEmpty &&
        !_isResolving;
    final canSubmit = isVerified && !state.isActionLoading;

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
            child: SingleChildScrollView(
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
                  SizedBox(height: 6.h),
                  Text(
                    'Select your bank and enter your 10-digit NUBAN number. Your account name will be verified automatically.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Bank Picker Field
                  InkWell(
                    onTap: () => _showBankPicker(isDark),
                    borderRadius: BorderRadius.circular(12.r),
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: _bankNameController,
                        decoration: InputDecoration(
                          labelText: 'Bank Name',
                          hintText: 'Select your bank',
                          prefixIcon: const Icon(Icons.account_balance),
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Please select your bank'
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Account Number Field
                  TextFormField(
                    controller: _accountNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: 'NUBAN Account Number',
                      hintText: '10-digit account number',
                      prefixIcon: const Icon(Icons.credit_card),
                      suffixIcon: _isResolving
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : isVerified
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Account number is required';
                      }
                      final clean = val.trim();
                      if (clean.length != 10) {
                        return 'Enter a valid 10-digit account number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Verified Account Name (Read-Only) or Resolution State
                  if (_isResolving) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isDark ? Colors.white12 : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Verifying account name...',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ] else if (isVerified) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.verified,
                                color: Colors.green.shade700,
                                size: 18.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'Account Name Verified',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            _resolvedAccountName!,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ] else if (_resolutionError != null) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade700,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _resolutionError!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (_selectedBank != null &&
                                    _accountNumberController.text.trim().length == 10) ...[
                                  SizedBox(height: 6.h),
                                  InkWell(
                                    onTap: _resolveAccount,
                                    child: Text(
                                      'Retry Verification',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  // Default Checkbox
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
                        'Set as default withdrawal account',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Submit Button (Enabled only when verified)
                  SizedBox(
                    width: double.infinity,
                    child: state.isActionLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            text: 'Add Account',
                            isEnabled: canSubmit,
                            onPressed: () {
                              if (canSubmit) {
                                _submit();
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Modal sheet for searching and selecting a Nigerian bank
class _BankPickerModal extends ConsumerStatefulWidget {
  final BankModel? selectedBank;
  final bool isDark;
  final ValueChanged<BankModel> onBankSelected;

  const _BankPickerModal({
    required this.selectedBank,
    required this.isDark,
    required this.onBankSelected,
  });

  @override
  ConsumerState<_BankPickerModal> createState() => _BankPickerModalState();
}

class _BankPickerModalState extends ConsumerState<_BankPickerModal> {
  final _searchController = TextEditingController();
  List<BankModel> _banks = [];
  bool _isLoading = true;
  String? _error;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _fetchBanks();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchBanks([String? query]) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = ref.read(walletRepositoryProvider);
      final banks = await repository.getBanks(query: query);
      if (mounted) {
        setState(() {
          _banks = banks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load banks. Please check your internet connection.';
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _fetchBanks(query.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: widget.isDark ? Colors.white24 : Colors.black26,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Bank',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.isDark ? Colors.white : Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Nigerian bank...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _fetchBanks();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: widget.isDark
                                    ? Colors.white60
                                    : Colors.black54,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            TextButton.icon(
                              onPressed: () =>
                                  _fetchBanks(_searchController.text.trim()),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _banks.isEmpty
                        ? Center(
                            child: Text(
                              'No banks found',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: widget.isDark
                                    ? Colors.white54
                                    : Colors.black54,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _banks.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: widget.isDark
                                  ? Colors.white12
                                  : Colors.grey.shade200,
                            ),
                            itemBuilder: (context, index) {
                              final bank = _banks[index];
                              final isSelected =
                                  widget.selectedBank?.id == bank.id;

                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 18.r,
                                  backgroundColor: AppColors.primaryColor
                                      .withValues(alpha: 0.1),
                                  child: Icon(
                                    Icons.account_balance,
                                    size: 18.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                title: Text(
                                  bank.name,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : (widget.isDark
                                            ? Colors.white
                                            : Colors.black87),
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: AppColors.primaryColor,
                                      )
                                    : null,
                                onTap: () {
                                  widget.onBankSelected(bank);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
