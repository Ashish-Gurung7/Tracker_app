// enum for lend or borrow type
enum DebtType { lend, borrow }

// model class for lend/borrow record
class LendBorrowModel {
  final String id;
  final String personName;
  final double amount;
  final String note;
  final DateTime date;
  final DebtType type;

  // constructor with required fields
  LendBorrowModel({
    required this.id,
    required this.personName,
    required this.amount,
    required this.note,
    required this.date,
    required this.type,
  });

  // convert from json map to model object
  factory LendBorrowModel.fromJson(Map<String, dynamic> json) {
    return LendBorrowModel(
      id: json["id"] as String,
      personName: json["personName"] as String,
      amount: (json["amount"] as num).toDouble(),
      note: (json["note"] as String?) ?? "",
      date: DateTime.parse(json["date"] as String),
      type: (json["type"] as String) == "lend" ? DebtType.lend : DebtType.borrow,
    );
  }

  // convert model to json map for saving
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "personName": personName,
      "amount": amount,
      "note": note,
      "date": date.toIso8601String(),
      "type": type == DebtType.lend ? "lend" : "borrow",
    };
  }
}
