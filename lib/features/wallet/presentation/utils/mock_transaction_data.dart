import '../widgets/transaction_card.dart';

class MockTransaction {
  final TransactionType type;
  final String description;
  final String amount;
  final String date;
  final String group;
  final String reference;
  final TransactionStatus status;

  const MockTransaction({
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    required this.group,
    required this.reference,
    this.status = TransactionStatus.completed,
  });
}

const List<MockTransaction> allMockTransactions = [
  MockTransaction(
    type: TransactionType.deposit,
    description: 'FUNDING',
    amount: '5008.00',
    date: 'Mar 2, 8:26 AM',
    group: 'Today',
    reference: 'PAY-WALLE...',
  ),
  MockTransaction(
    type: TransactionType.withdrawal,
    description: 'WITHDRAWAL',
    amount: '1500.00',
    date: 'Mar 1, 4:15 PM',
    group: 'Yesterday',
    reference: 'WD-BANK-...',
  ),
  MockTransaction(
    type: TransactionType.withdrawal,
    description: 'WITHDRAWAL',
    amount: '200.00',
    date: 'Feb 28, 9:30 AM',
    group: 'Yesterday',
    reference: 'WD-BANK-...',
  ),
  MockTransaction(
    type: TransactionType.transferOut,
    description: 'AD SLOT PURCHASE',
    amount: '45,000.00',
    date: 'Feb 27, 04:15 PM',
    group: 'Earlier',
    reference: 'REF-BW-928372',
  ),
  MockTransaction(
    type: TransactionType.refund,
    description: 'CAMPAIGN REFUND',
    amount: '2,500.00',
    date: 'Feb 26, 01:20 PM',
    group: 'Earlier',
    reference: 'REF-BW-928371',
  ),
  MockTransaction(
    type: TransactionType.deposit,
    description: 'CASH REWARDS',
    amount: '500.00',
    date: 'Feb 25, 09:10 AM',
    group: 'Earlier',
    reference: 'REF-BW-928370',
  ),
  MockTransaction(
    type: TransactionType.withdrawal,
    description: 'SERVER SUBSCRIPTION',
    amount: '15,200.00',
    date: 'Feb 24, 02:45 PM',
    group: 'Earlier',
    reference: 'REF-BW-928369',
  ),
  MockTransaction(
    type: TransactionType.transferIn,
    description: 'PARTNER COMMISSION',
    amount: '8,350.00',
    date: 'Feb 23, 11:30 AM',
    group: 'Earlier',
    reference: 'REF-BW-928368',
  ),
  MockTransaction(
    type: TransactionType.request,
    description: 'WALLET TOP-UP REQUEST',
    amount: '50,000.00',
    date: 'Feb 22, 09:00 AM',
    group: 'Earlier',
    reference: 'REF-BW-928367',
    status: TransactionStatus.pending,
  ),
  MockTransaction(
    type: TransactionType.deposit,
    description: 'PROJECT FUNDING',
    amount: '150,000.00',
    date: 'Feb 20, 03:20 PM',
    group: 'Earlier',
    reference: 'REF-BW-928366',
  ),
];
