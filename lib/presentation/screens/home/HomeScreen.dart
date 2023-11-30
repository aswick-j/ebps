import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/screens/home/BillCategories.dart';
import 'package:ebps/presentation/screens/home/SearchScreen.dart';
import 'package:ebps/presentation/screens/home/UpcomingDues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Bill Payment',
        actions: [
          InkWell(
              onTap: () => {goTo(context, sEARCHROUTE)},
              child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20, right: 15),
                  width: 40,
                  decoration: ShapeDecoration(
                    color: CLR_SECONDARY,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: Container(
                    width: 20,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )))
        ],
        onLeadingTap: () => Navigator.pop(context),
        showActions: true,
        onSearchTap: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            UpcomingDues(),
            BillCategories(),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
