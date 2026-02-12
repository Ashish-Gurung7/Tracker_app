import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker_app/view_models/lend_borrow_view_model.dart';
import 'package:tracker_app/view_models/transaction_view_model.dart';

import 'package:tracker_app/widgets/bottom_navbar.dart';

// this is the main function that runs our app
void main() {
  runApp(MyApp());
}

// MyApp is the root widget of our application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // we are using MultiProvider so we can use multiple providers
    return MultiProvider(
        providers: [
          // provider for transaction data
          ChangeNotifierProvider(create: (_) => TransactionViewModel()),
          // provider for lend borrow data
          ChangeNotifierProvider(create: (_) => LendBorrowViewModel())
        ],
      child: MaterialApp(
        title: 'Tracker App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: BottomNavbar(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
