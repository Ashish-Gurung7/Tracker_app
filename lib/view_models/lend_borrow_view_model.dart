import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker_app/models/lend_borrow_model.dart';

// view model for managing lend and borrow records
class LendBorrowViewModel extends ChangeNotifier {
  // list to store all lend/borrow records
  List<LendBorrowModel> _recordsList = [];

  // key for saving in shared preferences
  String _storageKey = 'lend_borrow_records';

  // load records when this viewmodel is created
  LendBorrowViewModel() {
    loadRecords();
  }

  // getter to get all records
  List<LendBorrowModel> get records {
    return List.unmodifiable(_recordsList);
  }

  // get records sorted by date (newest first)
  List<LendBorrowModel> get sortedRecords {
    List<LendBorrowModel> sorted = List.from(_recordsList);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  // load saved records from shared preferences
  Future<void> loadRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_storageKey);
    if (data != null) {
      List<dynamic> decodedData = jsonDecode(data);
      _recordsList.clear();
      // loop through each item and convert from json
      for (var item in decodedData) {
        _recordsList.add(LendBorrowModel.fromJson(item));
      }
      notifyListeners();
    }
  }

  // save records to shared preferences
  Future<void> _saveRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = [];
    for (var record in _recordsList) {
      jsonList.add(record.toJson());
    }
    String encodedData = jsonEncode(jsonList);
    await prefs.setString(_storageKey, encodedData);
  }

  // add a new lend or borrow record
  void addRecord({
    required String personName,
    required double amount,
    required String note,
    required DebtType type,
  }) {
    // create a new record with current timestamp as id
    LendBorrowModel newRecord = LendBorrowModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      personName: personName.trim(),
      amount: amount,
      note: note.trim(),
      date: DateTime.now(),
      type: type,
    );
    _recordsList.add(newRecord);
    _saveRecords();
    notifyListeners();
  }

  // delete a record by its id
  void deleteRecord(String id) {
    _recordsList.removeWhere((record) => record.id == id);
    _saveRecords();
    notifyListeners();
  }

  // format date to a readable string
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // return green color for lend and red for borrow
  Color amountColor(DebtType type) {
    if (type == DebtType.lend) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  // get the amount text with + or - sign
  String amountText(LendBorrowModel record) {
    if (record.type == DebtType.lend) {
      return "+Rs ${record.amount.toStringAsFixed(0)}";
    } else {
      return "-Rs ${record.amount.toStringAsFixed(0)}";
    }
  }

  // calculate total amount that we lent to others
  double get totalLent {
    double total = 0;
    for (var record in _recordsList) {
      if (record.type == DebtType.lend) {
        total = total + record.amount;
      }
    }
    return total;
  }

  // calculate total amount borrowed from others
  double get totalBorrowed {
    double total = 0;
    for (var record in _recordsList) {
      if (record.type == DebtType.borrow) {
        total = total + record.amount;
      }
    }
    return total;
  }

  // net balance = what we lent - what we borrowed
  double get netBalance {
    return totalLent - totalBorrowed;
  }

  // how much we lent to a specific person
  double totalLentTo(String person) {
    double total = 0;
    for (var record in _recordsList) {
      if (record.personName == person && record.type == DebtType.lend) {
        total = total + record.amount;
      }
    }
    return total;
  }

  // how much we borrowed from a specific person
  double totalBorrowedFrom(String person) {
    double total = 0;
    for (var record in _recordsList) {
      if (record.personName == person && record.type == DebtType.borrow) {
        total = total + record.amount;
      }
    }
    return total;
  }

  // net amount for a specific person
  double netFor(String person) {
    return totalLentTo(person) - totalBorrowedFrom(person);
  }

  // get list of all unique person names
  List<String> get people {
    List<String> personNames = [];
    for (var record in _recordsList) {
      // only add if not already in list
      if (!personNames.contains(record.personName)) {
        personNames.add(record.personName);
      }
    }
    return personNames;
  }

  // get most recent people (up to 5) for home page
  List<LendBorrowModel> get recentPeople {
    List<LendBorrowModel> sorted = sortedRecords;
    List<String> seenNames = [];
    List<LendBorrowModel> result = [];

    for (var record in sorted) {
      // check if we already added this person
      if (!seenNames.contains(record.personName)) {
        seenNames.add(record.personName);
        result.add(record);
      }
      // stop at 5 people
      if (result.length == 5) {
        break;
      }
    }
    return result;
  }
}
