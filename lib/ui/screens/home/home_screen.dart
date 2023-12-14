import 'package:ebps/shared/constants/colors.dart';
import 'package:ebps/shared/constants/routes.dart';
import 'package:ebps/shared/helpers/getNavigators.dart';
import 'package:ebps/shared/common/AppBar/MyAppBar.dart';
import 'package:ebps/shared/common/Container/Home/home_banners.dart';
import 'package:ebps/ui/screens/home/bill_categories.dart';
import 'package:ebps/ui/screens/home/upcoming_dues.dart';
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
          Icon(
            Icons.notification_important_outlined,
            color: CLR_SECONDARY,
          ),
          SizedBox(
            width: 5.w,
          ),
          InkWell(
              onTap: () => {goTo(context, sEARCHROUTE)},
              child: Container(
                  margin: EdgeInsets.only(right: 15.w),
                  // width: 40.w,
                  // height: 40.h,
                  decoration: ShapeDecoration(
                    color: CLR_SECONDARY,
                    shape: CircleBorder(),
                  ),
                  child: Container(
                    width: 30.w,
                    height: 30.h,
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
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
            // HomeBanners(),
            HomeBanners(),
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
