import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../logic/withdrawal_accounts_notifier.dart';
import '../data/models/withdrawal_account_model.dart';
import '../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'widgets/add_withdrawal_account_bottom_sheet.dart';

class WithdrawalAccountsScreen extends ConsumerStatefulWidget {
  const WithdrawalAccountsScreen({super.key});

  @override
  ConsumerState<WithdrawalAccountsScreen> createState() => _WithdrawalAccountsScreenState();
}

class _WithdrawalAccountsScreenState extends ConsumerState<WithdrawalAccountsScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(withdrawalAccountsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<WithdrawalAccountsState>(withdrawalAccountsProvider, (previous, next) {
      if (next.actionErrorMessage != null && previous?.actionErrorMessage != next.actionErrorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.actionErrorMessage!), backgroundColor: Colors.red),
        );
      }
    });

    final activeAccounts = state.accounts
        .where((acc) => acc.isActive && acc.status != 'DELETED')
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddWithdrawalAccountBottomSheet(),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'WITHDRAWAL ACCOUNTS'),
            Expanded(
              child: state.isLoading && activeAccounts.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : activeAccounts.isEmpty
                      ? _buildEmptyState(isDark)
                      : RefreshIndicator(
                          onRefresh: () => ref.read(withdrawalAccountsProvider.notifier).fetchAccounts(),
                          child: ListView.separated(
                            padding: EdgeInsets.all(16.w),
                            itemCount: activeAccounts.length,
                            separatorBuilder: (context, index) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final account = activeAccounts[index];
                              return _buildAccountCard(account, isDark);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance, size: 60.sp, color: isDark ? Colors.white24 : Colors.black26),
          SizedBox(height: 16.h),
          Text(
            'No accounts added yet',
            style: TextStyle(
              fontSize: 16.sp,
              color: isDark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add a bank account to start withdrawing.',
            style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white54 : Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(WithdrawalAccountModel account, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: account.isDefault ? AppColors.primaryColor : (isDark ? Colors.white10 : Colors.black12),
          width: account.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            _showAccountOptions(account);
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.account_balance, color: AppColors.primaryColor, size: 24.sp),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.bankName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${account.accountNumber} • ${account.accountName}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (account.isDefault)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAccountOptions(WithdrawalAccountModel account) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black26,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                if (!account.isDefault)
                  ListTile(
                    leading: const Icon(Icons.check_circle_outline, color: AppColors.primaryColor),
                    title: const Text('Set as Default'),
                    onTap: () {
                      Navigator.pop(context);
                      if (account.id != null) {
                        ref.read(withdrawalAccountsProvider.notifier).makeDefault(account.id!);
                      }
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    // Show confirmation dialog before deleting
                    _confirmDelete(account);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(WithdrawalAccountModel account) {
    final lastFour = account.accountNumber.length >= 4
        ? account.accountNumber.substring(account.accountNumber.length - 4)
        : account.accountNumber;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text('Are you sure you want to delete ${account.bankName} ending in $lastFour?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (account.id != null) {
                final success = await ref.read(withdrawalAccountsProvider.notifier).deleteAccount(account.id!);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account deleted successfully'), backgroundColor: Colors.black87),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unable to delete: Missing account identifier.'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
