import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/MyBillers/MyBillersContainer.dart';
import 'package:flutter/material.dart';

class BillerScreen extends StatefulWidget {
  const BillerScreen({super.key});

  @override
  State<BillerScreen> createState() => _BillerScreenState();
}

class _BillerScreenState extends State<BillerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Billers',
        onLeadingTap: () => Navigator.pop(context),
        showActions: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyBillersContainer(
              titleText: 'Johnny Depp - Jio Post',
              subtitleText: '+044 4789 7893',
              dateText: '01/09/2023',
              buttonText: 'Autopay Enabled',
              amount: "₹ 630.00",
              iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
              upcomingText: 'Upcoming Autopay',
              upcomingTextColor: Color(0xff00AB44),
              containerBorderColor: Color(0xffD1D9E8),
              buttonColor: Color.fromARGB(255, 255, 255, 255),
              buttonTextColor: Color(0xff00AB44),
              buttonTextWeight: FontWeight.bold,
              buttonBorderColor: Color(0xff00AB44),
            ),
            MyBillersContainer(
              titleText: 'Johnny Depp - Jio Post',
              subtitleText: '+044 4789 7893',
              dateText: '01/09/2023',
              buttonText: 'Enable Autopay',
              amount: "₹ 630.00",
              iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
              upcomingText: 'Upcoming Due',
              upcomingTextColor: Color(0xff982f67),
              containerBorderColor: Color(0xffD1D9E8),
              buttonColor: Color.fromARGB(255, 255, 255, 255),
              buttonTextColor: Color(0xff768eb9),
              buttonTextWeight: FontWeight.bold,
              buttonBorderColor: Color(0xff768EB9),
            ),
            MyBillersContainer(
              titleText: 'Johnny Depp - Jio Post',
              subtitleText: '+044 4789 7893',
              dateText: '01/09/2023',
              buttonText: 'Autopay Enabled',
              amount: "₹ 630.00",
              iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
              containerBorderColor: Color(0xffD1D9E8),
              buttonColor: Color.fromARGB(255, 255, 255, 255),
              buttonTextColor: Color(0xff00AB44),
              buttonTextWeight: FontWeight.bold,
              buttonBorderColor: Color(0xff00AB44),
            ),
            MyBillersContainer(
              titleText: 'Johnny Depp - Jio Post',
              subtitleText: '+044 4789 7893',
              dateText: '01/09/2023',
              amount: "₹ 630.00",
              iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
              containerBorderColor: Color(0xffD1D9E8),
            ),
          ],
        ),
      ),
    );
  }
}
