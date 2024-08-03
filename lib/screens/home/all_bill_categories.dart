import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/BottomNavBar/BottomBarItem.dart';
import 'package:ebps/common/Container/Home/categories_container.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getBillerCategory.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/categories_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllBillCategories extends StatefulWidget {
  List<CategorieData>? categoriesData;
  final List<SavedBillersData>? SavedBiller;

  AllBillCategories({Key? key, required this.categoriesData, this.SavedBiller})
      : super(key: key);

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
          return GoBack(context);
        case 1:
          return GoToReplaceData(context, hOMEROUTE, {
            "index": 1,
          });
        case 2:
          return GoToReplaceData(context, hOMEROUTE, {
            "index": 2,
          });

        default:
          return GoBack(context);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.CLR_BACKGROUND,
      appBar: MyAppBar(
        context: context,
        title: 'Bill Categories',
        onLeadingTap: () => GoBack(context),
        showActions: false,
      ),
      bottomNavigationBar: BottomBarItem(
          Index: selectedIndex,
          selectedIndex: (int Index) {
            _onItemTapped(Index);
          }),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            CategoriesContainer(
              headerName: "Recharge",
              categoriesCount: RechargeCategories.length,
              categoriesData: RechargeCategories,
              SavedBiller: widget.SavedBiller,
            ),
            CategoriesContainer(
              headerName: "Utilities",
              categoriesCount: UtilitiesCategories.length,
              categoriesData: UtilitiesCategories,
              SavedBiller: widget.SavedBiller,
            ),
            CategoriesContainer(
              headerName: "Financial Services",
              categoriesCount: FinancialCategories.length,
              categoriesData: FinancialCategories,
              SavedBiller: widget.SavedBiller,
            ),
            CategoriesContainer(
              headerName: "More Services",
              categoriesCount: MoreCategories.length,
              categoriesData: MoreCategories,
              SavedBiller: widget.SavedBiller,
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
