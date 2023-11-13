import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/screens/home/BillCategories.dart';
import 'package:ebps/screens/home/UpcomingDues.dart';
import 'package:flutter/material.dart';

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
              onTap: () => {},
              child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20, right: 15),
                  width: 40,
                  decoration: ShapeDecoration(
                    color: secondaryColor,
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
          children: [UpcomingDues(), BillCategories()],
        ),
      ),
    );
  }
}
