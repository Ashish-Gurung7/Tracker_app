import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/models/lend_borrow_model.dart';
import 'package:tracker_app/view_models/lend_borrow_view_model.dart';

class LendBorrowPage extends StatelessWidget {
  const LendBorrowPage({super.key});

  void _showAddDialog(BuildContext context, DebtType type) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    final title = type == DebtType.lend ? "Add Lend" : "Add Borrow";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:  InputDecoration(hintText: "Person name"),
              ),
               SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Amount"),
              ),
               SizedBox(height: 10),
              TextField(
                controller: noteController,
                decoration:  InputDecoration(hintText: "Note (optional)"),
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
                final name = nameController.text.trim();
                final amountText = amountController.text.trim();
                final note = noteController.text.trim();

                if (name.isEmpty) return;
                final amount = double.tryParse(amountText);
                if (amount == null) return;

                Provider.of<LendBorrowViewModel>(context, listen: false).addRecord(
                  personName: name,
                  amount: amount,
                  note: note,
                  type: type,
                );

                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LendBorrowViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title:  Text("Loan transaction"), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
           

         
            if (vm.people.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      "People Summary",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                     SizedBox(height: 8),
                    ...vm.people.map((p) {
                      final lent = vm.totalLentTo(p);
                      final borrowed = vm.totalBorrowedFrom(p);
                      final net = vm.netFor(p);

                      return Card(
                        child: ListTile(
                          title: Text(p),
                          subtitle: Text(
                            "Given: Rs ${lent.toStringAsFixed(0)}  |  Borrowed: Rs ${borrowed.toStringAsFixed(0)}",
                          ),
                          trailing: Text(
                            "Net: Rs ${net.toStringAsFixed(0)}",
                            style: TextStyle(
                              color: net >= 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 16),
                    Text(
                      "All Records",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                     SizedBox(height: 8),

                    ...vm.sortedRecords.map((r) {
                      return ListTile(
                        title: Text("${r.personName}  ${r.note.isEmpty ? '' : r.note}"),
                        subtitle: Text(vm.formatDate(r.date)),
                        trailing: Text(
                          vm.amountText(r),
                          style: TextStyle(
                            color: vm.amountColor(r.type),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onLongPress: () {
                         
                          Provider.of<LendBorrowViewModel>(context, listen: false)
                              .deleteRecord(r.id);
                        },
                      );
                    }).toList(),
                  ],
                ),
              )
            else
              Expanded(
                child: Center(child: Text("No lend/borrow records yet")),
              ),
                SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showAddDialog(context, DebtType.lend),
                    child:  Text("Lend "),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showAddDialog(context, DebtType.borrow),
                    child:  Text("Borrow"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
