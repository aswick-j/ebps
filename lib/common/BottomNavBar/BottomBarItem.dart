import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomBarItem extends StatefulWidget {
  final int Index;
  final void Function(int index) selectedIndex;
  const BottomBarItem(
      {super.key, required this.Index, required this.selectedIndex});

  @override
  State<BottomBarItem> createState() => _BottomBarItemState();
}

class _BottomBarItemState extends State<BottomBarItem> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60.h,
      elevation: 0,
      notchMargin: 4,
      shape: const CircularNotchedRectangle(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.r), topLeft: Radius.circular(30.r)),
          boxShadow: const [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 0),
          ],
        ),
        child: Theme(
          data: ThemeData(splashColor: Colors.white),
          child: BottomNavigationBar(
            backgroundColor: AppColors.CLR_BACKGROUND,
            showUnselectedLabels: true,
            onTap: widget.selectedIndex,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.CLR_PRIMARY,
            unselectedItemColor: Color(0xffa4b4d1),
            currentIndex: widget.Index,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(ICON_HOME_INACTIVE),
                label: "Home",
                activeIcon: SvgPicture.asset(
                  ICON_HOME,
                  colorFilter:
                      ColorFilter.mode(AppColors.CLR_PRIMARY, BlendMode.srcIn),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  ICON_BILLERS_INACTIVE,
                ),
                label: "Billers",
                activeIcon: SvgPicture.asset(
                  ICON_BILLERS,
                  colorFilter:
                      ColorFilter.mode(AppColors.CLR_PRIMARY, BlendMode.srcIn),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(ICON_HISTORY_INACTIVE),
                label: "History",
                activeIcon: SvgPicture.asset(
                  ICON_HISTORY,
                  colorFilter:
                      ColorFilter.mode(AppColors.CLR_PRIMARY, BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
