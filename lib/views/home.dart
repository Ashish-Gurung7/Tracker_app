import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/view_models/transaction_view_model.dart';
import 'package:tracker_app/view_models/lend_borrow_view_model.dart';
import 'package:tracker_app/widgets/text_widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context, listen: true);
    final debtVm = Provider.of<LendBorrowViewModel>(context, listen: true);

    final list = vm.recent;
    final peopleList = debtVm.recentPeople;

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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     SizedBox(height: 40),
                    TextWidgets(
                      text: "Total Balance",
                      fontSized: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    TextWidgets(
                      text: "Rs ${vm.balance.toStringAsFixed(0)}",
                      fontSized: 18,
                      fontWeight: FontWeight.w700,
                    ),
                     SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidgets(
                              text: "Income",
                              fontSized: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            TextWidgets(
                              text: "Rs ${vm.totalIncome.toStringAsFixed(0)}",
                              fontSized: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidgets(
                              text: "Expense",
                              fontSized: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            TextWidgets(
                              text: "Rs ${vm.totalExpense.toStringAsFixed(0)}",
                              fontSized: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidgets(
                  text: "Transaction History",
                  color: Colors.black,
                  fontSized: 20,
                  fontWeight: FontWeight.bold,
                ),
                TextWidgets(
                  text: "See All",
                  color: Colors.grey,
                  fontSized: 20,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
             SizedBox(height: 10),

            SizedBox(
              height: 170,
              child: list.isEmpty
                  ? Center(
                      child: TextWidgets(
                        text: "No transactions yet",
                        color: Colors.grey,
                        fontSized: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final t = list[index];
                        return Padding(
                          padding:  EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidgets(
                                    text: t.description,
                                    color: Colors.black,
                                    fontSized: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  TextWidgets(
                                    text: vm.formatDate(t.date),
                                    color: Colors.grey,
                                    fontSized: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              TextWidgets(
                                text: vm.amountText(t),
                                color: vm.amountColor(t),
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidgets(
                  text: "Loan  transaction",
                  color: Colors.black,
                  fontSized: 20,
                  fontWeight: FontWeight.bold,
                ),
                TextWidgets(
                  text: "See All",
                  color: Colors.grey,
                  fontSized: 20,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            Expanded(
              child: peopleList.isEmpty
                  ? Center(child: Text("No lend/borrow yet"))
                  : ListView.builder(
                      itemCount: peopleList.length,
                      itemBuilder: (context, index) {
                        final r = peopleList[index];
                        return Padding(
                          padding:  EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidgets(
                                    text: r.personName,

                                    color: Colors.black,
                                    fontSized: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  TextWidgets(
                                    text: debtVm.formatDate(r.date),

                                    fontSized: 12,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              TextWidgets(
                                text: debtVm.amountText(r),

                                color: debtVm.amountColor(r.type),
                                fontWeight: FontWeight.w600,
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
