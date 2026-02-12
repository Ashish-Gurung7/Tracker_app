import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/models/lend_borrow_model.dart';
import 'package:tracker_app/services/pdf_service.dart';
import 'package:tracker_app/view_models/lend_borrow_view_model.dart';
import 'package:tracker_app/widgets/action_button.dart';
import 'package:tracker_app/widgets/lend_borrow_tile.dart';
import 'package:tracker_app/widgets/small_stat.dart';
import 'package:tracker_app/widgets/text_widgets.dart';

class LendBorrowPage extends StatelessWidget {
  const LendBorrowPage({super.key});

  void _showAddBottomSheet(BuildContext context, DebtType type) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();

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
                text: type == DebtType.lend ? "Add Lend" : "Add Borrow",
                color: Color(0xff111827),
                fontSized: 20,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Person Name",
                  hintText: "Enter name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              SizedBox(height: 16),
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
                controller: noteController,
                decoration: InputDecoration(
                  labelText: "Note (Optional)",
                  hintText: "Enter note",
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
                    String name = nameController.text.trim();
                    String amountText = amountController.text.trim();
                    String note = noteController.text.trim();

                    if (name.isEmpty) return;
                    double? amount = double.tryParse(amountText);
                    if (amount == null) return;

                    Provider.of<LendBorrowViewModel>(context, listen: false).addRecord(
                      personName: name,
                      amount: amount,
                      note: note,
                      type: type,
                    );

                    Navigator.pop(context);
                  },
                  child: Text("Add Record",
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
    final lendBorrowViewModel = Provider.of<LendBorrowViewModel>(context, listen: true);

    double totalLend = lendBorrowViewModel.totalLent;
    double totalBorrow = lendBorrowViewModel.totalBorrowed;
    double netBalance = lendBorrowViewModel.netBalance;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xffF6F7F9),
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 250,
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
                              text: "Lend & Borrow",
                              fontSized: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.file_download_outlined,
                                    color: Colors.white),
                                onPressed: () {
                                  PdfService.generateLendBorrowPdf(
                                      context, lendBorrowViewModel.records);
                                },
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
                                text: "Net Balance",
                                color: Colors.grey.shade500,
                                fontSized: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 8),
                              TextWidgets(
                                text: "Rs ${netBalance.toStringAsFixed(0)}",
                                color: Color(0xff111827),
                                fontSized: 30,
                                fontWeight: FontWeight.w800,
                              ),
                              SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SmallStat(
                                      label: "You Lent",
                                      value: "Rs ${totalLend.toStringAsFixed(0)}",
                                      icon: Icons.arrow_outward,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: SmallStat(
                                      label: "You Borrowed",
                                      value: "Rs ${totalBorrow.toStringAsFixed(0)}",
                                      icon: Icons.arrow_downward,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ActionButton(
                                    icon: Icons.upload,
                                    label: "Lend",
                                    onTap: () => _showAddBottomSheet(context, DebtType.lend),
                                  ),
                                  ActionButton(
                                    icon: Icons.download,
                                    label: "Borrow",
                                    onTap: () => _showAddBottomSheet(context, DebtType.borrow),
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

              SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Color(0xff2F7E79),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: "People Summary"),
                      Tab(text: "All Records"),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),

              Expanded(
                child: TabBarView(
                  children: [
                    lendBorrowViewModel.people.isEmpty
                        ? Center(child: Text("No data"))
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemCount: lendBorrowViewModel.people.length,
                            separatorBuilder: (context, index) => SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              String person = lendBorrowViewModel.people[index];
                              double lent = lendBorrowViewModel.totalLentTo(person);
                              double borrowed = lendBorrowViewModel.totalBorrowedFrom(person);
                              double personNet = lendBorrowViewModel.netFor(person);
                              bool isPositive = personNet >= 0;

                              return Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 46,
                                          width: 46,
                                          decoration: BoxDecoration(
                                            color: isPositive
                                                ? Colors.green.withOpacity(0.1)
                                                : Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Icon(Icons.person,
                                              color: isPositive ? Colors.green : Colors.red),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextWidgets(
                                                text: person,
                                                fontSized: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff111827),
                                              ),
                                              SizedBox(height: 4),
                                              TextWidgets(
                                                text: isPositive ? "Owes you" : "You owe",
                                                fontSized: 12,
                                                fontWeight: FontWeight.w500,
                                                color: isPositive ? Colors.green : Colors.red,
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextWidgets(
                                          text: "Rs ${personNet.abs().toStringAsFixed(0)}",
                                          fontSized: 16,
                                          fontWeight: FontWeight.w800,
                                          color: isPositive ? Colors.green : Colors.red,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidgets(
                                            text: "Given: Rs ${lent.toStringAsFixed(0)}",
                                            fontSized: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600,
                                          ),
                                          TextWidgets(
                                            text: "Borrowed: Rs ${borrowed.toStringAsFixed(0)}",
                                            fontSized: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),

                    lendBorrowViewModel.records.isEmpty
                        ? Center(child: Text("No records"))
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemCount: lendBorrowViewModel.records.length,
                            separatorBuilder: (context, index) => SizedBox(height: 0),
                            itemBuilder: (context, index) {
                              return LendBorrowTile(record: lendBorrowViewModel.records[index]);
                            },
                          ),
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
