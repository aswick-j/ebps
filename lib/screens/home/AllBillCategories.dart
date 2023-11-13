import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/Home/CategoriesContainer.dart';
import 'package:flutter/material.dart';

class AllBillCategories extends StatefulWidget {
  const AllBillCategories({super.key});

  @override
  State<AllBillCategories> createState() => _AllBillCategoriesState();
}

class _AllBillCategoriesState extends State<AllBillCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Bill Categories',
        onLeadingTap: () => Navigator.pop(context),
        showActions: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CategoriesContainer(headerName: "Recharge", categoriesCount: 4),
            CategoriesContainer(headerName: "Utilities", categoriesCount: 8),
            CategoriesContainer(
                headerName: "Financial Services", categoriesCount: 4),
            CategoriesContainer(
                headerName: "More Services", categoriesCount: 4),
          ],
        ),
      ),
    );
  }
}
