import 'package:flutter/material.dart';
import 'package:tracker_app/models/lend_borrow_model.dart';

class LendBorrowViewModel extends ChangeNotifier {
  final List<LendBorrowModel> _lendBorrowListModel = [];

  List<LendBorrowModel> get records => List.unmodifiable(_lendBorrowListModel);

  
  List<LendBorrowModel> get sortedRecords {
    final list = List<LendBorrowModel>.from(_lendBorrowListModel);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  void addRecord({
    required String personName,
    required double amount,
    required String note,
    required DebtType type,
  }) {
    _lendBorrowListModel.add(
      LendBorrowModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        personName: personName.trim(),
        amount: amount,
        note: note.trim(),
        date: DateTime.now(),
        type: type,
      ),
    );
    notifyListeners();
  }

  void deleteRecord(String id) {
    _lendBorrowListModel.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  String formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";

  Color amountColor(DebtType type) =>
      type == DebtType.lend ? Colors.green : Colors.red;

  String amountText(LendBorrowModel r) {
    final sign = r.type == DebtType.lend ? "+" : "-";
    return "${sign}Rs ${r.amount.toStringAsFixed(0)}";
  }

 
  double totalLentTo(String person) {
    return _lendBorrowListModel
        .where((r) => r.personName == person && r.type == DebtType.lend)
        .fold(0.0, (sum, r) => sum + r.amount);
  }

  double totalBorrowedFrom(String person) {
    return _lendBorrowListModel
        .where((r) => r.personName == person && r.type == DebtType.borrow)
        .fold(0.0, (sum, r) => sum + r.amount);
  }

  double netFor(String person) => totalLentTo(person) - totalBorrowedFrom(person);

  List<String> get people {
    final set = <String>{};
    for (final r in _lendBorrowListModel) {
      set.add(r.personName);
    }
    return set.toList();
  }

  List<LendBorrowModel> get recentPeople {
  final list = sortedRecords;

  final seen = <String>{};
  final result = <LendBorrowModel>[];

  for (final r in list) {
    if (seen.add(r.personName)) {
      result.add(r);
    }
    if (result.length == 5) break;
  }
  return result;
}
}
