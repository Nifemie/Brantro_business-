import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../core/service/session_service.dart';
import '../logic/wallet_notifier.dart';
import '../logic/transactions_notifier.dart';
import '../data/models/transaction_model.dart';
import 'widgets/balance_card.dart';
import 'widgets/quick_action_button.dart';
import 'widgets/transaction_card.dart';
import '../../../core/widgets/skeleton_loading.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  bool _isLoading = true;
  bool _isGuest = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await SessionService.isLoggedIn();
    
    setState(() {
      _isGuest = !isLoggedIn;
      _isLoading = false;
    });

    // Only fetch wallet and transactions if user is logged in
    if (isLoggedIn) {
      Future.microtask(() {
        ref.read(walletProvider.notifier).fetchWallet();
        ref.read(transactionsProvider.notifier).fetchTransactions();
      });
    }
  }

  Future<void> _handleRefresh() async {
    await Future.wait([
      ref.read(walletProvider.notifier).refreshWallet(),
      ref.read(transactionsProvider.notifier).fetchTransactions(refresh: true),
    ]);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wallet refreshed'),
          backgroundColor: AppColors.primaryColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Helper to convert API transaction type to UI enum
  TransactionType _getTransactionType(String apiType) {
    switch (apiType.toUpperCase()) {
      case 'CREDIT':
      case 'UPDATE':
        return TransactionType.deposit;
      case 'DEBIT':
        return TransactionType.withdrawal;
      case 'TRANSFER_IN':
        return TransactionType.transferIn;
      case 'TRANSFER_OUT':
        return TransactionType.transferOut;
      case 'REQUEST':
        return TransactionType.request;
      case 'REFUND':
        return TransactionType.refund;
      default:
        return TransactionType.deposit;
    }
  }

  // Helper to convert API transaction status to UI enum
  TransactionStatus _getTransactionStatus(String apiStatus) {
    // All transactions in the list are completed
    return TransactionStatus.completed;
  }

  // Helper to format transaction date
  String _formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    final wallet = walletState.wallet;

    // Show loading while checking login status
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        body: _buildPageSkeleton(),
      );
    }

    // Show guest view if not logged in
    if (_isGuest) {
      return Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text('Wallet', style: AppTexts.h2()),
        ),
        body: _buildGuestView(),
      );
    }

    // Logged in user view
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Wallet', style: AppTexts.h2()),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Navigate to wallet settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wallet settings coming soon')),
              );
            },
          ),
        ],
      ),
      body: walletState.isLoading && wallet == null
          ? _buildPageSkeleton()
          : walletState.errorMessage != null && wallet == null
              ? _buildErrorState(walletState.errorMessage!)
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: AppColors.primaryColor,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Balance Card
                        BalanceCard(
                          balance: wallet?.balance ?? '0.00',
                          pendingBalance: wallet?.pendingBalance ?? '0.00',
                          currency: wallet?.currency ?? '₦',
                          status: wallet?.status ?? 'INACTIVE',
                        ),

                        SizedBox(height: 24.h),

                        // Quick Actions
                        Text('Quick Actions', style: AppTexts.h3()),
                        SizedBox(height: 12.h),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 1.3,
                          children: [
                            QuickActionButton(
                              icon: Icons.add_circle_outline,
                              label: 'Add Money',
                              onTap: () {
                                // TODO: Navigate to add money screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Add money screen coming soon')),
                                );
                              },
                            ),
                            QuickActionButton(
                              icon: Icons.arrow_upward,
                              label: 'Withdraw',
                              onTap: () {
                                // TODO: Navigate to withdraw screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Withdraw screen coming soon')),
                                );
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        // Recent Transactions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recent Transactions', style: AppTexts.h3()),
                            TextButton(
                              onPressed: () {
                                context.push('/wallet/transactions');
                              },
                              child: Text(
                                'View All',
                                style: AppTexts.bodyMedium(color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        // Transaction List - Real API data
                        _buildTransactionsList(),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildTransactionsList() {
    final transactionsState = ref.watch(transactionsProvider);

    if (transactionsState.isInitialLoading) {
      return Column(
        children: List.generate(
          3,
          (index) => const SkeletonListItem(),
        ),
      );
    }

    if (transactionsState.message != null && !transactionsState.isDataAvailable) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48.sp,
                color: AppColors.error,
              ),
              SizedBox(height: 12.h),
              Text(
                transactionsState.message!,
                style: AppTexts.bodySmall(color: AppColors.grey600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (transactionsState.data == null || transactionsState.data!.isEmpty) {
      return _buildEmptyState();
    }

    // Show only first 5 transactions on wallet screen
    final recentTransactions = transactionsState.data!.take(5).toList();

    return Column(
      children: recentTransactions.map((transaction) {
        return TransactionCard(
          type: _getTransactionType(transaction.type),
          description: transaction.description,
          amount: '₦${transaction.amount.toStringAsFixed(2)}',
          date: _formatTransactionDate(transaction.createdAt),
          reference: transaction.reference,
          status: _getTransactionStatus(transaction.status),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Transaction details: ${transaction.reference ?? transaction.id}'),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Error Loading Wallet',
              style: AppTexts.h4(color: AppColors.error),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTexts.bodySmall(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                ref.read(walletProvider.notifier).fetchWallet();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64.sp,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No transactions yet',
            style: AppTexts.h4(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Your transaction history will appear here',
            style: AppTexts.bodySmall(color: AppColors.grey500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGuestView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 24.h),
            Text(
              'Sign in to access your wallet',
              style: AppTexts.h3(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Create an account or sign in to manage your wallet, view transactions, and make payments.',
              style: AppTexts.bodyMedium(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            
            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/signin');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Sign In',
                  style: AppTexts.buttonMedium(),
                ),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.go('/signup');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Create Account',
                  style: AppTexts.buttonMedium(color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageSkeleton() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Card Skeleton
          ShimmerWrapper(
            child: SkeletonBox(
              width: double.infinity,
              height: 180.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          SizedBox(height: 24.h),

          // Quick Actions Skeleton
          SkeletonLine(width: 120.w, height: 20.h),
          SizedBox(height: 12.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.3,
            children: List.generate(
              2,
              (index) => ShimmerWrapper(
                child: SkeletonBox(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // Transactions Title Skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLine(width: 150.w, height: 20.h),
              SkeletonLine(width: 60.w, height: 16.h),
            ],
          ),
          SizedBox(height: 12.h),

          // Transactions List Skeleton
          Column(
            children: List.generate(
              5,
              (index) => const SkeletonListItem(),
            ),
          ),
        ],
      ),
    );
  }
}
