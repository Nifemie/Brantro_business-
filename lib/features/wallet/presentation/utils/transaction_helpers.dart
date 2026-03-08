import 'package:intl/intl.dart';
import '../widgets/transaction_card.dart';

class TransactionHelpers {
  static TransactionType getTransactionType(String apiType) {
    switch (apiType.toUpperCase()) {
      case 'DEPOSIT':
      case 'CREDIT':
      case 'UPDATE':
        return TransactionType.deposit;
      case 'WITHDRAWAL':
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

  static TransactionStatus getTransactionStatus(String apiStatus) {
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

  static String formatTransactionDate(DateTime date) {
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
}
