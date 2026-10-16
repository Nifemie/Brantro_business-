import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../wallet/logic/wallet_notifier.dart';

class WalletBalanceCard extends ConsumerStatefulWidget {
  const WalletBalanceCard({super.key});

  @override
  ConsumerState<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends ConsumerState<WalletBalanceCard> {
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(walletProvider.notifier).fetchWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletState = ref.watch(walletProvider);
    final wallet = walletState.wallet;
    
    // Format balance with commas
    final rawBalance = double.tryParse(wallet?.balance.replaceAll(',', '') ?? '0') ?? 0.0;
    final formatter = NumberFormat('#,##0.00');
    final formattedBalance = formatter.format(rawBalance);
    
    final rawCurrency = wallet?.currency ?? '₦';
    final currency = (rawCurrency.trim() == 'NGN' || rawCurrency.isEmpty) ? '₦' : rawCurrency;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Available Balance',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
                icon: Icon(
                  _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.white.withOpacity(0.9),
                  size: 20.sp,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            _isBalanceVisible ? '$currency$formattedBalance' : '*****',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  context.push('/wallet/transactions');
                },
                child: Row(
                  children: [
                    Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 12.sp,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Wait, "Add Money" isn't a feature we explicitly defined, but we can point it to a coming soon snackbar or just leave it.
                  // For now, I'll point it to withdraw since usually this button is 'Fund' or 'Withdraw'
                  context.push('/wallet/withdraw');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward_rounded, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Withdraw',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
