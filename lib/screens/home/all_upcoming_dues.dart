import 'dart:ui';

import 'package:ebps/bloc/myBillers/mybillers_cubit.dart';
import 'package:ebps/common/AppBar/MyAppBar.dart';
import 'package:ebps/common/BottomNavBar/BotttomNavBar.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/Home/main_container.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/getPopupMsg.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/widget/animated_dialog.dart';
import 'package:ebps/widget/custom_dialog.dart';
import 'package:ebps/widget/loader_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AllUpcomingDues extends StatefulWidget {
  List<Map<String, dynamic>> allUpcomingDues;
  dynamic SavedBiller;
  BuildContext ctx;
  List<AllConfigurations>? autopayData;

  AllUpcomingDues(
      {super.key,
      required this.allUpcomingDues,
      required this.autopayData,
      required this.ctx,
      required this.SavedBiller});

  @override
  State<AllUpcomingDues> createState() => _AllUpcomingDuesState();
}

class _AllUpcomingDuesState extends State<AllUpcomingDues> {
  int selectedIndex = 0;
  String? billerName;
  String? billName;

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

  _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        return goBack(context);
      case 1:
        return WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => BottomNavBar(
                      SelectedIndex: 1,
                    )),
          );
        });
      case 2:
        return WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) => BottomNavBar(
                      SelectedIndex: 2,
                    )),
          );
        });

      default:
        return goBack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    handleDialog({required bool success}) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext ctx) {
          return WillPopScope(
              onWillPop: () async => false,
              child: CustomDialog(
                  actions: [
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
                          buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                          buttonBorderColor: Colors.transparent,
                          buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
                          buttonSizeX: 10.h,
                          buttonSizeY: 40.w,
                          buttonTextSize: 14.sp,
                          buttonTextWeight: FontWeight.w500),
                    ),
                  ],
                  showActions: true,
                  child: AnimatedDialog(
                      showImgIcon: success ? true : false,
                      showRichText: true,
                      RichTextContent: success
                          ? getPopupSuccessMsg(
                              6, billerName.toString(), billName.toString())
                          : getPopupFailedMsg(
                              6, billerName.toString(), billName.toString()),
                      subTitle: "",
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      showSub: false,
                      shapeColor: success
                          ? AppColors.CLR_GREEN
                          : AppColors.CLR_ERROR)));
        },
      );
    }

    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: AppColors.CLR_BACKGROUND,
        appBar: MyAppBar(
          context: context,
          title: 'Upcoming Dues',
          onLeadingTap: () => Navigator.pop(context),
          showActions: false,
        ),
        bottomNavigationBar: BottomAppBar(
          height: 60.h,
          elevation: 0,
          notchMargin: 4,
          shape: const CircularNotchedRectangle(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.r),
                  topLeft: Radius.circular(30.r)),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 0),
              ],
            ),
            child: Theme(
              data: ThemeData(splashColor: Colors.white),
              child: BottomNavigationBar(
                backgroundColor: AppColors.CLR_BACKGROUND,
                showUnselectedLabels: true,
                onTap: _onItemTapped,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.CLR_PRIMARY,
                unselectedItemColor: Color(0xffa4b4d1),
                currentIndex: selectedIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(ICON_HOME_INACTIVE),
                    label: "Home",
                    activeIcon: SvgPicture.asset(
                      ICON_HOME,
                      colorFilter: ColorFilter.mode(
                          AppColors.CLR_PRIMARY, BlendMode.srcIn),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      ICON_BILLERS_INACTIVE,
                    ),
                    label: "Billers",
                    activeIcon: SvgPicture.asset(
                      ICON_BILLERS,
                      colorFilter: ColorFilter.mode(
                          AppColors.CLR_PRIMARY, BlendMode.srcIn),
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(ICON_HISTORY_INACTIVE),
                    label: "History",
                    activeIcon: SvgPicture.asset(
                      ICON_HISTORY,
                      colorFilter: ColorFilter.mode(
                          AppColors.CLR_PRIMARY, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
              } else if (state is DeleteUpcomingDueError) {
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
                          setState(() {
                            billName =
                                widget.allUpcomingDues[index]["billName"];
                            billerName =
                                widget.allUpcomingDues[index]["billerName"];
                          });
                          BlocProvider.of<MybillersCubit>(context)
                              .deleteUpcomingDue(handleCustomerBillID(index));
                        },
                        titleText: widget.allUpcomingDues[index]["billName"],
                        subtitleText: widget.allUpcomingDues[index]
                            ["billerName"],
                        subtitleText2: handleInputParams(index),
                        customerBillID: handleCustomerBillID(index),
                        dueStatus:
                            widget.allUpcomingDues[index]["dueStatus"] != ""
                                ? widget.allUpcomingDues[index]["dueStatus"]
                                : 0,
                        dateText: widget.allUpcomingDues[index]["dueDate"] != ""
                            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                    widget.allUpcomingDues[index]["dueDate"]!
                                        .toString()
                                        .substring(0, 10))
                                .toLocal()
                                .add(const Duration(days: 1)))
                            : "-",
                        dueDate: widget.allUpcomingDues[index]["dueDate"] != ""
                            ? DateTime.parse(widget.allUpcomingDues[index]
                                    ["dueDate"]!
                                .toString())
                            : "-",
                        buttonText: widget.allUpcomingDues[index]["itemType"] ==
                                'upcomingDue'
                            ? 'Pay Now'
                            : widget.allUpcomingDues[index]["itemType"] ==
                                    'upcomingAutopaused'
                                ? "Upcoming Autopay Paused"
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
                        autopayData: widget.autopayData,
                        amount: widget.allUpcomingDues[index]["dueAmount"] != ""
                            ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.allUpcomingDues[index]["dueAmount"]!.toString()))}"
                            : "-",
                        iconPath: BILLER_LOGO(
                            widget.allUpcomingDues[index]["billerName"]),
                        containerBorderColor: AppColors.CLR_CON_BORDER,
                        buttonColor: widget.allUpcomingDues[index]
                                    ["itemType"] ==
                                'upcomingDue'
                            ? AppColors.CLR_PRIMARY_NC
                            : AppColors.CLR_GREEN,
                        buttonTxtColor: widget.allUpcomingDues[index]
                                    ["itemType"] ==
                                'upcomingDue'
                            ? AppColors.CLR_PRIMARY_NC
                            : widget.allUpcomingDues[index]["itemType"] ==
                                    'upcomingAutopaused'
                                ? AppColors.CLR_ERROR
                                : AppColors.CLR_GREEN,
                        buttonTextWeight: FontWeight.normal,
                        buttonBorderColor: widget.allUpcomingDues[index]
                                    ["itemType"] ==
                                'upcomingDue'
                            ? null
                            : widget.allUpcomingDues[index]["itemType"] ==
                                    'upcomingAutopaused'
                                ? Colors.red
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
