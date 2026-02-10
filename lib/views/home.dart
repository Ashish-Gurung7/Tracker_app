import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/view_models/transaction_view_model.dart';

import 'package:tracker_app/widgets/text_widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context, listen: true);
    final list = vm.recent; 

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
             SizedBox(height: 30),

       
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color:  Color(0xff2F7E79),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    TextWidgets(text: "Total Balance"),
                    TextWidgets(text: "Rs ${vm.balance.toStringAsFixed(0)}"),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextWidgets(text: "Income"),
                            TextWidgets(
                                text: "Rs ${vm.totalIncome.toStringAsFixed(0)}"),
                          ],
                        ),
                        Column(
                          children: [
                            TextWidgets(text: "Expense"),
                            TextWidgets(
                                text:
                                    "Rs ${vm.totalExpense.toStringAsFixed(0)}"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidgets(text: "Transaction History", color: Colors.black),
                TextWidgets(text: "Recent 5", color: Colors.grey),
              ],
            ),

             SizedBox(height: 10),

          
            Expanded(
              child: list.isEmpty
                  ? Center(child: Text("No transactions yet"))
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final t = list[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.description),
                                  Text(
                                    vm.formatDate(t.date),
                                    style:  TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                vm.amountText(t),
                                style: TextStyle(
                                  color: vm.amountColor(t),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
