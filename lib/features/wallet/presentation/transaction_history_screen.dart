import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../controllers/re_useable/app_color.dart';
import '../../../controllers/re_useable/app_texts.dart';
import '../logic/transactions_notifier.dart';
import '../data/models/transaction_model.dart';
import 'widgets/transaction_card.dart';
import '../../../core/widgets/skeleton_loading.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch transactions on screen load
    Future.microtask(() => ref.read(transactionsProvider.notifier).fetchTransactions());
    
    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Load more when scrolled to 90%
      ref.read(transactionsProvider.notifier).loadMore();
    }
  }

  List<TransactionModel> get _filteredTransactions {
    final transactionsState = ref.watch(transactionsProvider);
    var transactions = transactionsState.data ?? [];

    // Apply filter
    if (_selectedFilter == 'Credit') {
      transactions = transactions.where((t) => t.isCredit).toList();
    } else if (_selectedFilter == 'Debit') {
      transactions = transactions.where((t) => t.isDebit).toList();
    }

    // Apply search
    if (_searchController.text.isNotEmpty) {
      transactions = transactions.where((t) {
        final searchTerm = _searchController.text.toLowerCase();
        return t.description.toLowerCase().contains(searchTerm) ||
            (t.reference?.toLowerCase().contains(searchTerm) ?? false);
      }).toList();
    }

    return transactions;
  }

  // Helper to convert API transaction type to UI enum
  TransactionType _getTransactionType(String apiType) {
    switch (apiType.toUpperCase()) {
      case 'DEPOSIT':
        return TransactionType.deposit;
      case 'WITHDRAWAL':
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
    switch (apiStatus.toUpperCase()) {
      case 'COMPLETED':
        return TransactionStatus.completed;
      case 'PENDING':
        return TransactionStatus.pending;
      case 'FAILED':
        return TransactionStatus.failed;
      case 'CANCELLED':
        return TransactionStatus.cancelled;
      default:
        return TransactionStatus.pending;
    }
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
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsState = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Transaction History', style: AppTexts.h2()),
      ),
      body: transactionsState.isInitialLoading
          ? ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: 8,
              itemBuilder: (context, index) => const SkeletonListItem(),
            )
          : transactionsState.message != null && !transactionsState.isDataAvailable
              ? _buildErrorState(transactionsState.message!)
              : Column(
                  children: [
                    // Search bar
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() {}),
                        style: AppTexts.bodyMedium(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search transactions...',
                          hintStyle: AppTexts.bodyMedium(color: AppColors.grey400),
                          prefixIcon: Icon(Icons.search, color: AppColors.grey400),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: AppColors.grey400),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: AppColors.grey100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),

                    // Filter chips
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          _buildFilterChip('All'),
                          SizedBox(width: 8.w),
                          _buildFilterChip('Credit'),
                          SizedBox(width: 8.w),
                          _buildFilterChip('Debit'),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Transaction list
                    Expanded(
                      child: _filteredTransactions.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: _filteredTransactions.length +
                                  (transactionsState.isPaginating ? 1 : 0),
                              itemBuilder: (context, index) {
                                // Show loading indicator at the end
                                if (index == _filteredTransactions.length) {
                                  return const SkeletonListItem();
                                }

                                final transaction = _filteredTransactions[index];
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
                                        content: Text(
                                            'Transaction details: ${transaction.reference ?? transaction.id}'),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.grey300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTexts.bodyMedium(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
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
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Error Loading Transactions',
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
                ref.read(transactionsProvider.notifier).fetchTransactions();
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
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16.h),
            Text(
              'No transactions found',
              style: AppTexts.h4(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Try adjusting your search or filters',
              style: AppTexts.bodySmall(color: AppColors.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
