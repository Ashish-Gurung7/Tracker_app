import 'package:flutter/material.dart';
import 'package:tracker_app/widgets/text_widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff2F7E79),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    TextWidgets(text: "Total Balance"),
                    TextWidgets(text: "Rs 123123"),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextWidgets(text: "Income"),
                            TextWidgets(text: "Rs 23"),
                          ],
                        ),
                        Column(
                          children: [
                            TextWidgets(text: "Expense"),
                            TextWidgets(text: "Rs 13"),
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
                TextWidgets(text: "see all", color: Colors.grey),
              ],
            ),
        
            ListView.builder(
              shrinkWrap: true,
              itemCount: transaction_dummy.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(transaction_dummy[index]["name"]),
                        Text(transaction_dummy[index]["amount"]),
                      ],
                    )
                ]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

List transaction_dummy = [
  {"name": "Food", 'amount': "+Rs123"},
  {"name": "SIDE", 'amount': "+Rs1223"},
  {"name": "watch", 'amount': "+Rs3123"},
  {"name": "transfer", 'amount': "+Rs3123"},
  {"name": "Youtube", 'amount': "+Rs3123"},
  {"name": "salary", 'amount': "+Rs23123"},
];
