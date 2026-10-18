import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../logic/transactions_notifier.dart';
import 'transaction_card.dart';

class RecentTransactionsList extends ConsumerWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsState = ref.watch(transactionsProvider);

    if (transactionsState.isInitialLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: const CircularProgressIndicator(),
        ),
      );
    }

    if (transactionsState.message != null && !transactionsState.isDataAvailable) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Text(
            'Failed to load transactions: ${transactionsState.message}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 14.sp),
          ),
        ),
      );
    }

    final displayItems = (transactionsState.data ?? []).take(5).toList();

    if (displayItems.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Text(
            'No recent transactions.',
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ),
      );
    }

    return Column(
      children: displayItems.map((tx) {
        // Map string type to TransactionType enum
        TransactionType mappedType = TransactionType.deposit;
        if (tx.isDebit) mappedType = TransactionType.withdrawal;
        
        TransactionStatus mappedStatus = TransactionStatus.completed;
        if (tx.isPending) {
          mappedStatus = TransactionStatus.pending;
        } else if (tx.isFailed) {
          mappedStatus = TransactionStatus.failed;
        }

        final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(tx.createdAt);

        return TransactionCard(
          type: mappedType,
          description: tx.description,
          amount: '₦${NumberFormat('#,##0.00').format(tx.amount)}',
          date: formattedDate,
          reference: tx.reference,
          status: mappedStatus,
          onTap: () {
            context.push('/wallet/transaction-receipt', extra: {'transaction': tx});
          },
        );
      }).toList(),
    );
  }
}
