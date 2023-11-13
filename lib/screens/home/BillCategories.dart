import 'package:ebps/common/Container/Home/CategoriesContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BillCategories extends StatefulWidget {
  const BillCategories({super.key});

  @override
  State<BillCategories> createState() => _BillCategoriesState();
}

class _BillCategoriesState extends State<BillCategories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategoriesContainer(
          headerName: "Bill Categories",
          categoriesCount: 8,
          viewall: true,
        ),
        CategoriesContainer(headerName: "More Services", categoriesCount: 4),
      ],
    );
  }
}
