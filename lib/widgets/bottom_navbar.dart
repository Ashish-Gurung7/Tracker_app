import 'package:flutter/material.dart';
import 'package:tracker_app/views/home.dart';
import 'package:tracker_app/views/profile.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentIndex = 0;
  final List<Widget> _screens = [Home(), Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Image.asset("assets/icons/home.png"), label: "home"),
            BottomNavigationBarItem(icon: Image.asset("assets/icons/home.png"), label: "profile")

          ]),
      ),
    );
  }
}
