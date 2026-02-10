import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/view_models/transaction_view_model.dart';
import 'package:tracker_app/models/transaction_model.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  void _showAddDialog(BuildContext context, TransactionType type) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    final title = type == TransactionType.income ? "Add Income" : "Add Expense";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration:  InputDecoration(hintText: "Amount"),
              ),
               SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration:  InputDecoration(hintText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final amountText = amountController.text.trim();
                final descText = descriptionController.text.trim();

                if (amountText.isEmpty) return;

                final amount = double.tryParse(amountText);
                if (amount == null) return;

                final tx = TransactionModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  amount: amount,
                  description: descText.isEmpty
                      ? (type == TransactionType.income ? "Income" : "Expense")
                      : descText,
                  date: DateTime.now(),
                  type: type,
                );

                Provider.of<TransactionViewModel>(context, listen: false)
                    .addTransaction(tx);

                Navigator.pop(context);
              },
              child:  Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context, listen: true);
    final list = vm.walletTransactions; // ✅ all transactions

    return Scaffold(
      appBar: AppBar(title: Text("Wallet")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _showAddDialog(context, TransactionType.income),
                    child:  Text("Add Income"),
                  ),
                ),
                 SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _showAddDialog(context, TransactionType.expense),
                    child:  Text("Add Expense"),
                  ),
                ),
              ],
            ),
             SizedBox(height: 20),

            Expanded(
              child: list.isEmpty
                  ?  Center(child: Text("No transactions yet"))
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final t = list[index];

                        return ListTile(
                          title: Text(t.description),
                          subtitle: Text(vm.formatDate(t.date)),
                          trailing: Text(
                            vm.amountText(t),
                            style: TextStyle(
                              color: vm.amountColor(t),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
