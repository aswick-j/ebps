import 'package:ebps/constants/assets.dart';
import 'package:ebps/presentation/screens/history/history_screen.dart';
import 'package:ebps/presentation/screens/home/home_screen.dart';
import 'package:ebps/presentation/screens/myBillers/biller_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        bottomNavigationBar: BottomAppBar(
          height: 60.h,
          elevation: 0,
          notchMargin: 4,
          shape: const CircularNotchedRectangle(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.r),
                  topLeft: Radius.circular(30.r)),
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
                    icon: SvgPicture.asset(ICON_HOME_INACTIVE),
                    label: "Home",
                    activeIcon: SvgPicture.asset(ICON_HOME),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(ICON_BILLERS_INACTIVE),
                    label: "Billers",
                    activeIcon: SvgPicture.asset(ICON_BILLERS),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(ICON_HISTORY_INACTIVE),
                    label: "History",
                    activeIcon: SvgPicture.asset(ICON_HISTORY),
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
