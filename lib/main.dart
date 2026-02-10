import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/view_models/lend_borrow_view_model.dart';
import 'package:tracker_app/view_models/transaction_view_model.dart';

import 'package:tracker_app/widgets/bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=> TransactionViewModel()),
          ChangeNotifierProvider(create: (_)=> LendBorrowViewModel())
        ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: BottomNavbar(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
