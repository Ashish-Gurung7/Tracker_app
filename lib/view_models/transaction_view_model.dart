import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_app/models/transaction_model.dart';

// this is our view model for transactions
// it manages all the transaction data and notifies the UI when data changes
class TransactionViewModel extends ChangeNotifier {
  // list to store all our transactions
  List<TransactionModel> _transactionList = [];

  // key we use to save data in shared preferences
  String _storageKey = 'transaction_records';

  // constructor - loads saved transactions when created
  TransactionViewModel() {
    loadTransactions();
  }

  // getter to get all transactions (returns a copy so UI cant modify directly)
  List<TransactionModel> get transactions {
    return List.unmodifiable(_transactionList);
  }

  // get only income transactions
  List<TransactionModel> get incomes {
    List<TransactionModel> incomeList = [];
    for (var transaction in _transactionList) {
      if (transaction.type == TransactionType.income) {
        incomeList.add(transaction);
      }
    }
    return incomeList;
  }

  // get only expense transactions
  List<TransactionModel> get expenses {
    List<TransactionModel> expenseList = [];
    for (var transaction in _transactionList) {
      if (transaction.type == TransactionType.expense) {
        expenseList.add(transaction);
      }
    }
    return expenseList;
  }

  // calculate total income amount
  double get totalIncome {
    double total = 0;
    for (var transaction in _transactionList) {
      if (transaction.type == TransactionType.income) {
        total = total + transaction.amount;
      }
    }
    return total;
  }

  // calculate total expense amount
  double get totalExpense {
    double total = 0;
    for (var transaction in _transactionList) {
      if (transaction.type == TransactionType.expense) {
        total = total + transaction.amount;
      }
    }
    return total;
  }

  // balance = income - expense
  double get balance {
    return totalIncome - totalExpense;
  }

  // get transactions sorted by newest first
  List<TransactionModel> get sortedTransactions {
    List<TransactionModel> sortedList = List.from(_transactionList);
    sortedList.sort((a, b) => b.date.compareTo(a.date));
    return sortedList;
  }

  // get the 5 most recent transactions for home page
  List<TransactionModel> get recent {
    List<TransactionModel> sorted = sortedTransactions;
    if (sorted.length > 5) {
      return sorted.sublist(0, 5);
    }
    return sorted;
  }

  // get all transactions for wallet page (just sorted)
  List<TransactionModel> get walletTransactions {
    return sortedTransactions;
  }

  // greeting message based on time of day
  String get greeting {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  // format date to simple string like "12/1/2026"
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // get amount text with + or - sign
  String amountText(TransactionModel transaction) {
    if (transaction.type == TransactionType.income) {
      return "+Rs ${transaction.amount.toStringAsFixed(0)}";
    } else {
      return "-Rs ${transaction.amount.toStringAsFixed(0)}";
    }
  }

  // get color based on transaction type (green for income, red for expense)
  Color amountColor(TransactionModel transaction) {
    if (transaction.type == TransactionType.income) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  // load all saved transactions from shared preferences
  Future<void> loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_storageKey);
    if (data != null) {
      List<dynamic> decodedData = jsonDecode(data);
      _transactionList.clear();
      for (var item in decodedData) {
        _transactionList.add(TransactionModel.fromJson(item));
      }
      notifyListeners();
    }
  }

  // save all transactions to shared preferences
  Future<void> _saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = [];
    for (var transaction in _transactionList) {
      jsonList.add(transaction.toJson());
    }
    String encodedData = jsonEncode(jsonList);
    await prefs.setString(_storageKey, encodedData);
  }

  // add a new transaction and save
  void addTransaction(TransactionModel transaction) {
    _transactionList.add(transaction);
    _saveTransactions();
    notifyListeners();
  }
}
