import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:ebps/common/Button/MyAppButton.dart';
import 'package:ebps/common/Container/ImageTile.dart';
import 'package:ebps/common/Container/ReusableContainer.dart';
import 'package:ebps/constants/assets.dart';
import 'package:ebps/constants/colors.dart';
import 'package:ebps/constants/routes.dart';
import 'package:ebps/helpers/checkDateExpiry.dart';
import 'package:ebps/helpers/getDateBetweenTwoDates.dart';
import 'package:ebps/helpers/getNavigators.dart';
import 'package:ebps/helpers/numberPrefixSetter.dart';
import 'package:ebps/models/auto_schedule_pay_model.dart';
import 'package:ebps/models/prepaid_fetch_plans_model.dart';
import 'package:ebps/models/saved_biller_model.dart';
import 'package:ebps/models/upcoming_dues_model.dart';
import 'package:ebps/widget/animated_dialog.dart';
import 'package:ebps/widget/custom_dialog.dart';
import 'package:ebps/widget/custom_switch.dart';
import 'package:ebps/widget/marquee_widget.dart';
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
  final Color buttonTxtColor;
  final FontWeight? buttonTextWeight;
  final Color buttonBorderColor;
  final bool? warningBtn;
  SavedBillersData savedBillersData;
  List<PARAMETERS>? SavedinputParameters;
  bool showButton;
  List<AllConfigurations>? allautoPaymentList;
  UpcomingDuesData? upcomingDueData;
  MyBillersContainer({
    super.key,
    this.buttonText,
    required this.iconPath,
    this.upcomingText,
    this.upcomingTXT_CLR_DEFAULT,
    required this.containerBorderColor,
    this.buttonColor,
    required this.buttonTxtColor,
    required this.buttonBorderColor,
    this.buttonTextWeight,
    this.warningBtn,
    required this.showButton,
    required this.savedBillersData,
    required this.SavedinputParameters,
    required this.allautoPaymentList,
    required this.upcomingDueData,
  });

  @override
  State<MyBillersContainer> createState() => _MyBillersContainerState();
}

class _MyBillersContainerState extends State<MyBillersContainer> {
  bool switchButton = true;

