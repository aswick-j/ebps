import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/constants/const.dart';
import 'package:ebps/data/models/categories_model.dart';
import 'package:ebps/helpers/getBillerCategory.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Container/Home/CategoriesContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllBillCategories extends StatefulWidget {
  List<CategorieData>? categoriesData;

  AllBillCategories({Key? key, required this.categoriesData}) : super(key: key);

  @override
  State<AllBillCategories> createState() => _AllBillCategoriesState();
}

class _AllBillCategoriesState extends State<AllBillCategories> {
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Bill Categories',
        onLeadingTap: () => goBack(context),
        showActions: false,
      ),
      body: SingleChildScrollView(
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
