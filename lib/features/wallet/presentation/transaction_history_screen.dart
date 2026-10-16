import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'widgets/transaction_card.dart';
import 'widgets/transaction_search_bar.dart';
import 'widgets/transaction_filter_chips.dart';
import '../logic/transactions_notifier.dart';
import '../data/models/transaction_model.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends ConsumerState<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(transactionsProvider.notifier).loadMore();
    }
  }

  String _getGroup(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final txDate = DateTime(date.year, date.month, date.day);

    if (txDate == today) return 'Today';
    if (txDate == yesterday) return 'Yesterday';
    return DateFormat('MMMM yyyy').format(date);
  }

  List<TransactionModel> get _filteredTransactions {
    final transactionsState = ref.watch(transactionsProvider);
    final data = transactionsState.data ?? [];
    
    return data.where((tx) {
      // Filter by chip
      bool matchFilter = true;
      if (_selectedFilter == 'Credit') {
        matchFilter = tx.isCredit;
      } else if (_selectedFilter == 'Debit') {
        matchFilter = tx.isDebit;
      }

      // Filter by search text
      bool matchSearch = true;
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        matchSearch =
            tx.description.toLowerCase().contains(query) ||
            tx.reference.toLowerCase().contains(query);
      }

      return matchFilter && matchSearch;
    }).toList();
  }

  Map<String, List<TransactionModel>> get _groupedTransactions {
    final grouped = <String, List<TransactionModel>>{};
    for (var tx in _filteredTransactions) {
      grouped.putIfAbsent(_getGroup(tx.createdAt), () => []).add(tx);
    }
    return grouped;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groupedData = _groupedTransactions;
    final groups = groupedData.keys.toList();
    final transactionsState = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1E2329)
          : const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          child: SafeArea(
            bottom: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2F35) : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.sp,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'TRANSACTIONS',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Column(
              children: [
                TransactionSearchBar(
                  controller: _searchController,
                  onChanged: () => setState(() {}),
                ),
                TransactionFilterChips(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (filter) =>
                      setState(() => _selectedFilter = filter),
                ),
              ],
            ),
          ),
          if (transactionsState.isInitialLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (groups.isEmpty)
            Expanded(child: _buildEmptyState())
          else
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
                physics: const BouncingScrollPhysics(),
                itemCount: groups.length + (transactionsState.isPaginating ? 1 : 0),
                itemBuilder: (context, gIndex) {
                  if (gIndex == groups.length) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.h),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }

                  final groupName = groups[gIndex];
                  final items = groupedData[groupName]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          groupName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.grey[500]
                                : Colors.grey[600],
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      ...items.map(
                        (tx) {
                          TransactionType mappedType = TransactionType.deposit;
                          if (tx.isDebit) mappedType = TransactionType.withdrawal;
                          
                          final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(tx.createdAt);

                          return TransactionCard(
                            type: mappedType,
                            description: tx.description,
                            amount: '₦${NumberFormat('#,##0.00').format(tx.amount)}',
                            date: formattedDate,
                            reference: tx.reference,
                            status: TransactionStatus.completed,
                            onTap: () {
                              context.push('/wallet/transaction-receipt', extra: {'transaction': tx});
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[500],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
