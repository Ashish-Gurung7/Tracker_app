import 'package:flutter/material.dart';
import 'package:tracker_app/models/transaction_model.dart';

class TransactionViewModel extends ChangeNotifier {
  final List<TransactionModel> _transactionListModel = [];

  // All transactions (read-only)
  List<TransactionModel> get transactions =>
      List.unmodifiable(_transactionListModel);

  // Income / Expense lists
  List<TransactionModel> get incomes => _transactionListModel
      .where((t) => t.type == TransactionType.income)
      .toList();

  List<TransactionModel> get expenses => _transactionListModel
      .where((t) => t.type == TransactionType.expense)
      .toList();

  // Totals
  double get totalIncome => _transactionListModel
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactionListModel
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  // Sorted list (newest first) - used by both home and wallet
  List<TransactionModel> get sortedTransactions {
    final list = List<TransactionModel>.from(_transactionListModel);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  // Home: recent 5 (newest first)
  List<TransactionModel> get recent => sortedTransactions.take(5).toList();

  // Wallet: all (newest first)
  List<TransactionModel> get walletTransactions => sortedTransactions;

  // UI helpers
  String formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";

  String amountText(TransactionModel t) {
    final sign = t.type == TransactionType.income ? "+" : "-";
    return "${sign}Rs ${t.amount.toStringAsFixed(0)}"; // ✅ fixed here
  }

  Color amountColor(TransactionModel t) {
    return t.type == TransactionType.income ? Colors.green : Colors.red;
  }

  // Actions
  void addTransaction(TransactionModel transaction) {
    _transactionListModel.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactionListModel.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void clearAll() {
    _transactionListModel.clear();
    notifyListeners();
  }

  // Optional: update/edit support
  void updateTransaction(TransactionModel updated) {
    final index = _transactionListModel.indexWhere((t) => t.id == updated.id);
    if (index == -1) return;
    _transactionListModel[index] = updated;
    notifyListeners();
  }
}
