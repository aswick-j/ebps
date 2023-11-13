import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/Container/Home/MainContainer.dart';
import 'package:flutter/material.dart';

class AllUpcomingDues extends StatefulWidget {
  const AllUpcomingDues({super.key});

  @override
  State<AllUpcomingDues> createState() => _AllUpcomingDuesState();
}

class _AllUpcomingDuesState extends State<AllUpcomingDues> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        title: 'Upcoming Dues',
        onLeadingTap: () => Navigator.pop(context),
        showActions: false,
      ),
      body: Column(
        children: [
          MainContainer(
            titleText: 'Johnny Depp - Jio Post',
            subtitleText: 'Airtel Telecom Services',
            subtitleText2: '+044 4789 7893',
            dateText: '01/09/2023',
            buttonText: 'Pay Now',
            amount: "₹ 630.00",
            iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
            containerBorderColor: Color(0xffD1D9E8),
            buttonColor: Color(0xFF1B438B),
            buttonTextColor: Color.fromARGB(255, 255, 255, 255),
            buttonTextWeight: FontWeight.normal,
            buttonBorderColor: null,
          ),
          MainContainer(
            titleText: 'Johnny Depp - Jio Post',
            subtitleText: 'Airtel Telecom Services',
            subtitleText2: '+044 4789 7893',
            dateText: '01/09/2023',
            buttonText: 'Upcoming Auto Payment',
            amount: "₹ 630.00",
            iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
            containerBorderColor: Color(0xffD1D9E8),
            buttonColor: Color.fromARGB(255, 255, 255, 255),
            buttonTextColor: Color(0xff00AB44),
            buttonTextWeight: FontWeight.bold,
            buttonBorderColor: Color(0xff00AB44),
          ),
          MainContainer(
            titleText: 'Johnny Depp - Jio Post',
            subtitleText: 'Airtel Telecom Services',
            subtitleText2: '+044 4789 7893',
            dateText: '01/09/2023',
            buttonText: 'Pay Now',
            amount: "₹ 630.00",
            iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
            containerBorderColor: Color(0xffD1D9E8),
            buttonColor: Color(0xFF1B438B),
            buttonTextColor: Color.fromARGB(255, 255, 255, 255),
            buttonTextWeight: FontWeight.normal,
            buttonBorderColor: null,
          ),
        ],
      ),
    );
  }
}
