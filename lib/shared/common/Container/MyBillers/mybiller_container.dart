import 'package:ebps/domain/models/auto_schedule_pay_model.dart';
import 'package:ebps/domain/models/saved_biller_model.dart';
import 'package:ebps/shared/constants/assets.dart';
import 'package:ebps/shared/constants/colors.dart';
import 'package:ebps/shared/constants/routes.dart';

import 'package:ebps/shared/helpers/getNavigators.dart';
import 'package:ebps/shared/common/Button/MyAppButton.dart';
import 'package:ebps/shared/widget/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class MyBillersContainer extends StatefulWidget {
  final String? buttonText;
  final String iconPath;
  final String? upcomingText;
  final Color? upcomingTXT_CLR_DEFAULT;
  final Color containerBorderColor;
  final Color? buttonColor;
  final Color? buttonTxtColor;
  final FontWeight? buttonTextWeight;
  final Color buttonBorderColor;
  final bool? warningBtn;
  SavedBillersData savedBillersData;
  List<PARAMETERS>? SavedinputParameters;
  bool showButton;
  List<AllConfigurations>? allautoPaymentList;
  MyBillersContainer({
    this.buttonText,
    required this.iconPath,
    this.upcomingText,
    this.upcomingTXT_CLR_DEFAULT,
    required this.containerBorderColor,
    this.buttonColor,
    this.buttonTxtColor,
    required this.buttonBorderColor,
    this.buttonTextWeight,
    this.warningBtn,
    required this.showButton,
    required this.savedBillersData,
    required this.SavedinputParameters,
    required this.allautoPaymentList,
  });

  @override
  State<MyBillersContainer> createState() => _MyBillersContainerState();
}

