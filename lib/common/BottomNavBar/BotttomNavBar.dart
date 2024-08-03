import 'package:ebps/common/BottomNavBar/BottomBarItem.dart';
import 'package:ebps/screens/history/history_screen.dart';
import 'package:ebps/screens/home/home_screen.dart';
import 'package:ebps/screens/myBillers/biller_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  int SelectedIndex;

  BottomNavBar({Key? key, required this.SelectedIndex}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    selectedIndex = widget.SelectedIndex;
    super.initState();
  }

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
          bottomNavigationBar: BottomBarItem(
              Index: selectedIndex,
              selectedIndex: (int Index) {
                _onItemTapped(Index);
              })),
    );
  }
}
