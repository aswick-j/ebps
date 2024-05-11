import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/common/Container/Home/categories_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/helpers/getBillerCategory.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/categories_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllBillCategories extends StatefulWidget {
  List<CategorieData>? categoriesData;

  AllBillCategories({Key? key, required this.categoriesData}) : super(key: key);

  @override
  State<AllBillCategories> createState() => _AllBillCategoriesState();
}

class _AllBillCategoriesState extends State<AllBillCategories> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;

    /// These lines of code are declaring and initializing four empty lists of type `CategorieData`. These
    /// lists will be used to store different categories based on their type. The categories will be
    /// filtered and added to these lists based on certain conditions.
    List<CategorieData> RechargeCategories = [];
    List<CategorieData> UtilitiesCategories = [];
    List<CategorieData> FinancialCategories = [];
    List<CategorieData> MoreCategories = [];

    /// The code block is filtering the `widget.categoriesData` list based on certain conditions and
    /// assigning the filtered results to different lists (`RechargeCategories`, `UtilitiesCategories`,
    /// `FinancialCategories`, and `MoreCategories`).
    if (widget.categoriesData != null) {
      RechargeCategories = widget.categoriesData!
          .where((item) =>
              RechargeCat.any((value) => item.cATEGORYNAME!.contains(value)))
          .toList();
      UtilitiesCategories = widget.categoriesData!
          .where((item) =>
              UtilCat.any((value) => item.cATEGORYNAME!.contains(value)))
          .toList();
      FinancialCategories = widget.categoriesData!
          .where((item) =>
              FinCat.any((value) => item.cATEGORYNAME!.contains(value)))
          .toList();
      MoreCategories = widget.categoriesData!
          .where((item) => ExcludedCategories.every(
              (value) => !item.cATEGORYNAME!.contains(value)))
          .toList();
    }
    _onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
      switch (index) {
        case 0:
          return goBack(context);
        case 1:
          return WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => BottomNavBar(
                        SelectedIndex: 1,
                      )),
            );
          });
        case 2:
          return WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => BottomNavBar(
                        SelectedIndex: 2,
                      )),
            );
          });

        default:
          return goBack(context);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.CLR_BACKGROUND,
      appBar: MyAppBar(
        context: context,
        title: 'Bill Categories',
        onLeadingTap: () => goBack(context),
        showActions: false,
      ),
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
            boxShadow: const [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 0),
            ],
          ),
          child: Theme(
            data: ThemeData(splashColor: Colors.white),
            child: BottomNavigationBar(
              backgroundColor: AppColors.CLR_BACKGROUND,
              showUnselectedLabels: true,
              onTap: _onItemTapped,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.CLR_PRIMARY,
              unselectedItemColor: Color(0xffa4b4d1),
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              currentIndex: selectedIndex,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(ICON_HOME_INACTIVE),
                  label: "Home",
                  activeIcon: SvgPicture.asset(
                    ICON_HOME,
                    colorFilter: ColorFilter.mode(
                        AppColors.CLR_PRIMARY, BlendMode.srcIn),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    ICON_BILLERS_INACTIVE,
                  ),
                  label: "Billers",
                  activeIcon: SvgPicture.asset(
                    ICON_BILLERS,
                    colorFilter: ColorFilter.mode(
                        AppColors.CLR_PRIMARY, BlendMode.srcIn),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(ICON_HISTORY_INACTIVE),
                  label: "History",
                  activeIcon: SvgPicture.asset(
                    ICON_HISTORY,
                    colorFilter: ColorFilter.mode(
                        AppColors.CLR_PRIMARY, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            CategoriesContainer(
              headerName: "Recharge",
              categoriesCount: RechargeCategories.length,
              categoriesData: RechargeCategories,
            ),
            CategoriesContainer(
              headerName: "Utilities",
              categoriesCount: UtilitiesCategories.length,
              categoriesData: UtilitiesCategories,
            ),
            CategoriesContainer(
              headerName: "Financial Services",
              categoriesCount: FinancialCategories.length,
              categoriesData: FinancialCategories,
            ),
            CategoriesContainer(
              headerName: "More Services",
              categoriesCount: MoreCategories.length,
              categoriesData: MoreCategories,
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
