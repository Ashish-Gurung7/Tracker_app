import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/models/transaction_model.dart';
import 'package:tracker_app/services/pdf_service.dart';
import 'package:tracker_app/view_models/transaction_view_model.dart';
import 'package:tracker_app/widgets/action_button.dart';
import 'package:tracker_app/widgets/text_widgets.dart';
import 'package:tracker_app/widgets/transaction_tile.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  void _showAddBottomSheet(BuildContext context, TransactionType type) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextWidgets(
                text: type == TransactionType.income ? "Add Income" : "Add Expense",
                color: Color(0xff111827),
                fontSized: 20,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  hintText: "Enter amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  hintText: "Enter description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff2F7E79),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    String amountText = amountController.text.trim();
                    String descText = descriptionController.text.trim();

                    double? amount = double.tryParse(amountText);
                    if (amount == null) return;

                    TransactionModel newTransaction = TransactionModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      amount: amount,
                      description: descText.isEmpty
                          ? (type == TransactionType.income ? "Income" : "Expense")
                          : descText,
                      date: DateTime.now(),
                      type: type,
                    );

                    Provider.of<TransactionViewModel>(context, listen: false)
                        .addTransaction(newTransaction);

                    Navigator.pop(context);
                  },
                  child: Text("Add Transaction",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionViewModel = Provider.of<TransactionViewModel>(context, listen: true);
    final transactionsList = transactionViewModel.walletTransactions;

    return Scaffold(
      backgroundColor: Color(0xffF6F7F9),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff429690),
                        Color(0xff2A7C76),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          TextWidgets(
                            text: "Wallet",
                            fontSized: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {
                                PdfService.generateTransactionPdf(context, transactionsList);
                              },
                              icon: Icon(Icons.file_download_outlined,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            TextWidgets(
                              text: "Total Balance",
                              color: Colors.grey.shade500,
                              fontSized: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 8),
                            TextWidgets(
                              text: "Rs ${transactionViewModel.balance.toStringAsFixed(0)}",
                              color: Color(0xff111827),
                              fontSized: 30,
                              fontWeight: FontWeight.w800,
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ActionButton(
                                  icon: Icons.add,
                                  label: "Add",
                                  onTap: () => _showAddBottomSheet(context, TransactionType.income),
                                ),
                                ActionButton(
                                  icon: Icons.remove,
                                  label: "Pay",
                                  onTap: () => _showAddBottomSheet(context, TransactionType.expense),
                                ),
                                ActionButton(
                                  icon: Icons.send_rounded,
                                  label: "Send",
                                  onTap: () => _showAddBottomSheet(context, TransactionType.expense),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidgets(
                      text: "Transactions",
                      color: Color(0xff111827),
                      fontSized: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: transactionsList.isEmpty
                          ? Center(child: Text("No transactions yet"))
                          : ListView.separated(
                              itemCount: transactionsList.length,
                              separatorBuilder: (context, index) => SizedBox(height: 0),
                              itemBuilder: (context, index) {
                                return TransactionTile(transaction: transactionsList[index]);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
