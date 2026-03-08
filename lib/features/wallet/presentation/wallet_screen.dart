import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../../../core/service/session_service.dart';
import '../logic/wallet_notifier.dart';
import '../logic/transactions_notifier.dart';
import 'widgets/balance_card.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/recent_transactions_list.dart';
import 'widgets/wallet_skeleton.dart';
import 'widgets/wallet_guest_view.dart';
import '../../dashboard/presentation/widgets/dashboard_app_bar.dart';
import '../../dashboard/presentation/widgets/sidebar_menu.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final walletState = ref.watch(walletProvider);
    final wallet = walletState.wallet;

    // Show loading while checking login status
    if (_isLoading) {
      return const WalletSkeleton();
    }

    // Show guest view if not logged in
    if (_isGuest) {
      return const WalletGuestView();
    }

    // Logged in user view
    if (walletState.isLoading && wallet == null) {
      return const WalletSkeleton();
    }

    if (walletState.errorMessage != null && wallet == null) {
      return _buildErrorState(walletState.errorMessage!);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const SidebarMenu(),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardAppBar(title: 'WALLET', showBackButton: false),
            Expanded(
              child: RefreshIndicator(
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
                      Text(
                        'Quick Actions',
                        style: AppTexts.h3(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const QuickActionsGrid(),

                      SizedBox(height: 32.h),

                      // Recent Transactions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: AppTexts.h3(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push('/wallet/transactions');
                            },
                            child: Text(
                              'View All',
                              style: AppTexts.bodyMedium(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // Transaction List - Real API data
                      const RecentTransactionsList(),

                      SizedBox(height: 24.h),
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

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
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
}
