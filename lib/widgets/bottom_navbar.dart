import 'package:flutter/material.dart';
import 'package:tracker_app/views/home.dart';
import 'package:tracker_app/views/lend_borrow.dart';
import 'package:tracker_app/views/wallet.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentIndex = 0;

  final List<Widget> _screens =  [Home(), Wallet(), LendBorrowPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar:
      
       Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
         child: BottomNavigationBar(
          
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() => _currentIndex = value);
          },
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                 AssetImage("assets/icons/home.png"),
                color: _currentIndex == 0 ?  Color(0xff2F7E79) : Colors.grey,
              ),
              label: "home",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                 AssetImage("assets/icons/wallet.png"),
                color: _currentIndex == 1 ? Color(0xff2F7E79) : Colors.grey,
              ),
              label: "wallet",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/icons/user.png"),
                color: _currentIndex == 2 ?  Color(0xff2F7E79) : Colors.grey,
              ),
              label: "lendBorrow",
            ),
          ],
               ),
       ),
    );
  }
}
