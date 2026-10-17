import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_button.dart';
import '../logic/withdrawal_accounts_notifier.dart';
import '../logic/wallet_notifier.dart';
import '../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../data/models/withdrawal_account_model.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({super.key});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _narrationController = TextEditingController();
  WithdrawalAccountModel? _selectedAccount;
  bool _isLoading = false;

  Future<void> _navigateToAccounts() async {
    await context.push('/wallet/withdrawal-accounts');
    if (mounted) {
      await ref.read(withdrawalAccountsProvider.notifier).fetchAccounts();
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch accounts when screen opens to ensure we have the latest list
    Future.microtask(() {
      ref.read(withdrawalAccountsProvider.notifier).fetchAccounts();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _narrationController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a withdrawal account')),
      );
      return;
    }

    if (!_selectedAccount!.isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selected account is not verified. Please verify or choose a verified account.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.tryParse(_amountController.text.trim()) ?? 0;
      final narration = _narrationController.text.trim().isEmpty ? 'Withdrawal' : _narrationController.text.trim();
      
      await ref.read(walletRepositoryProvider).requestWithdrawal(
        amount: amount,
        accountId: _selectedAccount!.id!,
        narration: narration,
      );

      // Refresh wallet balance
      ref.read(walletProvider.notifier).refreshWallet();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Withdrawal request submitted successfully!'), backgroundColor: Colors.green),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accountsState = ref.watch(withdrawalAccountsProvider);

    // Sync selected account with latest accounts list
    WithdrawalAccountModel? effectiveAccount;
    if (_selectedAccount != null) {
      effectiveAccount = accountsState.accounts.cast<WithdrawalAccountModel?>().firstWhere(
        (acc) => acc?.id == _selectedAccount!.id || acc?.accountNumber == _selectedAccount!.accountNumber,
        orElse: () => null,
      );
    }
    effectiveAccount ??= accountsState.accounts.cast<WithdrawalAccountModel?>().firstWhere(
      (acc) => acc?.isDefault == true && acc?.isVerified == true,
      orElse: () => accountsState.accounts.cast<WithdrawalAccountModel?>().firstWhere(
        (acc) => acc?.isVerified == true,
        orElse: () => accountsState.accounts.isNotEmpty ? accountsState.accounts.first : null,
      ),
    );
    _selectedAccount = effectiveAccount;

    // Check if user has at least one verified account and current selection is verified
    final hasAnyVerified = accountsState.accounts.any((acc) => acc.isVerified);
    final isSelectedVerified = _selectedAccount?.isVerified ?? false;
    final canWithdraw = hasAnyVerified && isSelectedVerified;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'WITHDRAW FUNDS'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Verification Warning Card ONLY if no verified account exists or currently selected is unverified
                      if (!accountsState.isLoading &&
                          accountsState.accounts.isNotEmpty &&
                          (!hasAnyVerified || !isSelectedVerified)) ...[
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(isDark ? 0.15 : 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.amber.shade700.withOpacity(0.4)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800, size: 24.sp),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      !hasAnyVerified
                                          ? 'Account Verification Required'
                                          : 'Verified Account Needed',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      !hasAnyVerified
                                          ? 'You must have a verified withdrawal bank account before you can withdraw funds.'
                                          : 'Please select a verified bank account to proceed with withdrawal.',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: isDark ? Colors.white70 : Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    InkWell(
                                      onTap: _navigateToAccounts,
                                      child: Text(
                                        'Manage & Verify Accounts →',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],

                      Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          prefixText: '₦ ',
                          prefixStyle: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                          hintText: '0.00',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Amount is required';
                          final amount = double.tryParse(val);
                          if (amount == null || amount <= 0) return 'Invalid amount';
                          return null;
                        },
                      ),
                      
                      SizedBox(height: 32.h),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Withdraw to',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (accountsState.accounts.isNotEmpty)
                            TextButton(
                              onPressed: _navigateToAccounts,
                              child: Text('Manage', style: TextStyle(color: AppColors.primaryColor)),
                            ),
                        ],
                      ),
                      
                      SizedBox(height: 8.h),
                      
                      if (accountsState.isLoading && accountsState.accounts.isEmpty)
                        const Center(child: CircularProgressIndicator())
                      else if (accountsState.accounts.isEmpty)
                        _buildEmptyAccounts(isDark)
                      else
                        _buildAccountSelector(accountsState.accounts, isDark),
                        
                      SizedBox(height: 32.h),
                      
                      Text(
                        'Narration (Optional)',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _narrationController,
                        decoration: InputDecoration(
                          hintText: 'What is this withdrawal for?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        ),
                      ),
                      
                      SizedBox(height: 48.h),
                      
                      SizedBox(
                        width: double.infinity,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PrimaryButton(
                                text: 'Request Withdrawal',
                                isEnabled: canWithdraw,
                                onPressed: _submit,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAccounts(bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        children: [
          Icon(Icons.account_balance, size: 40.sp, color: Colors.grey),
          SizedBox(height: 12.h),
          Text(
            'No bank accounts added',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          PrimaryButton(
            text: 'Add Account',
            onPressed: _navigateToAccounts,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSelector(List<WithdrawalAccountModel> accounts, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<WithdrawalAccountModel>(
          value: _selectedAccount,
          isExpanded: true,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primaryColor),
          items: accounts.map((account) {
            final isVerified = account.isVerified;
            return DropdownMenuItem<WithdrawalAccountModel>(
              value: account,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: (isVerified ? Colors.green : Colors.orange).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance,
                      color: isVerified ? Colors.green : Colors.orange,
                      size: 16.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              account.bankName,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                            ),
                            if (account.isDefault) ...[
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'DEFAULT',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: (isVerified ? Colors.green : Colors.orange).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                isVerified ? 'VERIFIED' : 'PENDING',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isVerified ? Colors.green : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${account.accountNumber} • ${account.accountName}',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedAccount = value;
            });
          },
        ),
      ),
    );
  }
}