class _MyBillersContainerState extends State<MyBillersContainer> {
  bool switchButton = true;
  getAllAutopayList(customerBILLID) {
    try {
      List<AllConfigurationsData>? autopayData = [];
      for (int i = 0; i < widget.allautoPaymentList!.length; i++) {
        for (int j = 0; j < widget.allautoPaymentList![i].data!.length; j++) {
          autopayData.add(widget.allautoPaymentList![i].data![j]);
        }
      }

      List<AllConfigurationsData>? find = autopayData
          .where((item) => item.cUSTOMERBILLID == customerBILLID)
          .toList();

      return (find.isNotEmpty ? find[0] : null);
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    handleDialog() {
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) {
            return AlertDialog(
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: MyAppButton(
                        onPressed: () {
                          goBack(context);
                        },
                        buttonText: "Cancel",
                        buttonTxtColor: BTN_CLR_ACTIVE,
                        buttonBorderColor: Colors.transparent,
                        buttonColor: CLR_PRIMARY,
                        buttonSizeX: 10.h,
                        buttonSizeY: 40.w,
                        buttonTextSize: 14.sp,
                        buttonTextWeight: FontWeight.w500),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: MyAppButton(
                        onPressed: () {
                          goBack(context);
                        },
                        buttonText: "Delete",
                        buttonTxtColor: BTN_CLR_ACTIVE,
                        buttonBorderColor: Colors.transparent,
                        buttonColor: CLR_PRIMARY,
                        buttonSizeX: 10.h,
                        buttonSizeY: 40.w,
                        buttonTextSize: 14.sp,
                        buttonTextWeight: FontWeight.w500),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                content: SingleChildScrollView(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: 50.h,
                          width: 50.w,
                          child: SvgPicture.asset(ICON_SUCCESS)),
                      Text(
                        "Are You Sure You Want To Delete",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff000000),
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ));
          });
    }

    return GestureDetector(
      onTap: () {
        goToData(context, fETCHBILLERDETAILSROUTE, {
          "name": widget.savedBillersData.bILLERNAME,
          "billName": widget.savedBillersData.bILLNAME,
          "savedBillersData": widget.savedBillersData,
          "SavedinputParameters": widget.SavedinputParameters,
          "categoryName": widget.savedBillersData.cATEGORYNAME,
          "isSavedBill": true,
        });
      },
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(
              left: 18.0.w, right: 18.w, top: 10.h, bottom: 0.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0.r),
            border: Border.all(
              color: Color(0xFFD1D9E8),
              width: 2.0,
            ),
          ),
          child: Column(children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 8.w, right: 15.w, top: 4.h),
              leading: Container(
                width: 45.w,
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: SvgPicture.asset(widget.iconPath),
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Text(
                  widget.savedBillersData.bILLERNAME.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff191919),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.savedBillersData.pARAMETERVALUE.toString(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff808080),
                    ),
                  ),
                ],
              ),
              trailing: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.0.r),
                        ),
                      ),
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.only(
                                  left: 8.w, right: 15.w, top: 4.h),
                              leading: Container(
                                width: 45.w,
                                child: Padding(
                                  padding: EdgeInsets.all(8.r),
                                  child: SvgPicture.asset(widget.iconPath),
                                ),
                              ),
                              title: Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: Text(
                                  widget.savedBillersData.bILLERNAME.toString(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff191919),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.savedBillersData.pARAMETERVALUE
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff808080),
                                        ),
                                      ),
                                      if (widget.showButton &&
                                          widget.buttonText.toString() ==
                                              "Autopay Enabled" &&
                                          getAllAutopayList(widget
                                                      .savedBillersData
                                                      .cUSTOMERBILLID)
                                                  .pAYMENTDATE !=
                                              DateTime.now().day.toString())
                                        CustomSwitch(
                                          value: switchButton =
                                              getAllAutopayList(widget
                                                              .savedBillersData
                                                              .cUSTOMERBILLID)
                                                          .iSACTIVE ==
                                                      1
                                                  ? false
                                                  : true,
                                          onChanged: (val) {
                                            // setState(() {
                                            //   switchButton = val;
                                            // });
                                          },
                                        ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Text(
                                  //   buttonText.toString(),
                                  //   style: TextStyle(
                                  //     fontSize: 14.sp,
                                  //     fontWeight: FontWeight.w500,
                                  //     color: buttonTxtColor,
                                  //   ),
                                  //   textAlign: TextAlign.center,
                                  // )
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.6,
                                      blurRadius: 4,
                                      offset: Offset(0, 2)),
                                ],
                              ),
                              child: Divider(
                                height: 1.h,
                                thickness: 1,
                                color: Colors.grey.withOpacity(0.1),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Column(
                              children: [
                                ModalMenu(
                                    context: context,
                                    iconPath: ICON_BILLHISTORY,
                                    title: "View Payment History",
                                    onPressed: () {
                                      goToData(context, bILLERHISTORYROUTE, {
                                        "categoryID": widget
                                            .savedBillersData.cATEGORYNAME,
                                        "billerID":
                                            widget.savedBillersData.bILLERID
                                      });
                                    }),
                                if (widget.savedBillersData.aUTOPAYID != null)
                                  if (getAllAutopayList(widget
                                          .savedBillersData.cUSTOMERBILLID) !=
                                      null)
                                    if ((getAllAutopayList(widget
                                                        .savedBillersData
                                                        .cUSTOMERBILLID) !=
                                                    null
                                                ? getAllAutopayList(widget
                                                        .savedBillersData
                                                        .cUSTOMERBILLID)!
                                                    .pAYMENTDATE
                                                : "") !=
                                            DateTime.now().day.toString() &&
                                        getAllAutopayList(widget
                                                    .savedBillersData
                                                    .cUSTOMERBILLID)!
                                                .iSACTIVE ==
                                            1)
                                      ModalMenu(
                                          context: context,
                                          iconPath: ICON_EDIT,
                                          title: "Edit Autopay",
                                          onPressed: () {
                                            goToData(
                                                context, eDITAUTOPAYROUTE, {
                                              "billerName": widget
                                                  .savedBillersData.bILLERNAME,
                                              "categoryName": widget
                                                  .savedBillersData
                                                  .cATEGORYNAME,
                                              "billName": widget
                                                  .savedBillersData.bILLNAME,
                                              "customerBillID": widget
                                                  .savedBillersData
                                                  .cUSTOMERBILLID
                                                  .toString(),
                                              "autopayData": getAllAutopayList(
                                                  widget.savedBillersData
                                                      .cUSTOMERBILLID),
                                              "savedInputSignatures": widget
                                                  .savedBillersData.pARAMETERS,
                                            });
                                          }),
                                if (widget.savedBillersData.aUTOPAYID != null)
                                  ModalMenu(
                                      context: context,
                                      iconPath: ICON_DELETE,
                                      title: "Delete Autopay",
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(16.0.r),
                                              ),
                                            ),
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15.h,
                                                        bottom: 15.h,
                                                        left: 15.w,
                                                        right: 15.w),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .delete_sweep_outlined,
                                                          color:
                                                              Color(0xff1b438b),
                                                        ),
                                                        SizedBox(width: 20.w),
                                                        Text(
                                                          "Delete Autopay",
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xff1b438b),
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 0.6,
                                                            blurRadius: 4,
                                                            offset:
                                                                Offset(0, 2)),
                                                      ],
                                                    ),
                                                    child: Divider(
                                                      height: 1.h,
                                                      thickness: 1,
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0.h,
                                                        bottom: 16.h,
                                                        left: 16.w,
                                                        right: 16.w),
                                                    child: Center(
                                                      child: Text(
                                                        "Are You Sure You Want To Delete",
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0.h,
                                                        bottom: 16.h,
                                                        left: 16.w,
                                                        right: 16.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: MyAppButton(
                                                              onPressed: () {
                                                                goBack(context);
                                                              },
                                                              buttonText:
                                                                  "Cancel",
                                                              buttonTxtColor:
                                                                  CLR_PRIMARY,
                                                              buttonBorderColor:
                                                                  Colors
                                                                      .transparent,
                                                              buttonColor:
                                                                  BTN_CLR_ACTIVE,
                                                              buttonSizeX: 10.h,
                                                              buttonSizeY: 40.w,
                                                              buttonTextSize:
                                                                  14.sp,
                                                              buttonTextWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        SizedBox(
                                                          width: 40.w,
                                                        ),
                                                        Expanded(
                                                          child: MyAppButton(
                                                              onPressed: () {
                                                                //                             goToData(context, otpRoute, {

                                                                goToData(
                                                                    context,
                                                                    oTPPAGEROUTE,
                                                                    {
                                                                      "from":
                                                                          'delete-auto-pay',
                                                                      "templateName":
                                                                          "delete-auto-pay",
                                                                      "autopayData": getAllAutopayList(widget
                                                                          .savedBillersData
                                                                          .cUSTOMERBILLID),
                                                                      "data": {
                                                                        "billerName": widget
                                                                            .savedBillersData
                                                                            .bILLERNAME,
                                                                        "cUSTOMERBILLID": widget
                                                                            .savedBillersData
                                                                            .cUSTOMERBILLID
                                                                            .toString(),
                                                                      }
                                                                    });
                                                              },
                                                              buttonText:
                                                                  "Delete",
                                                              buttonTxtColor:
                                                                  BTN_CLR_ACTIVE,
                                                              buttonBorderColor:
                                                                  Colors
                                                                      .transparent,
                                                              buttonColor:
                                                                  CLR_PRIMARY,
                                                              buttonSizeX: 10.h,
                                                              buttonSizeY: 40.w,
                                                              buttonTextSize:
                                                                  14.sp,
                                                              buttonTextWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                ],
                                              );
                                            });
                                      }),
                                if (widget.savedBillersData.aUTOPAYID == null)
                                  ModalMenu(
                                      context: context,
                                      iconPath: ICON_EDIT,
                                      title: "Edit",
                                      onPressed: () {
                                        goToData(context, eDITBILLERROUTE, {
                                          "SavedBillersData":
                                              widget.savedBillersData
                                        });
                                      }),
                                if (widget.savedBillersData.aUTOPAYID == null)
                                  ModalMenu(
                                      context: context,
                                      iconPath: ICON_DELETE,
                                      title: "Delete",
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(16.0.r),
                                              ),
                                            ),
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 15.h,
                                                        bottom: 15.h,
                                                        left: 15.w,
                                                        right: 15.w),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .delete_sweep_outlined,
                                                          color:
                                                              Color(0xff1b438b),
                                                        ),
                                                        SizedBox(width: 20.w),
                                                        Text(
                                                          "Delete Biller",
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xff1b438b),
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 0.6,
                                                            blurRadius: 4,
                                                            offset:
                                                                Offset(0, 2)),
                                                      ],
                                                    ),
                                                    child: Divider(
                                                      height: 1.h,
                                                      thickness: 1,
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0.h,
                                                        bottom: 16.h,
                                                        left: 16.w,
                                                        right: 16.w),
                                                    child: Center(
                                                      child: Text(
                                                        "Are You Sure You Want To Delete",
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 0.h,
                                                        bottom: 16.h,
                                                        left: 16.w,
                                                        right: 16.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: MyAppButton(
                                                              onPressed: () {
                                                                goBack(context);
                                                              },
                                                              buttonText:
                                                                  "Cancel",
                                                              buttonTxtColor:
                                                                  CLR_PRIMARY,
                                                              buttonBorderColor:
                                                                  Colors
                                                                      .transparent,
                                                              buttonColor:
                                                                  BTN_CLR_ACTIVE,
                                                              buttonSizeX: 10.h,
                                                              buttonSizeY: 40.w,
                                                              buttonTextSize:
                                                                  14.sp,
                                                              buttonTextWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        SizedBox(
                                                          width: 40.w,
                                                        ),
                                                        Expanded(
                                                          child: MyAppButton(
                                                              onPressed: () {
                                                                goToData(
                                                                    context,
                                                                    oTPPAGEROUTE,
                                                                    {
                                                                      "from":
                                                                          'delete-biller',
                                                                      "templateName":
                                                                          "delete-biller-otp",
                                                                      "data": {
                                                                        "billerName": widget
                                                                            .savedBillersData
                                                                            .bILLERNAME,
                                                                        "cUSTOMERBILLID": widget
                                                                            .savedBillersData
                                                                            .cUSTOMERBILLID
                                                                            .toString()
                                                                      }
                                                                    });
                                                              },
                                                              buttonText:
                                                                  "Delete",
                                                              buttonTxtColor:
                                                                  BTN_CLR_ACTIVE,
                                                              buttonBorderColor:
                                                                  Colors
                                                                      .transparent,
                                                              buttonColor:
                                                                  CLR_PRIMARY,
                                                              buttonSizeX: 10.h,
                                                              buttonSizeY: 40.w,
                                                              buttonTextSize:
                                                                  14.sp,
                                                              buttonTextWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                ],
                                              );
                                            });
                                      })
                              ],
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 48.0.h, bottom: 16.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyAppButton(
                                      onPressed: () {
                                        goBack(context);
                                      },
                                      buttonText: "Cancel",
                                      buttonTxtColor: CLR_PRIMARY,
                                      buttonBorderColor: Color(0xff768EB9),
                                      buttonColor: widget.buttonColor,
                                      buttonSizeX: 10.h,
                                      buttonSizeY: 37.w,
                                      buttonTextSize: 14.sp,
                                      buttonTextWeight: FontWeight.w500),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: SvgPicture.asset(ICON_THREEMENU),
              ),
            ),
            if (widget.showButton)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 70.0.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      // MyAppButton(
                      //     onPressed: () {

                      //     },
                      //     buttonText: buttonText,
                      //     buttonTxtColor: buttonTxtColor,
                      //     buttonBorderColor: buttonBorderColor,
                      //     buttonColor: buttonColor,
                      //     buttonSizeX: 10.h,
                      //     buttonSizeY: 27.w,
                      //     buttonTextSize: 10.sp,
                      //     buttonTextWeight: FontWeight.w500),
                      GestureDetector(
                        onTap: () {
                          if (widget.buttonText.toString() ==
                              "Autopay Enabled") {
                            showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0.r),
                                  ),
                                ),
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        contentPadding: EdgeInsets.only(
                                            left: 8.w, right: 15.w, top: 4.h),
                                        leading: Container(
                                          width: 45.w,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.r),
                                            child: SvgPicture.asset(
                                                widget.iconPath),
                                          ),
                                        ),
                                        title: Padding(
                                          padding: EdgeInsets.only(bottom: 5.h),
                                          child: Text(
                                            widget.savedBillersData.bILLERNAME
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff191919),
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.savedBillersData
                                                  .pARAMETERVALUE
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff808080),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              "Autopay Enabled",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff00ab44),
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 0.6,
                                                blurRadius: 4,
                                                offset: Offset(0, 2)),
                                          ],
                                        ),
                                        child: Divider(
                                          height: 1.h,
                                          thickness: 1,
                                          color: Colors.grey.withOpacity(0.1),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      ModalText(
                                          title: "Last Bill Amount",
                                          subTitle: widget.savedBillersData
                                                      .bILLAMOUNT !=
                                                  null
                                              ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.savedBillersData.bILLAMOUNT!.toString()))}"
                                              : "-",
                                          context: context),
                                      ModalText(
                                          title: "Due Amount",
                                          subTitle: "₹ 500.00",
                                          context: context),
                                      ModalText(
                                          title: "Due Date",
                                          subTitle: "20/09/2023",
                                          context: context),
                                      ModalText(
                                          title: "Autopay Date",
                                          subTitle: getAllAutopayList(widget
                                                  .savedBillersData
                                                  .cUSTOMERBILLID)!
                                              .pAYMENTDATE,
                                          context: context),
                                      ModalText(
                                          title: "Debit Account",
                                          subTitle: getAllAutopayList(widget
                                                  .savedBillersData
                                                  .cUSTOMERBILLID)!
                                              .aCCOUNTNUMBER
                                              .toString(),
                                          context: context),
                                      ModalText(
                                          title: "Debit Limit",
                                          subTitle:
                                              "₹ ${NumberFormat('#,##,##0.00').format(double.parse(getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)!.mAXIMUMAMOUNT.toString()))}",
                                          context: context),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 0.h, bottom: 0.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MyAppButton(
                                                onPressed: () =>
                                                    goBack(context),
                                                buttonText: "Cancel",
                                                buttonTxtColor: CLR_PRIMARY,
                                                buttonBorderColor:
                                                    Color(0xff768EB9),
                                                buttonColor: widget.buttonColor,
                                                buttonSizeX: 10.h,
                                                buttonSizeY: 37.w,
                                                buttonTextSize: 14.sp,
                                                buttonTextWeight:
                                                    FontWeight.w500),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            goToData(context, cREATEAUTOPAYROUTE, {
                              "billerName": widget.savedBillersData.bILLERNAME,
                              "categoryName":
                                  widget.savedBillersData.cATEGORYNAME,
                              "billName": widget.savedBillersData.bILLNAME,
                              "customerBillID": widget
                                  .savedBillersData.cUSTOMERBILLID
                                  .toString(),
                              "savedInputSignatures":
                                  widget.savedBillersData.pARAMETERS,
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0.w, vertical: 4.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: widget.buttonBorderColor),
                            borderRadius: BorderRadius.circular(12.0.r),
                          ),
                          child: Text(
                            widget.buttonText.toString(),
                            style: TextStyle(
                              color: widget.buttonTxtColor,
                              fontSize: 10.0.sp,
                            ),
                          ),
                        ),
                      ),

                      // InkWell(
                      //     onTap: () => {},
                      //     child: Column(
                      //       children: [
                      //         Container(
                      //             margin: EdgeInsets.all(10),
                      //             decoration: BoxDecoration(
                      //               shape: BoxShape.circle,
                      //               border: Border.all(
                      //                 color: Color(0xffCF1E2F),
                      //                 width: 2.0,
                      //               ),
                      //             ),
                      //             child: Container(
                      //               margin: EdgeInsets.all(3),
                      //               child: Icon(Icons.warning,
                      //                   color: Color(0xffCF1E2F)),
                      //             )),
                      //       ],
                      //     ))
                    ],
                  ),
                ),
              ),
            if (!(widget.savedBillersData.cOMPLETIONDATE == null &&
                widget.savedBillersData.bILLAMOUNT == null))
              Divider(
                height: 10.h,
                thickness: 1,
                indent: 10.h,
                endIndent: 10,
              ),
            if (!(widget.savedBillersData.cOMPLETIONDATE == null &&
                widget.savedBillersData.bILLAMOUNT == null))
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 6.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(ICON_CALENDAR),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              widget.savedBillersData.cOMPLETIONDATE != null
                                  ? DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(widget
                                              .savedBillersData.cOMPLETIONDATE!
                                              .toString()
                                              .substring(0, 10))
                                          .toLocal()
                                          .add(const Duration(days: 1)))
                                  : "-",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff808080),
                                height: 20 / 12,
                              ),
                            ),
                          ],
                        ),
                        if (widget.upcomingText != "")
                          SizedBox(
                            height: 3.h,
                          ),
                        if (widget.upcomingText != "")
                          Text(
                            widget.upcomingText!,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: widget.upcomingTXT_CLR_DEFAULT,
                            ),
                            textAlign: TextAlign.center,
                          )
                      ],
                    ),
                    Text(
                      widget.savedBillersData.bILLAMOUNT != null
                          ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.savedBillersData.bILLAMOUNT!.toString()))}"
                          : "-",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1b438b),
                        height: 26 / 16,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
          ])),
    );
  }
}

Widget ModalText(
    {String? title, String? subTitle, required BuildContext context}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title!,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff808080),
          ),
          textAlign: TextAlign.left,
        ),
        Text(
          subTitle!,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xff1b438b),
          ),
          textAlign: TextAlign.left,
        )
      ],
    ),
  );
}

Widget ModalMenu(
    {String? title,
    String? iconPath,
    required BuildContext context,
    required Function onPressed}) {
  return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 8.h),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Row(
          children: [
            SvgPicture.asset(iconPath!),
            SizedBox(
              width: 15.w,
            ),
            Text(title.toString())
          ],
        ),
      ));
}
