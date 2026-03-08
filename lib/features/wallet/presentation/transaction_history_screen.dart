import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'widgets/transaction_card.dart';
import 'widgets/transaction_search_bar.dart';
import 'widgets/transaction_filter_chips.dart';
import 'utils/mock_transaction_data.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  List<MockTransaction> get _filteredTransactions {
    return allMockTransactions.where((tx) {
      // Filter by chip
      bool matchFilter = true;
      if (_selectedFilter == 'Credit') {
        matchFilter =
            tx.type == TransactionType.deposit ||
            tx.type == TransactionType.transferIn ||
            tx.type == TransactionType.refund;
      } else if (_selectedFilter == 'Debit') {
        matchFilter =
            tx.type == TransactionType.withdrawal ||
            tx.type == TransactionType.transferOut;
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

  Map<String, List<MockTransaction>> get _groupedTransactions {
    final grouped = <String, List<MockTransaction>>{};
    for (var tx in _filteredTransactions) {
      grouped.putIfAbsent(tx.group, () => []).add(tx);
    }
    return grouped;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groupedData = _groupedTransactions;
    final groups = groupedData.keys.toList();

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
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.05),
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
                            ? Colors.white.withOpacity(0.08)
                            : Colors.black.withOpacity(0.05),
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
          Expanded(
            child: groups.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
                    physics: const BouncingScrollPhysics(),
                    itemCount: groups.length,
                    itemBuilder: (context, gIndex) {
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
                            (tx) => TransactionCard(
                              type: tx.type,
                              description: tx.description,
                              amount: tx.amount,
                              date: tx.date,
                              reference: tx.reference,
                              status: tx.status,
                              onTap: () {},
                            ),
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
