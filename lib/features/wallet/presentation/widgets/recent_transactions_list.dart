import 'package:flutter/material.dart';
import 'transaction_card.dart';
import '../utils/mock_transaction_data.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Show top 5 entries from central mock data
    final displayItems = allMockTransactions.take(5).toList();

    return Column(
      children: displayItems
          .map(
            (tx) => TransactionCard(
              type: tx.type,
              description: tx.description,
              amount: tx.amount,
              date: tx.date,
              reference: tx.reference,
              status: tx.status,
            ),
          )
          .toList(),
    );
  }
}
