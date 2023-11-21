import 'package:ebps/presentation/screens/history/HistoryScreen.dart';
import 'package:ebps/presentation/screens/home/HomeScreen.dart';
import 'package:ebps/presentation/screens/myBillers/BillerScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const BillerScreen();
      case 2:
        return const HistoryScreen();

      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _onItemTapped(selectedIndex),
        bottomNavigationBar: BottomAppBar(
          height: 70,
          elevation: 0,
          notchMargin: 4,
          shape: const CircularNotchedRectangle(),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 0),
              ],
            ),
            child: Theme(
              data: ThemeData(splashColor: Colors.white),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                showUnselectedLabels: true,
                onTap: _onItemTapped,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Color(0xff1b438b),
                unselectedItemColor: Color(0xffa4b4d1),
                currentIndex: selectedIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        'packages/ebps/assets/icon/icon_home_inactive.svg'),
                    label: "Home",
                    activeIcon: SvgPicture.asset(
                        'packages/ebps/assets/icon/icon_home.svg'),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        'packages/ebps/assets/icon/icon_billers_inactive.svg'),
                    label: "Billers",
                    activeIcon: SvgPicture.asset(
                        'packages/ebps/assets/icon/icon_billers.svg'),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                        'packages/ebps/assets/icon/icon_history.svg'),
                    label: "History",
                    activeIcon: SvgPicture.asset(
                        'packages/ebps/assets/icon/icon_history.svg'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
