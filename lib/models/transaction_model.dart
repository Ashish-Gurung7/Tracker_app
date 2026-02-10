enum TransactionType{income, expense}

class TransactionModel {
    TransactionModel({
        required this.id,
        required this.amount,
        required this.description,
        required this.date,
        required this.type,
    });

    final String id;
    final double amount;
    final String description;
    final DateTime date;
    final TransactionType type;

    factory TransactionModel.fromJson(Map<String, dynamic> json){ 
        return TransactionModel(
            id: json["id"] as String,
            amount: (json["amount"] as num).toDouble(),
            description: (json["description"] as String?) ?? "",
            date: DateTime.parse(json["date"] as String),
            type: (json["type"] as String) == "income"? TransactionType.income: TransactionType.expense
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "description": description,
        "date": date.toIso8601String(),
        "type": type == TransactionType.income ? "income" : "expense",
    };

}