  String capitalizeFirstWord(String value) {
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  var todayDate = DateTime.parse(DateTime.now().toString()).day.toString();

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

  List<PrepaidPlansData>? PrepaidPlans = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // handleDialog() {
    //   showDialog(
    //       barrierDismissible: true,
    //       context: context,
    //       builder: (context) {
    //         return WillPopScope(
    //           onWillPop: () async => false,
    //           child: AlertDialog(
    //               actions: [
    //                 Align(
    //                   alignment: Alignment.center,
    //                   child: MyAppButton(
    //                       onPressed: () {
    //                         goBack(context);
    //                       },
    //                       buttonText: "Cancel",
    //                       buttonTxtColor: BTN_CLR_ACTIVE,
    //                       buttonBorderColor: Colors.transparent,
    //                       buttonColor: CLR_PRIMARY,
    //                       buttonSizeX: 10.h,
    //                       buttonSizeY: 40.w,
    //                       buttonTextSize: 14.sp,
    //                       buttonTextWeight: FontWeight.w500),
    //                 ),
    //                 Align(
    //                   alignment: Alignment.center,
    //                   child: MyAppButton(
    //                       onPressed: () {
    //                         goBack(context);
    //                       },
    //                       buttonText: "Delete",
    //                       buttonTxtColor: BTN_CLR_ACTIVE,
    //                       buttonBorderColor: Colors.transparent,
    //                       buttonColor: CLR_PRIMARY,
    //                       buttonSizeX: 10.h,
    //                       buttonSizeY: 40.w,
    //                       buttonTextSize: 14.sp,
    //                       buttonTextWeight: FontWeight.w500),
    //                 ),
    //               ],
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(12.r),
    //               ),
    //               elevation: 3,
    //               content: SingleChildScrollView(
    //                 padding: EdgeInsets.all(20.r),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Container(
    //                         height: 50.h,
    //                         width: 50.w,
    //                         child: SvgPicture.asset(ICON_SUCCESS)),
    //                     Text(
    //                       "Are You Sure You Want To Delete",
    //                       style: TextStyle(
    //                         fontSize: 14.sp,
    //                         fontWeight: FontWeight.w400,
    //                         color: Color(0xff000000),
    //                       ),
    //                       textAlign: TextAlign.center,
    //                     )
    //                   ],
    //                 ),
    //               )),
    //         );
    //       });
    // }

    return GestureDetector(
      onTap: () {
        if (widget.savedBillersData.cATEGORYNAME!.toLowerCase() ==
            "mobile prepaid") {
          goToData(context, pREPAIDPLANSROUTE, {
            "prepaidPlans": PrepaidPlans,
            "isFetchPlans": true,
            "savedBillerData": widget.savedBillersData,
            "mobileNumber": "s",
            "operator": "",
            "circle": "",
            "billName": "ss",
            "SavedinputParameters": widget.SavedinputParameters,
            'isSavedBill': true
          });
        } else {
          goToData(context, fETCHBILLERDETAILSROUTE, {
            "name": widget.savedBillersData.bILLERNAME,
            "billName": widget.savedBillersData.bILLNAME,
            "savedBillersData": widget.savedBillersData,
            "SavedinputParameters": widget.SavedinputParameters,
            "categoryName": widget.savedBillersData.cATEGORYNAME,
            "isSavedBill": true,
          });
        }
      },
      child: ReusableContainer(
          child: Column(children: [
        ListTile(
          contentPadding:
              EdgeInsets.only(left: 8.w, right: 15.w, top: 5.h, bottom: 4.h),
          leading: ImageTileContainer(iconPath: widget.iconPath),
          title: Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 209.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.savedBillersData.bILLNAME.toString(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.TXT_CLR_PRIMARY,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        widget.savedBillersData.bILLERNAME.toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.TXT_CLR_DEFAULT,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        elevation: 20,
                      
                        backgroundColor: AppColors.CLR_BACKGROUND,
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
                                leading: ImageTileContainer(
                                  iconPath: widget.iconPath,
                                  showGradient: false,
                                ),
                                title: Padding(
                                  padding: EdgeInsets.only(bottom: 5.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: widget.upcomingText ==
                                                'Upcoming Autopay'
                                            ? 200.w
                                            : 250.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MarqueeWidget(
                                              direction: Axis.horizontal,
                                              child: Text(
                                                widget
                                                    .savedBillersData.bILLERNAME
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors
                                                        .TXT_CLR_BLACK_W,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                textAlign: TextAlign.left,
                                                maxLines: 1,
                                                softWrap: false,
                                              ),
                                            ),
                                            Text(
                                              widget.savedBillersData
                                                  .pARAMETERS![0].pARAMETERVALUE
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.TXT_CLR_LITE,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (widget.upcomingText ==
                                              'Upcoming Autopay' &&
                                          getAllAutopayList(widget
                                                      .savedBillersData
                                                      .cUSTOMERBILLID)
                                                  .pAYMENTDATE !=
                                              DateTime.now().day.toString())
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 5.h),
                                              child: Text(
                                                "Autopay",
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff808080),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            16.0.r),
                                                      ),
                                                    ),
                                                    builder: (context) {
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 15.h,
                                                                    bottom:
                                                                        15.h,
                                                                    left: 15.w,
                                                                    right:
                                                                        15.w),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)
                                                                              .iSACTIVE ==
                                                                          1
                                                                      ? Icons
                                                                          .pause_circle
                                                                      : Icons
                                                                          .play_circle,
                                                                  color: Color(
                                                                      0xff1b438b),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        20.w),
                                                                Text(
                                                                  getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)
                                                                              .iSACTIVE ==
                                                                          1
                                                                      ? "Pause Autopay"
                                                                      : "Resume Autopay",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xff1b438b),
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        0.6,
                                                                    blurRadius:
                                                                        4,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2)),
                                                              ],
                                                            ),
                                                            child: Divider(
                                                              height: 1.h,
                                                              thickness: 1,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.1),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0.h,
                                                                    bottom:
                                                                        16.h,
                                                                    left: 16.w,
                                                                    right:
                                                                        16.w),
                                                            child: Center(
                                                              child: Text(
                                                                'Are You Sure You Want To ${getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID).iSACTIVE == 1 ? "Pause Autopay" : "Resume Autopay"}?',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                      0xff000000),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0.h,
                                                                    bottom:
                                                                        16.h,
                                                                    left: 16.w,
                                                                    right:
                                                                        16.w),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child: MyAppButton(
                                                                      onPressed: () {
                                                                        goBack(
                                                                            context);
                                                                      },
                                                                      buttonText: "Cancel",
                                                                      buttonTxtColor: CLR_PRIMARY,
                                                                      buttonBorderColor: Colors.transparent,
                                                                      buttonColor: BTN_CLR_ACTIVE,
                                                                      buttonSizeX: 10.h,
                                                                      buttonSizeY: 40.w,
                                                                      buttonTextSize: 14.sp,
                                                                      buttonTextWeight: FontWeight.w500),
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
                                                                              "from": "modify-auto-pay",
                                                                              "context": context,
                                                                              "BillerName": widget.savedBillersData.bILLERNAME,
                                                                              "BillName": widget.savedBillersData.bILLNAME,
                                                                              "templateName": getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID).iSACTIVE == 1 ? "disable-auto-pay" : "enable-auto-pay",
                                                                              "autopayData": getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID),
                                                                              "data": {
                                                                                "billerName": widget.savedBillersData.bILLERNAME,
                                                                                "cUSTOMERBILLID": widget.savedBillersData.cUSTOMERBILLID.toString(),
                                                                                "status": getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID).iSACTIVE == 1 ? "0" : "1",
                                                                              }
                                                                            });
                                                                      },
                                                                      buttonText: getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID).iSACTIVE == 1 ? "Pause" : "Resume",
                                                                      buttonTxtColor: BTN_CLR_ACTIVE,
                                                                      buttonBorderColor: Colors.transparent,
                                                                      buttonColor: CLR_PRIMARY,
                                                                      buttonSizeX: 10.h,
                                                                      buttonSizeY: 40.w,
                                                                      buttonTextSize: 14.sp,
                                                                      buttonTextWeight: FontWeight.w500),
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
                                              },
                                              child: CustomSwitch(
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
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 0.2,
                                        blurRadius: 2,
                                        offset: Offset(0, 2)),
                                  ],
                                ),
                                child: Divider(
                                  height: 0.4.h,
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
                                          "customerBillID": widget
                                              .savedBillersData.cUSTOMERBILLID,
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
                                                "savedBillerData":
                                                    widget.savedBillersData,
                                                "AutoDateMisMatch": getAllAutopayList(
                                                            widget
                                                                .savedBillersData
                                                                .cUSTOMERBILLID) !=
                                                        null
                                                    ? getAllAutopayList(widget
                                                                    .savedBillersData
                                                                    .cUSTOMERBILLID)!
                                                                .rESETDATE ==
                                                            1
                                                        ? true
                                                        : false
                                                    : false,
                                                "DebitLimitMisMatch": getAllAutopayList(
                                                            widget
                                                                .savedBillersData
                                                                .cUSTOMERBILLID) !=
                                                        null
                                                    ? getAllAutopayList(widget
                                                                    .savedBillersData
                                                                    .cUSTOMERBILLID)!
                                                                .rESETLIMIT ==
                                                            1
                                                        ? true
                                                        : false
                                                    : false,
                                                "autopayData":
                                                    getAllAutopayList(widget
                                                        .savedBillersData
                                                        .cUSTOMERBILLID),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                            color: Color(
                                                                0xff1b438b),
                                                          ),
                                                          SizedBox(width: 20.w),
                                                          Text(
                                                            "Delete Autopay",
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                                                      0.2),
                                                              spreadRadius: 0.2,
                                                              blurRadius: 2,
                                                              offset:
                                                                  Offset(0, 2)),
                                                        ],
                                                      ),
                                                      child: Divider(
                                                        height: 0.4.h,
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
                                                          "Are You Sure You Want To Delete the Autopay?",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xff000000),
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
                                                                  goBack(
                                                                      context);
                                                                },
                                                                buttonText:
                                                                    "Cancel",
                                                                buttonTxtColor:
                                                                    CLR_PRIMARY,
                                                                buttonBorderColor:
                                                                    AppColors
                                                                        .BTN_CLR_ACTIVE_BORDER,
                                                                buttonColor:
                                                                    BTN_CLR_ACTIVE,
                                                                buttonSizeX:
                                                                    10.h,
                                                                buttonSizeY:
                                                                    40.w,
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
                                                                  if (todayDate ==
                                                                      getAllAutopayList(widget
                                                                              .savedBillersData
                                                                              .cUSTOMERBILLID)!
                                                                          .pAYMENTDATE) {
                                                                    showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.vertical(
                                                                            top:
                                                                                Radius.circular(16.0.r),
                                                                          ),
                                                                        ),
                                                                        builder:
                                                                            (context) {
                                                                          return Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: 15.h, bottom: 15.h, left: 15.w, right: 15.w),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.warning_rounded,
                                                                                      color: Color(0xff1b438b),
                                                                                    ),
                                                                                    SizedBox(width: 20.w),
                                                                                    Text(
                                                                                      "Delete Autopay",
                                                                                      style: TextStyle(
                                                                                        fontSize: 16.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: Color(0xff1b438b),
                                                                                      ),
                                                                                      textAlign: TextAlign.left,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  boxShadow: [
                                                                                    BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 0.2, blurRadius: 2, offset: Offset(0, 2)),
                                                                                  ],
                                                                                ),
                                                                                child: Divider(
                                                                                  height: 0.4.h,
                                                                                  thickness: 1,
                                                                                  color: Colors.grey.withOpacity(0.1),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10.h,
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: 0.h, bottom: 16.h, left: 16.w, right: 16.w),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "Autopay cannot be deleted as auto pay date is set for today",
                                                                                    style: TextStyle(
                                                                                      fontSize: 14.sp,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      color: Color(0xff000000),
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: 0.h, bottom: 16.h, left: 16.w, right: 16.w),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: MyAppButton(
                                                                                          onPressed: () {
                                                                                            goBack(context);
                                                                                          },
                                                                                          buttonText: "Okay",
                                                                                          buttonTxtColor: BTN_CLR_ACTIVE,
                                                                                          buttonBorderColor: Colors.transparent,
                                                                                          buttonColor: CLR_PRIMARY,
                                                                                          buttonSizeX: 10.h,
                                                                                          buttonSizeY: 40.w,
                                                                                          buttonTextSize: 14.sp,
                                                                                          buttonTextWeight: FontWeight.w500),
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
                                                                  } else {
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
                                                                          "context":
                                                                              context,
                                                                          "BillerName": widget
                                                                              .savedBillersData
                                                                              .bILLERNAME,
                                                                          "BillName": widget
                                                                              .savedBillersData
                                                                              .bILLNAME,
                                                                          "data":
                                                                              {
                                                                            "billerName":
                                                                                widget.savedBillersData.bILLERNAME,
                                                                            "cUSTOMERBILLID":
                                                                                widget.savedBillersData.cUSTOMERBILLID.toString(),
                                                                          }
                                                                        });
                                                                  }
                                                                  //                             goToData(context, otpRoute, {
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
                                                                buttonSizeX:
                                                                    10.h,
                                                                buttonSizeY:
                                                                    40.w,
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
                                              backgroundColor:
                                                  AppColors.CLR_BACKGROUND,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(16.0.r),
                                                ),
                                              ),
                                              builder: (context) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                            color: AppColors
                                                                .CLR_ICON,
                                                          ),
                                                          SizedBox(width: 20.w),
                                                          Text(
                                                            "Delete Biller",
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppColors
                                                                  .CLR_PRIMARY,
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
                                                                      0.2),
                                                              spreadRadius: 0.2,
                                                              blurRadius: 2,
                                                              offset:
                                                                  Offset(0, 2)),
                                                        ],
                                                      ),
                                                      child: Divider(
                                                        height: 0.4.h,
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
                                                            color: AppColors
                                                                .TXT_CLR_DEFAULT,
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
                                                                  goBack(
                                                                      context);
                                                                },
                                                                buttonText:
                                                                    "Cancel",
                                                                buttonTxtColor:
                                                                    AppColors
                                                                        .BTN_CLR_ACTIVE_ALTER_TEXT_C,
                                                                buttonBorderColor:
                                                                    AppColors
                                                                        .BTN_CLR_ACTIVE_BORDER,
                                                                buttonColor:
                                                                    AppColors
                                                                        .BTN_CLR_ACTIVE_ALTER_C,
                                                                buttonSizeX:
                                                                    10.h,
                                                                buttonSizeY:
                                                                    40.w,
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
                                                                        "context":
                                                                            context,
                                                                        "BillerName": widget
                                                                            .savedBillersData
                                                                            .bILLERNAME,
                                                                        "BillName": widget
                                                                            .savedBillersData
                                                                            .bILLNAME,
                                                                        "data":
                                                                            {
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
                                                                    AppColors
                                                                        .BTN_CLR_ACTIVE_ALTER_TEXT,
                                                                buttonBorderColor:
                                                                    Colors
                                                                        .transparent,
                                                                buttonColor:
                                                                    AppColors
                                                                        .BTN_CLR_ACTIVE_ALTER,
                                                                buttonSizeX:
                                                                    10.h,
                                                                buttonSizeY:
                                                                    40.w,
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
                              if (widget.upcomingText != 'Upcoming Autopay')
                                if (getAllAutopayList(widget
                                        .savedBillersData.cUSTOMERBILLID) !=
                                    null)
                                  if (getAllAutopayList(widget
                                              .savedBillersData.cUSTOMERBILLID)!
                                          .iSACTIVE ==
                                      0)
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24.0.w, vertical: 8.h),
                                        child: Center(
                                          child: Text(
                                            "Autopay Edit Disabled Till Autopay enables",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff808080),
                                            ),
                                          ),
                                        )),
                              // else if (getAllAutopayList(widget
                              //                 .savedBillersData
                              //                 .cUSTOMERBILLID)!
                              //             .iSACTIVE ==
                              //         1 &&
                              //     getAllAutopayList(widget
                              //                 .savedBillersData
                              //                 .cUSTOMERBILLID)!
                              //             .pAYMENTDATE ==
                              //         todayDate)
                              //   Padding(
                              //       padding: EdgeInsets.symmetric(
                              //           horizontal: 24.0.w,
                              //           vertical: 8.h),
                              //       child: Center(
                              //         child: Text(
                              //           "Autopay Edit Disabled as autopay scheduled for today",
                              //           style: TextStyle(
                              //             fontSize: 10.sp,
                              //             fontWeight: FontWeight.w400,
                              //             color: Color(0xff808080),
                              //           ),
                              //         ),
                              //       )),
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
                                        buttonTxtColor:
                                            AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                                        buttonBorderColor:
                                            AppColors.BTN_CLR_ACTIVE_BORDER,
                                        buttonColor:
                                            AppColors.BTN_CLR_ACTIVE_ALTER,
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
                  child: SvgPicture.asset(
                    ICON_THREEMENU,
                    colorFilter:
                        ColorFilter.mode(AppColors.CLR_ICON, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 110.w,
                child: Text(
                  widget.savedBillersData.cATEGORYNAME
                          .toString()
                          .toLowerCase()
                          .contains("mobile prepaid")
                      ? widget.savedBillersData.pARAMETERS!
                          .firstWhere((params) => params.pARAMETERNAME == null
                              ? params.pARAMETERNAME == null
                              : params.pARAMETERNAME.toString().toLowerCase() ==
                                      "mobile number" ||
                                  params.pARAMETERNAME
                                          .toString()
                                          .toLowerCase() ==
                                      "customer mobile number")
                          .pARAMETERVALUE
                          .toString()
                      : widget.savedBillersData.pARAMETERS![0].pARAMETERVALUE
                          .toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.TXT_CLR_LITE,
                  ),
                  maxLines: 1,
                ),
              ),
              if (widget.showButton)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        if (getAllAutopayList(
                                widget.savedBillersData.cUSTOMERBILLID) !=
                            null)
                          if (getAllAutopayList(widget
                                          .savedBillersData.cUSTOMERBILLID)
                                      .rESETDATE ==
                                  1 ||
                              getAllAutopayList(widget
                                          .savedBillersData.cUSTOMERBILLID)!
                                      .rESETLIMIT ==
                                  1)
                            AvatarGlow(
                              animate: true,
                              glowColor: Colors.red,
                              glowRadiusFactor: 0.4,
                              child: GestureDetector(
                                  onTap: () {
                                    if ((getAllAutopayList(widget
                                                        .savedBillersData
                                                        .cUSTOMERBILLID) !=
                                                    null
                                                ? getAllAutopayList(widget
                                                        .savedBillersData
                                                        .cUSTOMERBILLID)!
                                                    .pAYMENTDATE
                                                : "") ==
                                            DateTime.now().day.toString() ||
                                        getAllAutopayList(widget
                                                    .savedBillersData
                                                    .cUSTOMERBILLID)!
                                                .iSACTIVE ==
                                            0) {
                                      showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return WillPopScope(
                                              onWillPop: () async => false,
                                              child: CustomDialog(
                                                showActions: true,
                                                actions: [
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: MyAppButton(
                                                        onPressed: () {
                                                          goBack(ctx);
                                                        },
                                                        buttonText: "Okay",
                                                        buttonTxtColor:
                                                            BTN_CLR_ACTIVE,
                                                        buttonBorderColor:
                                                            Colors.transparent,
                                                        buttonColor:
                                                            CLR_PRIMARY,
                                                        buttonSizeX: 10,
                                                        buttonSizeY: 40,
                                                        buttonTextSize: 14,
                                                        buttonTextWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                                child: AnimatedDialog(
                                                    showImgIcon: false,
                                                    title: getAllAutopayList(widget
                                                                    .savedBillersData
                                                                    .cUSTOMERBILLID)!
                                                                .pAYMENTDATE ==
                                                            DateTime.now()
                                                                .day
                                                                .toString()
                                                        ? " We are unable to edit your autopay as the autopay is scheduled for today"
                                                        : "We can't edit your Autopay because it's currently paused.",
                                                    subTitle: "",
                                                    showSub: false,
                                                    shapeColor:
                                                        AppColors.CLR_ERROR,
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    )),
                                              ));
                                        },
                                      );
                                    } else {
                                      goToData(context, eDITAUTOPAYROUTE, {
                                        "savedBillerData":
                                            widget.savedBillersData,
                                        "AutoDateMisMatch": getAllAutopayList(
                                                    widget.savedBillersData
                                                        .cUSTOMERBILLID) !=
                                                null
                                            ? getAllAutopayList(widget
                                                            .savedBillersData
                                                            .cUSTOMERBILLID)!
                                                        .rESETDATE ==
                                                    1
                                                ? true
                                                : false
                                            : false,
                                        "DebitLimitMisMatch": getAllAutopayList(
                                                    widget.savedBillersData
                                                        .cUSTOMERBILLID) !=
                                                null
                                            ? getAllAutopayList(widget
                                                            .savedBillersData
                                                            .cUSTOMERBILLID)!
                                                        .rESETLIMIT ==
                                                    1
                                                ? true
                                                : false
                                            : false,
                                        "autopayData": getAllAutopayList(widget
                                            .savedBillersData.cUSTOMERBILLID),
                                      });
                                    }
                                  },
                                  child: SvgPicture.asset(ICON_ERROR)),
                            ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () {
                            if (widget.buttonText.toString() ==
                                    "Autopay Enabled" ||
                                widget.buttonText.toString() ==
                                    "Autopay Paused") {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  backgroundColor: AppColors.CLR_BACKGROUND,
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
                                          leading: ImageTileContainer(
                                            iconPath: widget.iconPath,
                                            showGradient: false,
                                          ),
                                          title: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5.h),
                                            child: Text(
                                              widget.savedBillersData.bILLERNAME
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppColors.TXT_CLR_BLACK_W,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              textAlign: TextAlign.left,
                                              maxLines: 1,
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
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.TXT_CLR_LITE,
                                                ),
                                              ),
                                              // SizedBox(
                                              //   height: 10.h,
                                              // ),
                                              // Text(
                                              //   "Autopay Enabled",
                                              //   style: TextStyle(
                                              //     fontSize: 14.sp,
                                              //     fontWeight:
                                              //         FontWeight.w500,
                                              //     color: Color(0xff00ab44),
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
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 0.2,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 2)),
                                            ],
                                          ),
                                          child: Divider(
                                            height: 0.4.h,
                                            thickness: 1,
                                            color: Colors.grey.withOpacity(0.1),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        if (widget
                                                .savedBillersData.bILLAMOUNT !=
                                            null)
                                          ModalText(
                                              title: "Last Bill Amount",
                                              subTitle: widget.savedBillersData
                                                          .bILLAMOUNT !=
                                                      null
                                                  ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.savedBillersData.bILLAMOUNT!.toString()))}"
                                                  : "-",
                                              context: context),
                                        if (widget.savedBillersData
                                                .cOMPLETIONDATE !=
                                            null)
                                          ModalText(
                                              title: "Last Paid On",
                                              subTitle: widget.savedBillersData
                                                          .cOMPLETIONDATE !=
                                                      null
                                                  ? DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.parse(widget
                                                              .savedBillersData
                                                              .cOMPLETIONDATE
                                                              .toString())
                                                          .toLocal())
                                                  : "-",
                                              context: context),
                                        if (widget.upcomingDueData != null &&
                                            widget.upcomingDueData!
                                                    .dueAmount !=
                                                null)
                                          ModalText(
                                              title: "Due Amount",
                                              subTitle: widget.upcomingDueData !=
                                                          null &&
                                                      widget.upcomingDueData!
                                                              .dueAmount !=
                                                          null
                                                  ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.upcomingDueData!.dueAmount.toString()))}"
                                                  : "-",
                                              context: context),
                                        if (widget.upcomingDueData != null &&
                                            widget.upcomingDueData!.dueDate !=
                                                null)
                                          ModalText(
                                            context: context,
                                            title: "Due Date",
                                            subTitle: (widget.upcomingDueData !=
                                                        null &&
                                                    widget.upcomingDueData!
                                                            .dueDate !=
                                                        null)
                                                ? DateFormat('dd/MM/yyyy')
                                                    .format(DateTime.parse(widget
                                                            .upcomingDueData!
                                                            .dueDate!
                                                            .toString()
                                                            .substring(0, 10))
                                                        .toLocal()
                                                        .add(const Duration(
                                                            days: 1)))
                                                : "-",
                                          ),
                                        if (getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID) !=
                                            null)
                                          if (getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID).bILLDATE != null)
                                            ModalText(
                                                title: "Bill Date",
                                                subTitle: (getAllAutopayList(widget
                                                                .savedBillersData
                                                                .cUSTOMERBILLID)
                                                            .bILLDATE !=
                                                        null)
                                                    ? DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.parse(
                                                                getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)
                                                                    .bILLDATE
                                                                    .toString()
                                                                    .substring(0, 10))
                                                            .toLocal()
                                                            .add(const Duration(days: 1)))
                                                    : "-",
                                                context: context),
                                        if (getAllAutopayList(widget
                                                .savedBillersData
                                                .cUSTOMERBILLID) !=
                                            null)
                                          if ((getAllAutopayList(widget
                                                          .savedBillersData
                                                          .cUSTOMERBILLID)!
                                                      .iSACTIVE ==
                                                  1) ||
                                              widget.upcomingText ==
                                                  'Upcoming Autopay')
                                            ModalText(
                                                title: "Autopay Date",
                                                subTitle:
                                                    '${numberPrefixSetter(getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)!.pAYMENTDATE)}${" of"}${getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)!.iSBIMONTHLY == 0 ? " every" : " every two"}${" month"}',
                                                context: context),
                                        if (getAllAutopayList(widget
                                                .savedBillersData
                                                .cUSTOMERBILLID) !=
                                            null)
                                          if (getAllAutopayList(widget
                                                          .savedBillersData
                                                          .cUSTOMERBILLID)!
                                                      .iSACTIVE ==
                                                  0 &&
                                              widget.upcomingText !=
                                                  'Upcoming Autopay')
                                            if (getAllAutopayList(widget
                                                        .savedBillersData
                                                        .cUSTOMERBILLID)!
                                                    .aCTIVATESFROM !=
                                                null)
                                              ModalText(
                                                  title: "Autopay Enables On",
                                                  subTitle: capitalizeFirstWord(
                                                      '${(getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)!.aCTIVATESFROM ?? "-").toString()}'),
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
                                              top: 0.h,
                                              bottom: 16.h,
                                              left: 16.w,
                                              right: 16.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: MyAppButton(
                                                    onPressed: () {
                                                      goBack(context);
                                                    },
                                                    buttonText: "Cancel",
                                                    buttonTxtColor: AppColors
                                                        .BTN_CLR_ACTIVE_ALTER_TEXT_C,
                                                    buttonBorderColor: AppColors
                                                        .BTN_CLR_ACTIVE_BORDER,
                                                    buttonColor: AppColors
                                                        .BTN_CLR_ACTIVE_ALTER_C,
                                                    buttonSizeX: 10.h,
                                                    buttonSizeY: 40.w,
                                                    buttonTextSize: 14.sp,
                                                    buttonTextWeight:
                                                        FontWeight.w500),
                                              ),
                                              if (getAllAutopayList(widget
                                                          .savedBillersData
                                                          .cUSTOMERBILLID)!
                                                      .iSACTIVE ==
                                                  1)
                                                SizedBox(
                                                  width: 40.w,
                                                ),
                                              if (getAllAutopayList(widget
                                                          .savedBillersData
                                                          .cUSTOMERBILLID)!
                                                      .iSACTIVE ==
                                                  1)
                                                Expanded(
                                                  child: MyAppButton(
                                                      onPressed: () {
                                                        if ((getAllAutopayList(widget
                                                                            .savedBillersData
                                                                            .cUSTOMERBILLID) !=
                                                                        null
                                                                    ? getAllAutopayList(widget
                                                                            .savedBillersData
                                                                            .cUSTOMERBILLID)!
                                                                        .pAYMENTDATE
                                                                    : "") ==
                                                                DateTime.now()
                                                                    .day
                                                                    .toString() ||
                                                            getAllAutopayList(widget
                                                                        .savedBillersData
                                                                        .cUSTOMERBILLID)!
                                                                    .iSACTIVE ==
                                                                0) {
                                                          showDialog(
                                                            barrierDismissible:
                                                                true,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    ctx) {
                                                              return WillPopScope(
                                                                onWillPop:
                                                                    () async =>
                                                                        false,
                                                                child:
    CustomDialog(showActions: true,actions: [   Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child: MyAppButton(
                                                                            onPressed: () {
                                                                              goBack(ctx);
                                                                            },
                                                                            buttonText: "Okay",
                                                                            buttonTxtColor: AppColors.BTN_CLR_ACTIVE_ALTER_TEXT,
                                                                            buttonBorderColor: Colors.transparent,
                                                                            buttonColor: AppColors.BTN_CLR_ACTIVE_ALTER,
                                                                            buttonSizeX: 10,
                                                                            buttonSizeY: 40,
                                                                            buttonTextSize: 14,
                                                                            buttonTextWeight: FontWeight.w500),
                                                                      ),],child:  AnimatedDialog(
                                                                        showImgIcon: false,
                                                                        title: getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)!.pAYMENTDATE == DateTime.now().day.toString() ? " We are unable to edit your autopay as the autopay is scheduled for today" : "We can't edit your Autopay because it's currently paused.",
                                                                        subTitle: "",
                                                                        child: Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        showSub: false,
                                                                        shapeColor: CLR_ERROR),)


                                                                 
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          goToData(
                                                              context,
                                                              eDITAUTOPAYROUTE,
                                                              {
                                                                "savedBillerData":
                                                                    widget
                                                                        .savedBillersData,
                                                                "AutoDateMisMatch": getAllAutopayList(widget
                                                                            .savedBillersData
                                                                            .cUSTOMERBILLID) !=
                                                                        null
                                                                    ? getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)!.rESETDATE ==
                                                                            1
                                                                        ? true
                                                                        : false
                                                                    : false,
                                                                "DebitLimitMisMatch": getAllAutopayList(widget
                                                                            .savedBillersData
                                                                            .cUSTOMERBILLID) !=
                                                                        null
                                                                    ? getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)!.rESETLIMIT ==
                                                                            1
                                                                        ? true
                                                                        : false
                                                                    : false,
                                                                "autopayData":
                                                                    getAllAutopayList(widget
                                                                        .savedBillersData
                                                                        .cUSTOMERBILLID),
                                                              });
                                                        }
                                                      },
                                                      buttonText:
                                                          "Edit Autopay",
                                                      buttonTxtColor: AppColors
                                                          .BTN_CLR_ACTIVE_ALTER_TEXT,
                                                      buttonBorderColor:
                                                          Colors.transparent,
                                                      buttonColor: AppColors
                                                          .BTN_CLR_ACTIVE_ALTER,
                                                      buttonSizeX: 10.h,
                                                      buttonSizeY: 40.w,
                                                      buttonTextSize: 14.sp,
                                                      buttonTextWeight:
                                                          FontWeight.w500),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              goToData(context, cREATEAUTOPAYROUTE, {
                                "billerName":
                                    widget.savedBillersData.bILLERNAME,
                                "categoryName":
                                    widget.savedBillersData.cATEGORYNAME,
                                "lastPaidAmount": widget.upcomingDueData !=
                                            null &&
                                        widget.upcomingDueData!.dueAmount !=
                                            null
                                    ? widget.upcomingDueData!.dueAmount
                                        .toString()
                                    : widget.savedBillersData.bILLAMOUNT != null
                                        ? widget.savedBillersData.bILLAMOUNT
                                            .toString()
                                        : "50000",
                                "billName": widget.savedBillersData.bILLNAME,
                                "customerBillID": widget
                                    .savedBillersData.cUSTOMERBILLID
                                    .toString(),
                                "savedBillersData": widget.savedBillersData,
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0.w, vertical: 4.w),
                            decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: widget.buttonTxtColor
                                //         .withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(10.r),
                                gradient: LinearGradient(
                                  colors: [
                                    widget.buttonTxtColor.withOpacity(0.5),
                                    // Color(0xff0373c4),
                                    Color.fromARGB(255, 212, 223, 231)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                )),
                            // decoration: BoxDecoration(
                            //   border:
                            //       Border.all(color: widget.buttonTxtColor),
                            //   borderRadius: BorderRadius.circular(12.0.r),
                            // ),
                            child: Text(
                              widget.buttonText.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.0.sp,
                                  fontWeight: FontWeight.bold),
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
            ],
          ),
          // trailing:
        ),
        // if (widget.upcomingDueData != null)
        //   if (!(widget.upcomingDueData!.dueAmount == null &&
        //       widget.upcomingDueData!.dueDate == null))
        if (widget.upcomingText != "")
          Divider(
            color: AppColors.CLR_DIVIDER_LITE,
            height: 0.h,
            thickness: 0.50,
            // indent: 10.h,
            // endIndent: 10,
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 3.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.upcomingDueData != null &&
                      widget.upcomingDueData!.dueDate != null)
                    Row(
                      children: [
                        SvgPicture.asset(ICON_CALENDAR,
                            colorFilter: ColorFilter.mode(
                                AppColors.CLR_PRIMARY_LITE, BlendMode.srcIn)),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          widget.upcomingDueData!.dueDate != null
                              ? DateFormat.yMMMMd('en_US').format(
                                  DateTime.parse(widget
                                          .upcomingDueData!.dueDate!
                                          .toString()
                                          .substring(0, 10))
                                      .toLocal()
                                      .add(const Duration(days: 1)))
                              : "-",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.CLR_PRIMARY_LITE,
                            height: 20 / 12,
                          ),
                        ),
                      ],
                    )
                  else if (widget.upcomingText == "Upcoming Autopay")
                    Row(
                      children: [
                        Icon(Icons.published_with_changes,
                            color: AppColors.CLR_PRIMARY_LITE, size: 13.r),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '${numberPrefixSetter(getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)!.pAYMENTDATE)}${" of"}${getAllAutopayList(widget.savedBillersData.cUSTOMERBILLID)!.iSBIMONTHLY == 0 ? " every" : " every two"}${" month"}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.CLR_PRIMARY_LITE,
                            height: 20 / 12,
                          ),
                        ),
                      ],
                    ),
                  if (widget.upcomingText != "")
                    Text(
                      widget.upcomingText!.toLowerCase() == "upcoming due" &&
                              (widget.upcomingDueData != null &&
                                  widget.upcomingDueData!.dueDate != null) &&
                              checkDateExpiry(
                                  widget.upcomingDueData!.dueDate!.toString())
                          ? "Overdue by ${daysBetween((DateTime.parse(widget.upcomingDueData!.dueDate!.toString()).add(Duration(days: 1))), DateTime.now())} ${daysBetween((DateTime.parse(widget.upcomingDueData!.dueDate!.toString()).add(Duration(days: 1))), DateTime.now()) == 1 ? "Day" : "Days"}"
                          : widget.upcomingText!,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.upcomingText!.toLowerCase() ==
                                    "upcoming due" &&
                                (widget.upcomingDueData != null &&
                                    widget.upcomingDueData!.dueDate != null) &&
                                checkDateExpiry(
                                    widget.upcomingDueData!.dueDate!.toString())
                            ? AppColors.CLR_ERROR
                            : widget.upcomingTXT_CLR_DEFAULT,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (widget.upcomingText != "")
                    if (widget.upcomingDueData != null)
                      if (widget.upcomingDueData!.dueDate != null)
                        SizedBox(
                          height: 3.h,
                        ),
                ],
              ),
              if (widget.upcomingDueData != null)
                if (widget.upcomingDueData!.dueAmount != null)
                  Text(
                    widget.upcomingDueData!.dueAmount != null
                        ? "₹ ${NumberFormat('#,##,##0.00').format(double.parse(widget.upcomingDueData!.dueAmount.toString()))}"
                        : "-",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.CLR_ICON,
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
            color: AppColors.TXT_CLR_LITE,
          ),
          textAlign: TextAlign.left,
        ),
        Text(
          subTitle! ?? "-",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.TXT_CLR_PRIMARY,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 20.w,
              child: SvgPicture.asset(
                iconPath!,
                colorFilter:
                    ColorFilter.mode(AppColors.CLR_ICON, BlendMode.srcIn),
              ),
            ),
            // SvgPicture.asset(iconPath!,
            //     height: 15.h, width: 15.w, fit: BoxFit.contain),
            SizedBox(
              width: 15.w,
            ),
            Text(
              title.toString(),
              style: TextStyle(color: AppColors.CLR_PRIMARY, fontSize: 14.sp),
            )
          ],
        ),
      ));
}
