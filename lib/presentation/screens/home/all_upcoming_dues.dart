import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/data/models/add_biller_model.dart';
import 'package:ebps/data/models/saved_biller_model.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/presentation/common/AppBar/MyAppBar.dart';
import 'package:ebps/presentation/common/Container/Home/main_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

class AllUpcomingDues extends StatefulWidget {
  List<Map<String, dynamic>> allUpcomingDues;
  dynamic SavedBiller;

  AllUpcomingDues(
      {super.key, required this.allUpcomingDues, required this.SavedBiller});

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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.allUpcomingDues.length,
                itemBuilder: (BuildContext context, int index) {
                  return MainContainer(
                    titleText: widget.allUpcomingDues[index]["billName"],
                    subtitleText: widget.allUpcomingDues[index]["billerName"],
                    subtitleText2: '+044 4789 7893',
                    dateText: widget.allUpcomingDues[index]["dueDate"] != ""
                        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(widget
                                .allUpcomingDues[index]["dueDate"]!
                                .toString()
                                .substring(0, 10))
                            .toLocal()
                            .add(const Duration(days: 1)))
                        : "-",
                    buttonText: widget.allUpcomingDues[index]["itemType"] ==
                            'upcomingDue'
                        ? 'Pay Now'
                        : "Upcoming Auto Payment",
                    onPressed: () {
                      SavedBillersData savedBillersData;
                      List<SavedBillersData> billerDataTemp = [];

                      billerDataTemp = widget.SavedBiller.where((element) =>
                          element.cUSTOMERBILLID.toString().toLowerCase() ==
                          widget.allUpcomingDues[index]["customerBillId"]
                              .toString()
                              .toLowerCase()).toList();

                      if (billerDataTemp.isNotEmpty) {
                        savedBillersData = billerDataTemp[0];
                        goToData(context, fETCHBILLERDETAILSROUTE, {
                          "name": widget.allUpcomingDues[index]["billerName"],
                          "billName": widget.allUpcomingDues[index]["billName"],
                          "savedBillersData": savedBillersData,
                          "SavedinputParameters": savedBillersData.pARAMETERS,
                          "categoryName": savedBillersData.cATEGORYNAME,
                          "isSavedBill": true,
                        });
                      }
                    },
                    amount: widget.allUpcomingDues[index]["dueAmount"] != ""
                        ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.allUpcomingDues[index]["dueAmount"]!.toString()))}"
                        : "-",
                    iconPath: LOGO_BBPS,
                    containerBorderColor: Color(0xffD1D9E8),
                    buttonColor: widget.allUpcomingDues[index]["itemType"] ==
                            'upcomingDue'
                        ? Color(0xFF1B438B)
                        : Color.fromARGB(255, 255, 255, 255),
                    buttonTxtColor: widget.allUpcomingDues[index]["itemType"] ==
                            'upcomingDue'
                        ? Color.fromARGB(255, 255, 255, 255)
                        : Color(0xff00AB44),
                    buttonTextWeight: FontWeight.normal,
                    buttonBorderColor: widget.allUpcomingDues[index]
                                ["itemType"] ==
                            'upcomingDue'
                        ? null
                        : Color(0xff00AB44),
                  );
                  //         MainContainer(
                  //   titleText: 'Johnny Depp - Jio Post',
                  //   subtitleText: 'Airtel Telecom Services',
                  //   subtitleText2: '+044 4789 7893',
                  //   dateText: '01/09/2023',
                  //   buttonText: 'Pay Now',
                  //   amount: "₹ 630.00",
                  //   iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
                  //   containerBorderColor: Color(0xffD1D9E8),
                  //   buttonColor: Color(0xFF1B438B),
                  //   buttonTxtColor: Color.fromARGB(255, 255, 255, 255),
                  //   buttonTextWeight: FontWeight.normal,
                  //   buttonBorderColor: null,
                  // ),
                  // MainContainer(
                  //   titleText: 'Johnny Depp - Jio Post',
                  //   subtitleText: 'Airtel Telecom Services',
                  //   subtitleText2: '+044 4789 7893',
                  //   dateText: '01/09/2023',
                  //   buttonText: 'Upcoming Auto Payment',
                  //   amount: "₹ 630.00",
                  //   iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
                  //   containerBorderColor: Color(0xffD1D9E8),
                  //   buttonColor: Color.fromARGB(255, 255, 255, 255),
                  //   buttonTxtColor: Color(0xff00AB44),
                  //   buttonTextWeight: FontWeight.bold,
                  //   buttonBorderColor: Color(0xff00AB44),
                  // ),
                  // MainContainer(
                  //   titleText: 'Johnny Depp - Jio Post',
                  //   subtitleText: 'Airtel Telecom Services',
                  //   subtitleText2: '+044 4789 7893',
                  //   dateText: '01/09/2023',
                  //   buttonText: 'Pay Now',
                  //   amount: "₹ 630.00",
                  //   iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
                  //   containerBorderColor: Color(0xffD1D9E8),
                  //   buttonColor: Color(0xFF1B438B),
                  //   buttonTxtColor: Color.fromARGB(255, 255, 255, 255),
                  //   buttonTextWeight: FontWeight.normal,
                  //   buttonBorderColor: null,
                  // ),
                  // UpcomingDuesContainer(
                  //   titleText: allUpcomingDues[index]["billName"],
                  //   subtitleText: '+044 4789 7893',
                  //   dateText: allUpcomingDues[index]["dueDate"] != ""
                  //       ? DateFormat('dd/MM/yyyy').format(DateTime.parse(
                  //               allUpcomingDues[index]["dueDate"]!
                  //                   .toString()
                  //                   .substring(0, 10))
                  //           .toLocal()
                  //           .add(const Duration(days: 1)))
                  //       : "-",
                  //   buttonText: 'Upcoming Auto Payment',
                  //   amount:
                  //       "₹ ${NumberFormat('#,##,##0.00').format(double.parse(allUpcomingDues[index]["dueAmount"]!.toString()))}",
                  //   iconPath: 'packages/ebps/assets/icon/icon_jio.svg',
                  //   containerBorderColor: Color(0xffD1D9E8),
                  //   buttonColor: Color.fromARGB(255, 255, 255, 255),
                  //   buttonTxtColor: Color(0xff00AB44),
                  //   buttonTextWeight: FontWeight.bold,
                  //   buttonBorderColor: Color(0xff00AB44),
                  // );
                }),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }
}
