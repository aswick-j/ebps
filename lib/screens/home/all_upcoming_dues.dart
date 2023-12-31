import 'package:ebps/bloc/home/home_cubit.dart';
import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/main_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/animated_dialog.dart';
import 'package:ebps/widget/loader_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AllUpcomingDues extends StatefulWidget {
  List<Map<String, dynamic>> allUpcomingDues;
  dynamic SavedBiller;
  BuildContext ctx;

  AllUpcomingDues(
      {super.key,
      required this.allUpcomingDues,
      required this.ctx,
      required this.SavedBiller});

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
    handleDialog({required bool success}) {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            content: AnimatedDialog(
                title: success
                    ? "Due Deleted Successfully"
                    : "Due Deletion Failed",
                subTitle: "",
                child: Icon(
                  success ? Icons.check : Icons.close,
                  color: Colors.white,
                ),
                showSub: false,
                shapeColor: success ? CLR_GREEN : CLR_ERROR),
            actions: <Widget>[
              Align(
                alignment: Alignment.center,
                child: MyAppButton(
                    onPressed: () {
                      goBack(ctx);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => BottomNavBar(
                                    SelectedIndex: 0,
                                  )),
                          (Route<dynamic> route) => false,
                        );
                      });
                    },
                    buttonText: "Okay",
                    buttonTxtColor: BTN_CLR_ACTIVE,
                    buttonBorderColor: Colors.transparent,
                    buttonColor: CLR_PRIMARY,
                    buttonSizeX: 10,
                    buttonSizeY: 40,
                    buttonTextSize: 14,
                    buttonTextWeight: FontWeight.w500),
              ),
            ],
          );
        },
      );
    }

    return LoaderOverlay(
      child: Scaffold(
        appBar: MyAppBar(
          context: context,
          title: 'Upcoming Dues',
          onLeadingTap: () => Navigator.pop(context),
          showActions: false,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: BlocListener<MybillersCubit, MybillersState>(
            listener: (context, state) {
              if (state is DeleteUpcomingDueLoading) {
                LoaderOverlay.of(context).show();
              } else if (state is DeleteUpcomingDueSuccess) {
                handleDialog(success: true);
                LoaderOverlay.of(context).hide();
              } else if (state is DeleteUpcomingDueFailed) {
                handleDialog(success: false);

                LoaderOverlay.of(context).hide();
              } else if (state is deleteBillerError) {
                handleDialog(success: false);

                LoaderOverlay.of(context).hide();
              }
            },
            child: Column(
              children: [
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.allUpcomingDues.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MainContainer(
                        ctx: widget.ctx,
                        onDeleteUpPressed: () {
                          BlocProvider.of<MybillersCubit>(context)
                              .deleteUpcomingDue(handleCustomerBillID(index));
                        },
                        titleText: widget.allUpcomingDues[index]["billName"],
                        subtitleText: widget.allUpcomingDues[index]
                            ["billerName"],
                        subtitleText2: handleInputParams(index),
                        customerBillID: handleCustomerBillID(index),
                        dateText: widget.allUpcomingDues[index]["dueDate"] != ""
                            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                    widget.allUpcomingDues[index]["dueDate"]!
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
                              "name": widget.allUpcomingDues[index]
                                  ["billerName"],
                              "billName": widget.allUpcomingDues[index]
                                  ["billName"],
                              "savedBillersData": savedBillersData,
                              "SavedinputParameters":
                                  savedBillersData.pARAMETERS,
                              "categoryName": savedBillersData.cATEGORYNAME,
                              "isSavedBill": true,
                            });
                          }
                        },
                        amount: widget.allUpcomingDues[index]["dueAmount"] != ""
                            ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.allUpcomingDues[index]["dueAmount"]!.toString()))}"
                            : "-",
                        iconPath: BILLER_LOGO(
                            widget.allUpcomingDues[index]["billerName"]),
                        containerBorderColor: Color(0xffD1D9E8),
                        buttonColor: widget.allUpcomingDues[index]
                                    ["itemType"] ==
                                'upcomingDue'
                            ? Color(0xFF1B438B)
                            : Color.fromARGB(255, 255, 255, 255),
                        buttonTxtColor: widget.allUpcomingDues[index]
                                    ["itemType"] ==
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
        ),
      ),
    );
  }
}
