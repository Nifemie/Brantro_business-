import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalanceCard extends StatefulWidget {
  final String balance;
  final String pendingBalance;
  final String currency;
  final String status;
  final double totalCredits;
  final double totalDebits;
  final int totalTransactions;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.pendingBalance,
    this.currency = '₦',
    this.status = 'ACTIVE',
    required this.totalCredits,
    required this.totalDebits,
    required this.totalTransactions,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;
  String get _currencySymbol => (widget.currency.trim() == 'NGN' || widget.currency.isEmpty) ? '₦' : widget.currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            // Card 1: Wallet Balance
            _buildWalletBalanceCard(isDark),
            SizedBox(width: 16.w),

            // Card 2: Total Credits
            _buildAnalyticsCard(
              title: 'Total Credits',
              amount: widget.totalCredits,
              subtitle: 'All time',
              backgroundColor: isDark ? const Color(0xFF1E2F23) : const Color(0xFFE2F6E9),
              primaryColor: const Color(0xFF2E7D32),
              iconContainerColor: isDark ? const Color(0xFF2E4E38) : const Color(0xFFC8E6C9),
              icon: Icons.arrow_downward_rounded,
            ),
            SizedBox(width: 16.w),

            // Card 3: Total Debits
            _buildAnalyticsCard(
              title: 'Total Debits',
              amount: widget.totalDebits,
              subtitle: 'All time',
              backgroundColor: isDark ? const Color(0xFF3B1E1E) : const Color(0xFFFDE8E8),
              primaryColor: const Color(0xFFC62828),
              iconContainerColor: isDark ? const Color(0xFF5E2E2E) : const Color(0xFFFFCDD2),
              icon: Icons.arrow_upward_rounded,
            ),
            SizedBox(width: 16.w),

            // Card 4: Total Transactions
            _buildAnalyticsCard(
              title: 'Total Transactions',
              amount: widget.totalTransactions.toDouble(),
              subtitle: 'All time',
              backgroundColor: isDark ? const Color(0xFF1C2E35) : const Color(0xFFE6F8F6),
              primaryColor: const Color(0xFF00796B),
              iconContainerColor: isDark ? const Color(0xFF2A484F) : const Color(0xFFB2DFDB),
              icon: Icons.notes_rounded,
              isInteger: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletBalanceCard(bool isDark) {
    return Container(
      width: 280.w,
      height: 145.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35), // Vibrant Orange/Coral matching the design
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // White rounded design element on the right
          Positioned(
            right: 0,
            top: 24.h,
            child: Container(
              width: 54.w,
              height: 54.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _isBalanceVisible = !_isBalanceVisible;
                    });
                  },
                  icon: Icon(
                    _isBalanceVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFFFF6B35),
                    size: 24.sp,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          // Main contents
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wallet Balance',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 60.w), // Avoid overlapping the visibility toggle
                child: Text(
                  _isBalanceVisible
                      ? '$_currencySymbol${_formatAmount(double.tryParse(widget.balance.replaceAll(',', '')) ?? 0.0)}'
                      : '$_currencySymbol ••••••',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required double amount,
    required String subtitle,
    required Color backgroundColor,
    required Color primaryColor,
    required Color iconContainerColor,
    required IconData icon,
    bool isInteger = false,
  }) {
    return Container(
      width: 280.w,
      height: 145.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isInteger
                      ? amount.toInt().toString()
                      : '$_currencySymbol${_formatAmount(amount)}',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

          // Icon Badge on the Right
          Container(
            width: 54.w,
            height: 54.h,
            decoration: BoxDecoration(
              color: iconContainerColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(
                icon,
                color: primaryColor,
                size: 26.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double value) {
    return value.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
