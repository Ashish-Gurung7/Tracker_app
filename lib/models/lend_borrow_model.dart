enum DebtType { lend, borrow }

class LendBorrowModel {
  final String id;
  final String personName;
  final double amount;
  final String note;
  final DateTime date;
  final DebtType type;

  LendBorrowModel({
    required this.id,
    required this.personName,
    required this.amount,
    required this.note,
    required this.date,
    required this.type,
  });
}
