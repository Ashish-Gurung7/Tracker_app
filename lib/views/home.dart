import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/view_models/transaction_view_model.dart';
import 'package:tracker_app/view_models/lend_borrow_view_model.dart';
import 'package:tracker_app/widgets/lend_borrow_tile.dart';
import 'package:tracker_app/widgets/mini_stat.dart';
import 'package:tracker_app/widgets/text_widgets.dart';
import 'package:tracker_app/widgets/transaction_tile.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionViewModel = Provider.of<TransactionViewModel>(context, listen: true);
    final lendBorrowViewModel = Provider.of<LendBorrowViewModel>(context, listen: true);

    List recentTransactions = transactionViewModel.recent;
    List recentPeople = lendBorrowViewModel.recentPeople;

    return Scaffold(
      backgroundColor: Color(0xffF6F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff429690),
                          Color(0xff2A7C76),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: TextWidgets(
                            text: transactionViewModel.greeting,
                            color: Colors.white,
                            fontSized: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 40),

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidgets(
                                    text: "Total Balance",
                                    color: Colors.grey.shade500,
                                    fontSized: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Icon(Icons.more_horiz, color: Colors.grey.shade400),
                                ],
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: MiniStat(
                                      icon: Icons.arrow_downward,
                                      label: "Income",
                                      value: "Rs ${transactionViewModel.totalIncome.toStringAsFixed(0)}",
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: MiniStat(
                                      icon: Icons.arrow_upward,
                                      label: "Expenses",
                                      value: "Rs ${transactionViewModel.totalExpense.toStringAsFixed(0)}",
                                      color: Colors.red,
                                    ),
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

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidgets(
                          text: "Transactions History",
                          color: Color(0xff111827),
                          fontSized: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        TextWidgets(
                          text: "See all",
                          color: Color(0xff6B7280),
                          fontSized: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    recentTransactions.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("No transactions yet"),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: recentTransactions.length,
                            separatorBuilder: (context, index) => SizedBox(height: 0),
                            itemBuilder: (context, index) {
                              return TransactionTile(transaction: recentTransactions[index]);
                            },
                          ),

                    SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidgets(
                          text: "Lend / Borrow",
                          color: Color(0xff111827),
                          fontSized: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        TextWidgets(
                          text: "See all",
                          color: Color(0xff6B7280),
                          fontSized: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    recentPeople.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("No lend/borrow records yet"),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: recentPeople.length,
                            separatorBuilder: (context, index) => SizedBox(height: 0),
                            itemBuilder: (context, index) {
                              return LendBorrowTile(record: recentPeople[index]);
                            },
                          ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
