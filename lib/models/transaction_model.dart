// this enum is for choosing income or expense type
enum TransactionType { income, expense }

// this is the model class for a single transaction
class TransactionModel {
  // all the fields we need for a transaction
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionType type;

  // constructor - we need all fields when creating a transaction
  TransactionModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
  });

  // this function converts json data to our model
  // we use this when loading data from shared preferences
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json["id"] as String,
      amount: (json["amount"] as num).toDouble(),
      description: (json["description"] as String?) ?? "",
      date: DateTime.parse(json["date"] as String),
      type: (json["type"] as String) == "income"
          ? TransactionType.income
          : TransactionType.expense,
    );
  }

  // this converts our model back to json so we can save it
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "description": description,
      "date": date.toIso8601String(),
      "type": type == TransactionType.income ? "income" : "expense",
    };
  }
}
