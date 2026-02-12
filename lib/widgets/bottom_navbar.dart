import 'package:flutter/material.dart';
import 'package:tracker_app/views/home.dart';
import 'package:tracker_app/views/lend_borrow.dart';
import 'package:tracker_app/views/wallet.dart';

// this is the bottom navigation bar widget
// it lets user switch between Home, Wallet and LendBorrow pages
class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  // this keeps track of which tab is currently selected
  int _currentIndex = 0;

  // list of all our pages/screens
  final List<Widget> _screens = [
    Home(),
    Wallet(),
    LendBorrowPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // show the page based on current index
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        // remove the splash/ripple effect on tap
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          // when user taps a tab, update the index
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            // home tab
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/icons/home.png"),
                color: _currentIndex == 0 ? Color(0xff2F7E79) : Colors.grey,
              ),
              label: "home",
            ),
            // wallet tab
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/icons/wallet.png"),
                color: _currentIndex == 1 ? Color(0xff2F7E79) : Colors.grey,
              ),
              label: "wallet",
            ),
            // lend borrow tab
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/icons/user.png"),
                color: _currentIndex == 2 ? Color(0xff2F7E79) : Colors.grey,
              ),
              label: "lendBorrow",
            ),
          ],
        ),
      ),
    );
  }
}
