import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Container/History/HistoryContainer.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          context: context,
          title: 'History',
          onLeadingTap: () => Navigator.pop(context),
          showActions: true,
          actions: [
            InkWell(
                onTap: () => {},
                child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20, right: 15),
                    width: 40,
                    decoration: ShapeDecoration(
                      color: Color(0xff4969A2),
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
                          Icons.comment,
                          color: Colors.white,
                        ),
                      ),
                    )))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HistoryContainer(
                titleText: 'Paid to',
                subtitleText: 'Airtel telecom Services',
                dateText: '01/09/2023',
                amount: "₹ 589.00",
                iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
                containerBorderColor: Color(0xffD1D9E8),
              ),
              HistoryContainer(
                titleText: 'Paid to',
                subtitleText: 'Airtel telecom Services',
                dateText: '01/09/2023',
                amount: "₹ 589.00",
                statusText: "PENDING",
                iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
                containerBorderColor: Color(0xffD1D9E8),
              ),
              HistoryContainer(
                titleText: 'Paid to',
                subtitleText: 'Airtel telecom Services',
                dateText: '01/09/2023',
                amount: "₹ 589.00",
                iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
                containerBorderColor: Color(0xffD1D9E8),
              ),
              HistoryContainer(
                titleText: 'Paid to',
                subtitleText: 'Airtel telecom Services',
                dateText: '01/09/2023',
                amount: "₹ 589.00",
                statusText: "FAILLED",
                iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
                containerBorderColor: Color(0xffD1D9E8),
              ),
            ],
          ),
        ));
  }
}
