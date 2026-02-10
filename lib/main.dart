import 'package:flutter/material.dart';
import 'package:tracker_app/views/home.dart';
import 'package:tracker_app/widgets/bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BottomNavbar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
