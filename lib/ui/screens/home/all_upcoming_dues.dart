import 'package:ebps/domain/models/saved_biller_model.dart';
import 'package:ebps/shared/constants/assets.dart';
import 'package:ebps/shared/constants/routes.dart';
import 'package:ebps/shared/helpers/getNavigators.dart';
import 'package:ebps/shared/common/AppBar/MyAppBar.dart';
import 'package:ebps/shared/common/Container/Home/main_container.dart';
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
  handleCustomerBillID(int index) {
    SavedBillersData savedBillersData;
    List<SavedBillersData> billerDataTemp = [];

    billerDataTemp = widget.SavedBiller.where((element) =>
        element.cUSTOMERBILLID.toString().toLowerCase() ==
        widget.allUpcomingDues[index]["customerBillId"]
            .toString()
            .toLowerCase()).toList();

    if (billerDataTemp.isNotEmpty) {
      savedBillersData = billerDataTemp[0];
      return savedBillersData.cUSTOMERBILLID.toString();
    }
  }

  handleInputParams(int index) {
    SavedBillersData savedBillersData;
    List<SavedBillersData> billerDataTemp = [];

    billerDataTemp = widget.SavedBiller.where((element) =>
        element.cUSTOMERBILLID.toString().toLowerCase() ==
        widget.allUpcomingDues[index]["customerBillId"]
            .toString()
            .toLowerCase()).toList();

    if (billerDataTemp.isNotEmpty) {
      savedBillersData = billerDataTemp[0];
      return savedBillersData.pARAMETERVALUE.toString();
    }
  }

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
                    subtitleText2: handleInputParams(index),
                    customerBillID: handleCustomerBillID(index),
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
